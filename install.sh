#!/bin/bash

#Colors
bold="\e[1m"
red="\e[31m"
blue="\e[34m"
green="\e[32m"
end="\e[0m"

echo -e "${bold}${blue}Made with${end} ${bold}${red}<3${end} ${bold}${blue}by Pugalarasan - @0xlittleboy${end}"

cd $HOME
mkdir -p bounty.sh/tools

echo -e "${green}${bold}Installing Essentials...${end}"

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y gcc
sudo apt install -y build-essential
sudo apt install -y git
sudo apt install -y vim
sudo apt install -y wget
sudo apt install -y curl
sudo apt install -y make
sudo apt install -y tmux
sudo apt install -y perl
sudo apt install -y python3
sudo apt install -y python3-pip
sudo apt install -y python
sudo apt install -y python-pip
sudo apt install -y libpcap-dev
sudo apt install -y jq
sudo apt install -y cargo
sudo pip3 install uro
sudo pip3 install colored
sudo pip3 install arjun
sudo pip3 install requests
suod pip3 install dnspython
sudo pip3 install argparse
sudo pip3 install tldextract



echo -e "${green}${bold}Installing Golang...${end}"
sys=$(uname -m)
LATEST=$(curl -s 'https://go.dev/VERSION?m=text')
[ $sys == "x86_64" ] && wget https://golang.org/dl/$LATEST.linux-amd64.tar.gz -O golang.tar.gz &>/dev/null || wget https://golang.org/dl/$LATEST.linux-386.tar.gz -O golang.tar.gz &>/dev/null
sudo tar -C /usr/local -xzf golang.tar.gz
echo "export GOROOT=/usr/local/go" >> $HOME/.bashrc
echo "export GOPATH=$HOME/go" >> $HOME/.bashrc
echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> $HOME/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.profile


echo -e "${green}${bold}Installing Tools...${end}"
cd ~/bounty.sh/tools/
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest;
go get -u github.com/tomnomnom/assetfinder;
go install -v github.com/OWASP/Amass/v3/...@master;
wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux; chmod +x findomain-linux; sudo cp findomain-linux /usr/local/bin;
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux; chmod +x findomain-linux; sudo cp findomain-linux /usr/local/bin
go install github.com/hakluke/hakrawler@latest;
go install github.com/tomnomnom/waybackurls@latest;
go install github.com/lc/gau/v2/cmd/gau@latest;
go install github.com/003random/getJS@latest;
go install github.com/ffuf/ffuf@latest
git clone https://github.com/s0md3v/Corsy.git; cd Corsy; pip3 install -r requirements.txt; cd ../
git clone https://github.com/devanshbatham/ParamSpider.git; cd ParamSpider; pip3 install -r requirements.txt; cd ../
git clone https://github.com/defparam/smuggler.git; cd smuggler/; ../
go install github.com/tomnomnom/qsreplace@latest;
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev; cd ../
go install github.com/hahwul/dalfox/v2@latest;
git clone https://github.com/dwisiswant0/findom-xss.git --recurse-submodules; cd ../
git clone https://github.com/internetwache/GitTools.git
git clone https://github.com/SharonBrizinov/s3viewer.git
go get github.com/haccer/subjack
go get github.com/Ice3man543/SubOver
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
git clone https://github.com/edoardottt/cariddi.git; cd cariddi; go get; make linux; cd ../
go install github.com/tomnomnom/httprobe@latest;
git clone https://github.com/epinna/tplmap.git; cd tplmap/; chmod +x tplmap.py; cd ..;
GO111MODULE=on go install github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest;
git clone https://github.com/s0md3v/XSStrike.git; cd XSStrike; pip3 install -r requirements.txt; cd ../;


echo "${bold}${red}This Tool is in under Devepement${end}"
