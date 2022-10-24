FROM ubuntu:22.04

LABEL maintainer="Pugalarasan"
RUN echo "Made with <3 by Pugalarasan - @0xlittleboy"

#Environment Variables
ENV HOME /root
ENV DEBAIN_FRONTEND=noninteractive

#Working Directory
WORKDIR /root
RUN mkdir -p ${HOME}/bounty.sh/tools

#Installing Essentials
RUN sudo apt update -y \
    sudo apt upgrade -y \
    sudo apt install -y --no-install-recommends \
    build-essential \
    git \
    vim \
    wget \
    curl \
    make \
    tmux \
    perl \
    python3 \
    python3-pip3 \
    python \
    python-pip \
    libpcap-dev \
    jq \
    cargo

RUN sudo pip3 install --no-install-recommends \
    uro \
    colored \
    arjun \
    requests \
    dnspython \
    argparse \
    tldextract 

#Golang
RUN sys=$(uname -m) \
    LATEST=$(curl -s 'https://go.dev/VERSION?m=text') \
    [ $sys == "x86_64" ] && wget https://golang.org/dl/$LATEST.linux-amd64.tar.gz -O golang.tar.gz &>/dev/null || wget https://golang.org/dl/$LATEST.linux-386.tar.gz -O golang.tar.gz \
    sudo tar -C /usr/local -xzf golang.tar.gz \
    echo "export GOROOT=/usr/local/go" >> $HOME/.bashrc \
    echo "export GOPATH=$HOME/go" >> $HOME/.bashrc \
    echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> $HOME/.bashrc \
    echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.profile 

#Tools
RUN cd ${HOME}/bounty.sh/tools && \
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest; \
    go get -u github.com/tomnomnom/assetfinder; \
    go install -v github.com/OWASP/Amass/v3/...@master; \
    wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux; chmod +x findomain-linux; sudo cp findomain-linux /usr/local/bin; \
    go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest \
    wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux; chmod +x findomain-linux; sudo cp findomain-linux /usr/local/bin \
    go install github.com/hakluke/hakrawler@latest; \
    go install github.com/tomnomnom/waybackurls@latest; \
    go install github.com/lc/gau/v2/cmd/gau@latest; \
    go install github.com/003random/getJS@latest; \
    go install github.com/ffuf/ffuf@latest \
    git clone https://github.com/s0md3v/Corsy.git; cd Corsy; pip3 install -r requirements.txt; cd ../ \
    git clone https://github.com/devanshbatham/ParamSpider.git; cd ParamSpider; pip3 install -r requirements.txt; cd ../ \
    git clone https://github.com/defparam/smuggler.git; cd smuggler/; ../ \
    go install github.com/tomnomnom/qsreplace@latest; \
    git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev; cd ../ \
    go install github.com/hahwul/dalfox/v2@latest; \
    git clone https://github.com/dwisiswant0/findom-xss.git --recurse-submodules; cd ../ \
    git clone https://github.com/internetwache/GitTools.git \
    git clone https://github.com/SharonBrizinov/s3viewer.git \
    go get github.com/haccer/subjack \
    go get github.com/Ice3man543/SubOver \
    go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest \
    git clone https://github.com/edoardottt/cariddi.git; cd cariddi; go get; make linux; cd ../ \
    go install github.com/tomnomnom/httprobe@latest; \
    git clone https://github.com/epinna/tplmap.git; cd tplmap/; chmod +x tplmap.py; cd ..; \
    GO111MODULE=on go install github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest; \
    git clone https://github.com/s0md3v/XSStrike.git; cd XSStrike; pip3 install -r requirements.txt; cd ../; \

#Note
RUN echo "This Tool is Under Development"
