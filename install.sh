#!/bin/bash

echo "Install Golang before install these tools"
sleep 2

## Installing dependencies
sudo apt update -y
sudo apt install -y git
sudo apt install -y wget
sudo apt install -y libpcap-dev

## Installing go tools
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/owasp-amass/amass/v3/...@master
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/tomnomnom/anew@latest

## installing xray
wget https://github.com/chaitin/xray/releases/download/1.9.11/xray_linux_amd64.zip
unzip xray_linux_amd64.zip
sudo mv xray_linux_amd64 xray.yaml plugin.xray.yaml module.xray.yaml config.yaml /usr/bin/
