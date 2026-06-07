#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()  { echo -e "\033[1;34m[INFO]\033[0m  $*"; }
ok()    { echo -e "\033[1;32m[ OK ]\033[0m  $*"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m  $*"; }

# ─── System packages ─────────────────────────────────────────────────────────
info "Installing system packages..."
sudo pacman -S --needed --noconfirm \
  stow fzf eza zoxide base-devel curl wget git \
  ttf-jetbrains-mono-nerd \
  ghostty \
  docker docker-compose kubectl helm k9s \
  ripgrep bat fd github-cli lazygit git-delta tldr
ok "System packages ready"

info "Enabling Docker..."
sudo systemctl enable docker
sudo usermod -aG docker "$USER"
ok "Docker enabled (reboot required to use without sudo)"

# ─── Performance tweaks ──────────────────────────────────────────────────────
info "Applying sysctl performance tweaks..."
sudo tee /etc/sysctl.d/99-performance.conf > /dev/null << 'EOF'
vm.swappiness = 10
vm.max_map_count = 262144
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 512
net.core.somaxconn = 65535
EOF
sudo sysctl --system --quiet
ok "sysctl applied"

info "Adding noatime to fstab root mount..."
if ! grep -q "noatime" /etc/fstab; then
  sudo sed -i '/ext4.*defaults/s/defaults/defaults,noatime/' /etc/fstab
  ok "fstab updated"
else
  ok "noatime already present in fstab"
fi

info "Setting power profile to balanced..."
powerprofilesctl set balanced
ok "Power profile: balanced"

# ─── Mirrors ─────────────────────────────────────────────────────────────────
info "Optimizing pacman mirrors..."
sudo pacman-mirrors --fasttrack 5 && sudo pacman -Syy
ok "Mirrors optimized"

if [[ ! -f /etc/systemd/system/pacman-mirrors-update.timer ]]; then
  sudo tee /etc/systemd/system/pacman-mirrors-update.service > /dev/null << 'UNIT'
[Unit]
Description=Update pacman mirrorlist with fastest mirrors
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/pacman-mirrors --fasttrack 5
ExecStartPost=/usr/bin/pacman -Syy
UNIT

  sudo tee /etc/systemd/system/pacman-mirrors-update.timer > /dev/null << 'UNIT'
[Unit]
Description=Monthly pacman mirror refresh

[Timer]
OnCalendar=monthly
Persistent=true

[Install]
WantedBy=timers.target
UNIT

  sudo systemctl enable --now pacman-mirrors-update.timer
  ok "Monthly mirror refresh timer enabled"
fi

# ─── Timeshift ───────────────────────────────────────────────────────────────
info "Configuring Timeshift snapshots..."
ROOT_UUID=$(lsblk -o UUID,MOUNTPOINT | awk '$2=="/" {print $1}')
sudo mkdir -p /etc/timeshift
sudo tee /etc/timeshift/timeshift.json > /dev/null << TSJSON
{
  "backup_device_uuid" : "$ROOT_UUID",
  "do_first_run" : "false",
  "btrfs_mode" : "false",
  "schedule_monthly" : "true",
  "schedule_weekly" : "false",
  "schedule_daily" : "false",
  "schedule_hourly" : "false",
  "schedule_boot" : "false",
  "count_monthly" : "3",
  "count_weekly" : "0",
  "count_daily" : "0",
  "count_hourly" : "0",
  "count_boot" : "0",
  "exclude" : [
    "+ /root/**",
    "+ /home/**",
    "- /home/*/.cache/**",
    "- /home/*/Downloads/**",
    "- /home/*/.local/share/Trash/**",
    "- /home/*/.npm/**",
    "- /home/*/.m2/**",
    "- /home/*/.gradle/**",
    "- /var/cache/pacman/pkg/**",
    "- /tmp/**",
    "- /var/tmp/**"
  ],
  "exclude-apps" : []
}
TSJSON
ok "Timeshift configured (run 'sudo timeshift --create' for first snapshot)"

# ─── mise (Node + Python) ────────────────────────────────────────────────────
if ! command -v mise &>/dev/null && [[ ! -f "$HOME/.local/bin/mise" ]]; then
  info "Installing mise..."
  curl https://mise.run | sh
  ok "mise installed"
else
  ok "mise already installed"
fi

# ─── sdkman (Java) ───────────────────────────────────────────────────────────
if [[ ! -d "$HOME/.sdkman" ]]; then
  info "Installing sdkman..."
  curl -s "https://get.sdkman.io" | bash
  ok "sdkman installed"
else
  ok "sdkman already installed"
fi

# ─── starship ────────────────────────────────────────────────────────────────
if ! command -v starship &>/dev/null; then
  info "Installing starship..."
  curl -sS https://starship.rs/install.sh | sudo sh -s -- --yes
  ok "starship installed"
else
  ok "starship already installed"
fi

# ─── Stow dotfiles ───────────────────────────────────────────────────────────
info "Symlinking dotfiles with stow..."

# Back up existing files that stow would conflict with
for f in ~/.zshrc ~/.gitconfig; do
  if [[ -f "$f" && ! -L "$f" ]]; then
    warn "Backing up existing $f → $f.bak"
    mv "$f" "$f.bak"
  fi
done

mkdir -p ~/.config/git ~/.config/mise ~/.config/nvim ~/.config/ghostty

cd "$DOTFILES_DIR"
for module in zsh mise git starship nvim ghostty; do
  stow -v --restow "$module"
  ok "stowed: $module"
done

ok ""
ok "Done! Open a new shell to load everything."
ok "Next steps:"
ok "  sdk install java 21-tem   # install Java 21"
ok "  mise use -g node@lts      # set global Node LTS"
ok "  mise use -g python@3.12   # set global Python"
