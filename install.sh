#!bin/sh

# echo highlights
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${RED}Creating user & group vernon${NC}"

# use this command to hash a plain text password
# sauce: https://www.cyberciti.biz/tips/howto-write-shell-script-to-add-user.html
# perl -e 'print crypt("R1ghtN0w@321!??", "salt"), "\n"'
sudo groupadd -g 1001 vernon
sudo useradd -m -u 1001 -g vernon -p veqiR4DDR5eyQ vernon
sudo echo "vernon ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers.d/vernon
sudo hostnamectl set-hostname devenv

# Use below for users required password
# sudo echo "vernon ALL=(ALL) PASSWD: ALL" >> /etc/sudoers.d/vernon
echo -e "${RED}Finished Creating user & group vernon${NC}"

echo -e "${RED}Creating user & group grace${NC}"
sudo groupadd -g 1002 grace
sudo useradd -m -u 1002 -g grace -p sajT/iOTfayOc grace
sudo echo "grace ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers.d/grace
# Use below for users required password
# sudo echo "vernon ALL=(ALL) PASSWD: ALL" >> /etc/sudoers.d/vernon
echo -e "${RED}Finished Creating user & group grace${NC}"

echo -e "${RED}adding multimedia codecs${NC}"
sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate -y sound-and-video
echo -e "${RED}Finished adding multimedia codecs${NC}"

echo -e "${RED}Enabling Fastest Mirror, Parallel Package Downloads and System Default to Yes${NC}"
echo -e "fastestmirror=True\nmax_parallel_downloads=10\ndefaultyes=True\nkeepcache=True" >>/etc/dnf/dnf.conf

echo -e "${RED}Copying dot files${NC}"
# \ forces to copy and overwrite without user input
dotpath=$(sudo find / -name ansible-desktop)
\cp -R $dotpath/files/.bashrc /home/vernon/.bashrc
\cp -R $dotpath/files/.tmux.conf /home/vernon/.tmux.conf
\cp -R $dotpath/files/.vimrc /home/vernon/.vimrc
mkdir -p /home/vernon/.ssh/
\cp -R $dotpath/files/ssh-config /home/vernon/.ssh/config
echo -e "${RED}Finished copying dot files${NC}"

echo -e "${RED}Updating Packages${NC}"
sudo dnf update -y && sudo dnf upgrade -y

echo "insecure" >>/home/vernon/.curlrc

echo -e "${RED}Adding Repositories${NC}"
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm                                                                                                            # VLC Repo
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm                                                                                                      # VLC Repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc                                                                                                                                                            # VS Code
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' # VS Code
sudo dnf groupupdate -y core
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


echo -e "${RED}Updating Packages${NC}"
sudo dnf update -y && sudo dnf upgrade -y

echo -e "${RED}Installing Packages${NC}"
sudo dnf makecache --refresh
# below is desktop setup
sudo dnf install -y python3-psutil vlc vim-enhanced transmission-daemon transmission-cli tmux make ansible code wget filezilla thunderbird qbittorrent ranger lsd dnf-plugins-core

# vs-code, vlc removed because not required for a terminal setup.
# sudo dnf install -y python3-psutil vim-enhanced transmission-daemon transmission-cli tmux make ansible wget

echo -e "${RED}Finished Installing Packages${NC}"

echo -e "${RED}Installing Brave Browser${NC}"
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install -y brave-browser
echo -e "${RED}Finished Installing Brave Browser${NC}"

echo -e "${RED}Installing Python 3.10${NC}"
sudo yum groupinstall "Development Tools" -y
sudo yum install -y openssl-devel libffi-devel bzip2-devel wget
wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
tar xvf Python-3.10.0.tgz
cd Python-3.10.0
./configure --enable-optimizations
sudo make altinstall
echo -e "${RED}Finished Installing Python 3.10${NC}"

echo -e "${RED}Configuring Ranger${NC}"
ranger --copy-config=all
mkdir -p /home/vernon/.config/ranger/
\cp -R /root/.config/ranger/ /home/vernon/.config/
sed -i 's/set show_hidden false/set show_hidden true/g' /home/vernon/.config/ranger/rc.conf
echo -e "${RED}Finished Configuring Ranger${NC}"

echo -e "${RED}Installing NVM${NC}"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
nvm install v16.14.2
cp -R /root/.nvm /home/vernon/.nvm
cp -R /root/.nvm /home/fedora/.nvm
chown -R vernon:vernon /home/vernon/.nvm
chown -R fedora:fedora /home/fedora/.nvm
echo -e "${RED}Finished Installing NVM${NC}"

echo -e "${RED}Installing Docker${NC}"
sudo yum install -y yum-utils
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo chgrp vernon /var/run/docker.sock
sudo mkdir -p /etc/systemd/system/docker.service.d/
# this is where you add your proxy
sudo touch /etc/systemd/system/docker.service.d/http-proxy.conf
sudo systemctl daemon-reload
sudo systemctl restart docker.service
echo -e "${RED}Finished Installing Docker${NC}"

echo -e "${RED}Installing Docker Compose${NC}"
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
echo -e "${RED}Finished Installing Docker Compose${NC}"

echo -e "${RED}Installing Starship${NC}"
curl -sS https://starship.rs/install.sh | sh -s -- -y
source /home/vernon/.bashrc
echo -e "${RED}Finished Installing Starship${NC}"

echo -e "${RED}Installing Qtile${NC}"
sudo dnf -y copr enable frostyx/qtile
sudo dnf install -y qtile
sudo dnf install -y qtile-extras
mkdir -p /home/vernon/.config/qtile/
\cp -R $dotpath/files/qtile_config.py /home/vernon/.config/qtile/config.py
echo -e "${RED}Finished Installing Qtile${NC}"

echo -e "${RED}Installing Terminus Font${NC}"
sudo curl -L -o /home/fedora/ https://files.ax86.net/terminus-ttf/files/latest.zip
unzip /home/fedora/latest.zip
mkdir /usr/share/fonts/terminus/
cp /home/fedora/terminus-ttf-4.49.2/TerminusTTF-4.49.2.ttf /usr/share/fonts/terminus/
sudo fc-cache -f -v
echo -e "${RED}Finished Installing Terminus Font${NC}"

source /root/.bashrc
source /home/vernon/.bashrc

echo -e "${RED}Start Changing ownership of the files ${NC}"
chown -R vernon:vernon /home/vernon/
echo -e "${RED}Finished Changing ownership of the files ${NC}"

echo -e "${RED}Installing Python base Packages${NC}"
pip install black
echo -e "${RED}Finished Installing Python base Packages${NC}"

echo -e "${RED}Rebooting System${NC}"
sudo reboot
