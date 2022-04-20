#!bin/sh

# echo highlights
RED='\033[0;31m'
NC='\033[0m'  # No Color

echo -e "${RED}Creating user & group vernon${NC}"
sudo groupadd -g 1001 vernon
sudo useradd -m -u 1001 -g vernon vernon 
sudo echo "vernon ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/vernon

echo -e "${RED}Enabling Fastest Mirror, Parallel Package Downloads and System Default to Yes${NC}"
echo -e "fastestmirror=True\nmax_parallel_downloads=10\ndefaultyes=True" >> /etc/dnf/dnf.conf

echo -e "${RED}Copying dot files${NC}"
# \ forces to copy and overwrite without user input
dotpath=$(sudo find / -name ansible-desktop)
\cp -R $dotpath/files/bashrc /home/vernon/.bashrc
\cp -R $dotpath/files/.tmux.conf /home/vernon/.tmux.conf
\cp -R $dotpath/files/.vimrc /home/vernon/.vimrc
mkdir -p /home/vernon/.ssh/
\cp -R $dotpath/files/ssh-config /home/vernon/.ssh/config
echo -e "${RED}Finished copying dot files${NC}"

echo -e "${RED}Updating Packages${NC}"
sudo dnf update -y && sudo dnf upgrade -y

echo "insecure" >> /home/vernon/.curlrc

echo -e "${RED}Adding Repositories${NC}"
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm # VLC Repo
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm # VLC Repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc # VS Code
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' # VS Code

echo -e "${RED}Updating Packages${NC}"
sudo dnf update -y && sudo dnf upgrade -y

echo -e "${RED}Installing Packages${NC}"
# below is desktop setup
# sudo dnf install -y python3-psutil vlc vim-enhanced transmission-daemon transmission-cli tmux make ansible code

# vs-code, vlc removed because not required for a terminal setup. 
sudo dnf install -y python3-psutil vim-enhanced transmission-daemon transmission-cli tmux make ansible wget


echo -e "${RED}Installing Python 3.10${NC}"
sudo yum groupinstall "Development Tools" -y
sudo yum install -y openssl-devel libffi-devel bzip2-devel wget
wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
tar xvf Python-3.10.0.tgz
cd Python-3.10.0
./configure --enable-optimizations
sudo make altinstall
echo -e "${RED}Finished Installing Python 3.10${NC}"

echo -e "${RED}Installing NVM${NC}"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
cp -R /root/.nvm /home/vernon/.nvm
cp -R /root/.nvm /home/fedora/.nvm
chown -R vernon:vernon /home/vernon/.nvm
chown -R fedora:fedora /home/fedora/.nvm
nvm install v16.14.2
echo -e "${RED}Finished Installing NVM${NC}"

echo -e "${RED}Installing Starship${NC}"
curl -sS https://starship.rs/install.sh | sh -s -- -y
source /home/vernon/.bashrc
echo -e "${RED}Finished Installing Starship${NC}"

source /root/.bashrc
source /home/vernon/.bashrc

echo -e "${RED}Switching User to vernon${NC}"
sudo su vernon -c'sh ./install2.sh'
