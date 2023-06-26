#! /bin/bash
# Setup tools
# Update
apt update

# Install Subfinder
echo "Installing Subfinder ..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Install Assetfinder
echo "Installing Assetfinder ..."
go install -v github.com/tomnomnom/assetfinder@latest

# Install Waybackurls
echo "Installing Waybackurls ..."
go install -v github.com/tomnomnom/waybackurls@latest

# Install Nuclei
echo "Installing Nuclei ..."
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

# Install Dirsearch
echo "Installing dirsearch ..."
git clone https://github.com/maurosoria/dirsearch.git
cd dirsearch
pip install -r requirements.txt
cd ..

## Install bhedak
echo "Installing bhedak ..."
pip3 install bhedak

## Install GF
echo "Installing gf ..."
go install -v github.com/tomnomnom/gf@latest
cd /root/go-workspace/bin
cp gf /usr/local/bin
cd
git clone https://github.com/1ndianl33t/Gf-Patterns
mkdir .gf
cd /root/Gf-Patterns
cp * /root/.gf
cd

# Install Knockpy
git clone https://github.com/guelfoweb/knock.git
cd knock
pip3 install -r requirements.txt
cd

# Installing Excels requirements
pip install csvkit
pip install pandas

echo "Installation Completed...!" 
