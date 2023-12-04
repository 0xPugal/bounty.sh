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
echo -e "$CYAN${BOLD}                            /____/                     ${NC}"
echo -e "$CYAN${BOLD} Bug Bounty automation script - $$$ by @0xPugazh      ${NC}"
echo ""

echo " "
help() {
    echo -e "$CYAN${BOLD}Usage:${NC}"
    echo -e "${BOLD}--help            Shows the help menu${NC}"
    echo -e "${BOLD}--vuln1           Subs + port + alive + xray + nuclei${NC}"
    echo -e "${BOLD}--vuln2           Subs + alive + params + xray + nuclei_fuzzing${NC}"
    exit 0
}

if [ "$1" == "--help" ]; then
    help
fi

domain=$2
if [ -z "$domain" ]; then
    echo -e "${RED}Please provide a domain.${NC}"
    help
fi

mkdir -p /root/bounty.sh/output/"$domain"
mkdir -p /root/bounty.sh/output/"$domain"/xray
mkdir -p /root/bounty.sh/output/"$domain"/nuclei

vuln1() {
    echo -e "$CYAN${BOLD}Subdomain Enumeration...${NC}"
    subfinder -d $domain -silent -all | anew /root/bounty.sh/output/$domain/subs.txt
    assetfinder -subs-only $domain | anew /root/bounty.sh/output/$domain/subs.txt
    amass enum -passive -d $domain | anew /root/bounty.sh/output/$domain/subs.txt

    echo -e "$CYAN${BOLD}Port Scanning...${NC}"
    cat /root/bounty.sh/output/$domain/subs.txt | naabu -top-ports full -silent | anew /root/bounty.sh/output/$domain/open-ports.txt
    
    echo -e "$CYAN${BOLD}HTTP Probing...${NC}"
    cat /root/bounty.sh/output/$domain/open-ports.txt | httpx -silent | anew /root/bounty.sh/output/$domain/alive.txt   

    echo -e "$CYAN${BOLD}Vulnerability Scanning...${NC}"
    for i in $(cat /root/bounty.sh/output/$domain/alive.txt); do 
        xray_linux_amd64 ws --basic-crawler $i --plugins xss,sqldet,xxe,ssrf,cmd-injection,path-traversal --ho /root/bounty.sh/output/$domain/xray/$(date +"%T").html
    done
    cat /root/bounty.sh/output/$domain/alive.txt | nuclei -t /root/nuclei-templates -severity critical -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/critical.txt
    cat /root/bounty.sh/output/$domain/alive.txt | nuclei -t /root/nuclei-templates -severity high -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/high.txt
    cat /root/bounty.sh/output/$domain/alive.txt | nuclei -t /root/nuclei-templates -severity medium -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/medium.txt
    cat /root/bounty.sh/output/$domain/alive.txt | nuclei -t /root/nuclei-templates -severity low -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/low.txt
}

vuln2() {
    echo -e "$CYAN${BOLD}Subdomain Enumeration...${NC}"
    subfinder -d $domain -silent -all | anew /root/bounty.sh/output/$domain/subs.txt
    assetfinder -subs-only $domain | anew /root/bounty.sh/output/$domain/subs.txt
    amass enum -passive -d $domain | anew /root/bounty.sh/output/$domain/subs.txt

    echo -e "$CYAN${BOLD}HTTP Probing...${NC}"
    cat /root/bounty.sh/output/$domain/subs.txt | httpx -silent | anew /root/bounty.sh/output/$domain/alive.txt

    echo -e "$CYAN${BOLD}Parameters finding...${NC}"
    paramspider -l /root/bounty.sh/output/$domain/alive.txt && mv results /root/bounty.sh/output/$domain/ 

    echo -e "$CYAN${BOLD}Vulnerability Scanning...${NC}"
    cat /root/bounty.sh/output/$domain/results/$domain.txt | xargs -I @ sh -c 'xray_linux_amd64 ws --url-list @ --plugins xss,sqldet,xxe,ssrf,cmd-injection,path-traversal --ho /root/bounty.sh/output/$domain/xray/$(date +"%T").html'
    cat /root/bounty.sh/output/$domain/results/$domain.txt | nuclei -t /root/nuclei-templates -severity critical -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/critical.txt
    cat /root/bounty.sh/output/$domain/results/$domain.txt | nuclei -t /root/nuclei-templates -severity high -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/high.txt
    cat /root/bounty.sh/output/$domain/results/$domain.txt | nuclei -t /root/nuclei-templates -severity medium -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/medium.txt
    cat /root/bounty.sh/output/$domain/results/$domain.txt | nuclei -t /root/nuclei-templates -severity low -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/low.txt
}

if [ "$1" == "--vuln1" ]; then
    vuln1
elif [ "$1" == "--vuln2" ]; then
    vuln2
else
    echo -e "${RED}Unknown option: $1 ${NC}"
    help
fi
