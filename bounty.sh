#!/bin/bash

## colors
BOLD="\e[1m"
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color


echo -e "$CYAN${BOLD}     ____                    __               __      ${NC}"
echo -e "$CYAN${BOLD}    / __ )____  __  ______  / /___  __  _____/ /_     ${NC}"
echo -e "$CYAN${BOLD}   / __  / __ \/ / / / __ \/ __/ / / / / ___/ __ \    ${NC}"
echo -e "$CYAN${BOLD}  / /_/ / /_/ / /_/ / / / / /_/ /_/ / (__  ) / / /    ${NC}"
echo -e "$CYAN${BOLD} /_____/\____/\__,_/_/ /_/\__/\__, (_)____/_/ /_/     ${NC}"
echo -e "$CYAN${BOLD}                             /____/                   ${NC}"
echo -e "$CYAN${BOLD} Bug Bounty automation script - $$$ by @0xPugazh      ${NC}"

echo " "
help() {
    echo -e "$CYAN${BOLD}Usage:${NC}"
    echo -e "${BOLD}    --help            Shows the help menu${NC}"
    echo -e "${BOLD}    --vuln1           Subenum + portscan + alive + vuln${NC}"
    echo -e "${BOLD}    --vuln2           Subenum + alive + params + vuln${NC}"
    exit 0
}

if [ "$1" == "--help" ]; then
    help
fi

domain=$2
#if [ -z "$domain" ]; then
#    echo -e "${RED}Please provide a domain.${NC}"
#    help
#fi

mkdir -p ~/bounty.sh/output/$domain
mkdir -p ~/bounty.sh/output/$domain/xray

vuln1() {
    echo -e "$CYAN${BOLD}Subdomain Enumeration...${NC}"
    subfinder -d $domain -silent -all | anew ~/bounty.sh/output/$domain/subs.txt
    assetfinder -subs-only $domain | anew ~/bounty.sh/output/$domain/subs.txt
    amass enum -passive -d $domain | anew ~/bounty.sh/output/$domain/subs.txt

    echo -e "$CYAN${BOLD}Port Scanning...${NC}"
    naabu -silent -l ~/bounty.sh/output/$domain/subs.txt | anew ~/bounty.sh/output/$domain/open-ports.txt
    
    echo -e "$CYAN${BOLD}HTTP Probing...${NC}"
    httpx -silent -l ~/bounty.sh/output/$domain/open-ports.txt | anew ~/bounty.sh/output/$domain/alive.txt   

    echo -e "$CYAN${BOLD}Vulnerability Scanning...${NC}"
    cd ~/bounty.sh/tools/
    cat ~/bounty.sh/output/$domain/alive.txt | xargs -I @ sh -c './xray_linux_amd64 ws --basic-crawler @ --plugins xss,sqldet,xxe,ssrf,cmd-injection,path-traversal,crlf-injection,dirscan --html-output ~/bounty.sh/output/$domain/xray/"xray_$(echo @ | tr / _).html"'
    nuclei -l ~/bounty.sh/output/$domain/alive.txt -t ~/nuclei-templates -es info,unknown -etags ssl | anew ~/bounty.sh/output/$domain/nuclei.txt
}

vuln2() {
    echo -e "$CYAN${BOLD}Subdomain Enumeration...${NC}"
    subfinder -d $domain -silent -all | anew ~/bounty.sh/output/$domain/subs.txt
    assetfinder -subs-only $domain | anew ~/bounty.sh/output/$domain/subs.txt
    amass enum -passive -d $domain | anew ~/bounty.sh/output/$domain/subs.txt

    echo -e "$CYAN${BOLD}HTTP Probing...${NC}"
    httpx -silent -l ~/bounty.sh/output/$domain/subs.txt | anew ~/bounty.sh/output/$domain/alive.txt

    echo -e "$CYAN${BOLD}Parameters finding...${NC}"
    paramspider -l ~/bounty.sh/output/$domain/alive.txt && mv results ~/bounty.sh/output/$domain/
    cd results/
    cat ~/bounty.sh/output/$domain/results/* > ~/bounty.sh/output/$domain/params.txt

    echo -e "$CYAN${BOLD}Vulnerability Scanning...${NC}"
    cd ~/bounty.sh/tools/
    cat ~/bounty.sh/output/$domain/params.txt | xargs -I @ sh -c './xray_linux_amd64 ws --url @ --plugins xss,sqldet,xxe,ssrf,cmd-injection,path-traversal,crlf-injection,dirscan --html-output ~/bounty.sh/output/$domain/xray/"xray_$(echo @ | tr / _).html"'
    nuclei ~/bounty.sh/output/$domain/params.txt -t ~/nuclei-templates -es info,unknown -etags ssl | anew ~/bounty.sh/output/$domain/nuclei.txt
}

if [ "$1" == "--vuln1" ]; then
    vuln1
elif [ "$1" == "--vuln2" ]; then
    vuln2
else
    echo -e "${RED}Unknown option: $1 ${NC}"
    help
fi
