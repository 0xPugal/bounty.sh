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

mkdir -p ~/bounty.sh/Tools
cd Tools

echo ""
echo "-------------------------"
echo "...Installing Packages..."
echo "-------------------------"
sleep 1
sudo apt update
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
sudo apt install -y awscli

sleep 1
echo "-----------------"
echo "Installing Golang"
echo "-----------------"
wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz
sudo tar -xvf go1.13.4.linux-amd64.tar.gz
sudo mv go /usr/local
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
echo 'export GOPATH=$HOME/go'	>> ~/.bashrc			
echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

sleep 1
echo ""
echo ""
echo "----------------------"
echo "...Installing Tools..."
echo "----------------------"
sleep 1

echo ""
echo "--------------------------"
echo "...Installing Sublist3r..."
echo "--------------------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r/
pip3 install -r requirements.txt
cd ../
echo ""
sleep 1

echo "----------------------------"
echo "...Installing Turbolist3r..."
echo "----------------------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/fleetcaptain/Turbolist3r
cd Turbolist3r
pip3 install -r requirements.txt
cd ../
echo ""
sleep 1

echo "-----------------------"
echo "...Installing Sudomy..."
echo "-----------------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/screetsec/Sudomy.git
cd Sudomy
pip3 install -r requirements.txt
cd ../
echo ""
sleep 1

echo "--------------------------"
echo "...Installing SubFinder..."
echo "--------------------------"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
sudo cp ~/go/bin/subfinder /usr/local/bin
echo ""
sleep 1

echo "----------------------------"
echo "...Installing AssetFinder..."
echo "----------------------------"
go get -u github.com/tomnomnom/assetfinder
sudo cp ~/go/bin/assetfinder /usr/local/bin
echo ""
sleep 1

echo "-----------------------"
echo "...Installing Scilla..."
echo "-----------------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/edoardottt/scilla.git
cd scilla
go get
make linux
cd ../
echo ""
sleep 1

echo "----------------------"
echo "...Installing Amass..."
echo "----------------------"
go install -v github.com/OWASP/Amass/v3/...@master
sudo cp ~/go/bin/amass /usr/local/bin
echo ""
sleep 1

echo "-------------------------------------"
echo "...Installing Censys_subdom_finder..."
echo "-------------------------------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/christophetd/censys-subdomain-finder.git
cd censys-subdomain-finder/
python3 -m venv
source venv/bin/activate
pip3 install -r requirements.txt
echo ""
sleep 1

echo "--------------------------"
echo "...Installing Findomain..."
echo "--------------------------"
cd ~/bounty.sh/Tools/
wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux
chmod +x findomain-linux
sudo cp findomain-linux /usr/local/bin
echo ""
sleep 1

echo "-----------------------"
echo "...Installing Dnscan..."
echo "-----------------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/rbsec/dnscan.git
pip3 install -r requirements.txt
echo ""
sleep 1

echo "---------------------------"
echo "...Installing ShuffleDns..."
echo "---------------------------"
go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
sudo cp ~/go/bin/shuffledns /usr/local/bin
echo ""
sleep 1

echo "----------------------"
echo "...Installing Naabu..."
echo "----------------------"
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
sudo cp ~/go/bin/naabu /usr/local/bin
echo ""
sleep 1

echo "-------------------------"
echo "...Installing Aquatone..."
echo "-------------------------"
cd ~/bounty.sh/Tools/
wget "https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip"
unzip aquatone_linux_amd64_1.7.0.zip
sudo mv aquatone_linux_amd64_1.7.0 /usr/local/bin
echo ""
sleep 1

echo "--------------------------"
echo "...Installing Hakrawler..."
echo "--------------------------"
go install github.com/hakluke/hakrawler@latest
sudo cp ~/go/bin/hakrawler /usr/local/bin
echo ""
sleep 1

echo "----------------------------"
echo "...Installing Waybackurls..."
echo "----------------------------"
go install github.com/tomnomnom/waybackurls@latest
sudo cp ~/go/bin/waybackurls /usr/local/bin
echo ""
sleep 1

echo "--------------------"
echo "...Installing Gau..."
echo "--------------------"
go install github.com/lc/gau/v2/cmd/gau@latest
sudo cp ~/go/bin/gau /usr/local/bin
echo ""
sleep 1

echo "----------------------"
echo "...Installing getJS..."
echo "----------------------"
go install github.com/003random/getJS@latest
sudo cp ~/go/bin/getJS /usr/local/bin
echo ""
sleep 1

echo "------------------------"
echo "...Installing GauPlus..."
echo "------------------------"
go install github.com/bp0lr/gauplus@latest
sudo cp ~/go/bin/gauplus /usr/local/bin
echo ""
sleep 1

echo "----------------------------"
echo "...Installing ParamSpider..."
echo "----------------------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/devanshbatham/ParamSpider.git
cd ParamSpider
pip3 install -r requirements.txt
echo ""
sleep 1

echo "---------------------"
echo "...Installing FFUF..."
echo "---------------------"
go install github.com/ffuf/ffuf@latest
sudo cp ~/go/bin/ffuf /usr/local/bin
echo ""
sleep 1

echo "----------------------"
echo "...Installing Corsy..."
echo "----------------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/s0md3v/Corsy.git
cd Corsy
pip3 install -r requirements.txt
cd ../
echo ""
sleep 1

echo "-----------------------------"
echo "...Installing CRLF Scanner..."
echo "-----------------------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/MichaelStott/CRLF-Injection-Scanner.git
cd CRLF-Injection-Scanner
sudo python3 setup.py install
cd ../
echo ""
sleep 1

echo "-------------------------"
echo "...Installing Smuggler..."
echo "-------------------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/defparam/smuggler.git
cd smuggler/
cd ../
echo ""
sleep 1

echo "-----------------------"
echo "Installing QSReplace..."
echo "-----------------------"
go install github.com/tomnomnom/qsreplace@latest
sudo cp ~/go/bin/qsreplace /usr/local/bin
echo ""
sleep 1

echo "-----------------------"
echo "...Installing SQLmap..."
echo "-----------------------"
cd ~/bounty.sh/Tools/
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
echo ""
sleep 1

echo "-----------------------"
echo "...Installing Dalfox..."
echo "-----------------------"
go install github.com/hahwul/dalfox/v2@latest
sudo cp ~/go/bin/dalfox /usr/local/bin
echo ""
sleep 1

echo "----------------"
echo "...findom-xss..."
echo "----------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/dwisiswant0/findom-xss.git --recurse-submodules
echo ""
sleep 1

echo "-------------------------"
echo "...Installing GitTools..."
echo "-------------------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/internetwache/GitTools.git
cd ../
echo ""
sleep 1

echo "-------------------------"
echo "...Installing S3viewer..."
echo "-------------------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/SharonBrizinov/s3viewer.git
cd ../
echo ""
sleep 1

echo "------------------------"
echo "...Installing SUbjack..."
echo "------------------------"
go get github.com/haccer/subjack
sudo cp ~/go/bin/subjack /usr/local/bin
echo ""
sleep 1

echo "------------------------"
echo "...Installing SUbOver..."
echo "------------------------"
go get github.com/Ice3man543/SubOver
sudo cp ~/go/bin/SubOver /usr/local/bin
echo ""
sleep 1

echo "-----------------------"
echo "...Installing sub404..."
echo "-----------------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/r3curs1v3-pr0xy/sub404.git
cd sub404
pip3 install -r requirements.txt
cd ../
echo ""
sleep 1

echo "-----------------------"
echo "...Installing Nuclei..."
echo "-----------------------"
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
sudo cp ~/go/bin/nuclei /usr/local/bin
echo ""
sleep 1

echo "------------------------"
echo "...Installing Cariddi..."
echo "------------------------"
cd ~/bounty.sh/Tools/
git clone https://github.com/edoardottt/cariddi.git
cd cariddi
go get
make linux
cd ../
echo ""
sleep 1

echo "-------------------------"
echo "...Installing HTTProbe..."
echo "-------------------------"
go install github.com/tomnomnom/httprobe@latest
sudo cp ~/go/bin/httprobe /usr/local/bin
echo ""
sleep 1

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
