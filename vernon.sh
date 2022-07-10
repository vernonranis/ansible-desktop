#!bin/sh

RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${RED}whoami testing${NC}"
cd /home/vernon/
whoami
pwd
echo -e "${RED}finished whoami testing${NC}"


echo -e "${RED}Installing PIP packages to user${NC}"
sudo -H pip install --user flake8 bandit
echo -e "${RED}Finished Installing PIP packages to user${NC}"

echo -e "${RED}whoami testing${NC}"
cd /home/vernon/
whoami
pwd
echo -e "${RED}finished whoami testing${NC}"

echo -e "${RED}Rebooting System${NC}"
sudo reboot
