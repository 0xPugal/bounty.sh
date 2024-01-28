#!/bin/bash

mkdir tools

## Installing dependencies
sudo apt update -y
sudo apt install -y git
sudo apt install -y wget
sudo apt install unzip
sudo apt install -y libpcap-dev

## Installing go tools
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/owasp-amass/amass/v3/...@master
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/tomnomnom/anew@latest

## installing paramspider
cd tools && git clone https://github.com/devanshbatham/paramspider
cd paramspider
sudo pip install .
cd ../

## installing findomain
cd tools && git clone https://github.com/findomain/findomain.git
cd findomain
cargo build --release
sudo cp target/release/findomain /usr/bin/
cd ../

## installing xray
cd tools
wget https://github.com/chaitin/xray/releases/download/1.9.11/xray_linux_amd64.zip
sudo unzip xray_linux_amd64.zip
sudo ./xray_linux_amd64
sudo ./xray_linux_amd64
