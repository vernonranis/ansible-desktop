#!bin/sh

RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${RED}Installing PIP packages to user${NC}"
sudo -u vernon pip install --user flake8 bandit
echo -e "${RED}Finished Installing PIP packages to user${NC}"

echo -e "${RED}Rebooting System${NC}"
sudo reboot
