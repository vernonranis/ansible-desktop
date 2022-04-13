#!bin/sh

# echo highlights
RED='\033[0;31m'
NC='\033[0m'  # No Color

echo -e "${RED}Updating Packages${NC}"
sudo dnf update -y && sudo dnf upgrade -y

echo -e "${RED}Adding Repositories${NC}"
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm # VLC Repo
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm # VLC Repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc # VS Code
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' # VS Code

echo -e "${RED}Updating Packages${NC}"
sudo dnf update -y && sudo dnf upgrade -y

echo -e "${RED}Installing Packages${NC}"
sudo dnf install -y python3-psutil vlc vim-enhanced transmission-daemon transmission-cli tmux make ansible code

curl -sS https://starship.rs/install.sh | sh

curl -fsSL https://get.docker.com -o get-docker.sh && DRY_RUN=1 sh ./get-docker.sh
