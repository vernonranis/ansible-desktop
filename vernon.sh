echo -e "${RED}Installing PIP packages to user${NC}"
pip install --user flake8
pip install --user bandit
echo -e "${RED}Finished Installing PIP packages to user${NC}"

echo -e "${RED}Rebooting System${NC}"
sudo reboot
