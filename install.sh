#!/bin/bash

cat <<"EOF"

/===============================================================\
||   /$$                                       /$$               ||      
||  | $$                                      | $$               ||
||  | $$$$$$$   /$$$$$$  /$$   /$$ /$$$$$$$  /$$$$$$   /$$   /$$ ||
||  | $$__  $$ /$$__  $$| $$  | $$| $$__  $$|_  $$_/  | $$  | $$ ||
||  | $$  \ $$| $$  \ $$| $$  | $$| $$  \ $$  | $$    | $$  | $$ ||
||  | $$  | $$| $$  | $$| $$  | $$| $$  | $$  | $$ /$$| $$  | $$ ||
||  | $$$$$$$/|  $$$$$$/|  $$$$$$/| $$  | $$  |  $$$$/|  $$$$$$$ ||
||  |_______/  \______/  \______/ |__/  |__/   \___/   \____  $$ ||
||                                                     /$$  | $$ ||
||                                                    |  $$$$$$/ ||
||                                                     \______/  ||
||                                                               ||
||                                                               ||
||        Made with ❤️ by Pugalarasan - aka 🧑‍💻 litt1eb0y        ||
||      Run this script against your target to earn 💰💰💰       ||
 \===============================================================/
EOF

mkdir -p ~/bounty.sh/tools
mkdir -p ~/bounty.sh/wordlists

cd Tools

echo "Installing essentials..."
sleep 1
sudo apt update
sudo apt upgrade -y
sudo apt -y install git 
sudo apt -y install python3 
sudo apt -y install python3-pip
sudo apt install python2
sudo pip3 install colored
sudo apt-get install jq
sudo pip3 install tldextract
sudo apt-get install cargo
sudo apt install eyewitness
sudo pip3 install requests
suod pip3 install dnspython
sudo pip3 install argparse
sudo apt install nmap
sudo  pip3 install as3nt
sudo apt install -y libpcap-dev
sudo pip3 install arjun
sudo pip3 install uro

sleep 1

echo "Installing Golang..."
sys=$(uname -m)
LATEST=$(curl -s 'https://go.dev/VERSION?m=text')
[ $sys == "x86_64" ] && wget https://golang.org/dl/$LATEST.linux-amd64.tar.gz -O golang.tar.gz &>/dev/null || wget https://golang.org/dl/$LATEST.linux-386.tar.gz -O golang.tar.gz &>/dev/null
sudo tar -C /usr/local -xzf golang.tar.gz
echo "export GOROOT=/usr/local/go" >> $HOME/.bashrc
echo "export GOPATH=$HOME/go" >> $HOME/.bashrc
echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> $HOME/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.profile

echo ""

echo "Installing tools..."

go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest;
echo ""

go get -u github.com/tomnomnom/assetfinder
echo ""

go install -v github.com/OWASP/Amass/v3/...@master
echo ""

cd ~/bounty.sh/Tools/
wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux; chmod +x findomain-linux; sudo cp findomain-linux /usr/local/bin
echo ""

go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
echo ""

cd ~/bounty.sh/Tools/
wget "https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip" && unzip aquatone_linux_amd64_1.7.0.zip && sudo mv aquatone_linux_amd64_1.7.0 /usr/local/bin
echo ""

go install github.com/hakluke/hakrawler@latest;
echo ""

go install github.com/tomnomnom/waybackurls@latest;
echo ""

go install github.com/lc/gau/v2/cmd/gau@latest;
echo ""

go install github.com/003random/getJS@latest;
echo ""

cd ~/bounty.sh/Tools/
git clone https://github.com/devanshbatham/ParamSpider.git; cd ParamSpider; pip3 install -r requirements.txt
echo ""

go install github.com/ffuf/ffuf@latest
echo ""

cd ~/bounty.sh/Tools/
git clone https://github.com/s0md3v/Corsy.git
cd Corsy
pip3 install -r requirements.txt
echo ""

cd ~/bounty.sh/Tools/
git clone https://github.com/MichaelStott/CRLF-Injection-Scanner.git
cd CRLF-Injection-Scanner
sudo python3 setup.py install
echo ""

cd ~/bounty.sh/Tools/
git clone https://github.com/defparam/smuggler.git; cd smuggler/
echo ""

go install github.com/tomnomnom/qsreplace@latest;
echo ""

cd ~/bounty.sh/Tools/
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
echo ""

go install github.com/hahwul/dalfox/v2@latest;
echo ""

cd ~/bounty.sh/Tools/
git clone https://github.com/dwisiswant0/findom-xss.git --recurse-submodules
echo ""

cd ~/bounty.sh/Tools/
git clone https://github.com/internetwache/GitTools.git
echo ""

cd ~/bounty.sh/Tools/
git clone https://github.com/SharonBrizinov/s3viewer.git
echo ""

go get github.com/haccer/subjack
echo ""

go get github.com/Ice3man543/SubOver
echo ""

go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
echo ""

cd ~/bounty.sh/Tools/
git clone https://github.com/edoardottt/cariddi.git; cd cariddi; go get; make linux
echo ""

go install github.com/tomnomnom/httprobe@latest
echo ""

echo "###########################################################################################"
echo "###########################################################################################"
echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Happy Hacking~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo "###########################################################################################"
echo ""
echo "*****************************This Tool is in under Devepement******************************"
echo ""
echo "###########################################################################################"
