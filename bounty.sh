#!/bin/bash

## colors
BLUE='\033[0;34m'
BOLD="\e[1m"
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

cat <<EOF
${BOLD}${CYAN}
    ____                    __               __  
   / __ )____  __  ______  / /___  __  _____/ /_ 
  / __  / __ \/ / / / __ \/ __/ / / / / ___/ __ \
 / /_/ / /_/ / /_/ / / / / /_/ /_/ / (__  ) / / /
/_____/\____/\__,_/_/ /_/\__/\__, (_)____/_/ /_/ 
                            /____/             
${NC}
   ${CYAN}Bug Bounty automation script - $$$ by @0xPugazh ${NC}
EOF

echo " "
help() {
    echo -e "${BOLD}${CYAN}Usage:${NC}"
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
    echo -e "${BOLD}${BLUE}Subdomain Enumeration...${NC}"
    subfinder -d $domain -silent -all | anew /root/bounty.sh/output/$domain/subs.txt
    assetfinder -subs-only $domain | anew /root/bounty.sh/output/$domain/subs.txt
    amass enum -passive -d $domain | anew /root/bounty.sh/output/$domain/subs.txt

    echo -e "${BOLD}${BLUE}Port Scanning...${NC}"
    cat /root/bounty.sh/output/$domain/subs.txt | naabu -top-ports full -silent | anew /root/bounty.sh/output/$domain/open-ports.txt
    
    echo -e "${BOLD}${BLUE}HTTP Probing...${NC}"
    cat /root/bounty.sh/output/$domain/open-ports.txt | httpx -silent | anew /root/bounty.sh/output/$domain/alive.txt   

    echo -e "${BOLD}${BLUE}Vulnerability Scanning...${NC}"
    for i in $(cat /root/bounty.sh/output/$domain/alive.txt); do 
        xray_linux_amd64 ws --basic-crawler $i --plugins xss,sqldet,xxe,ssrf,cmd-injection,path-traversal --ho /root/bounty.sh/output/$domain/xray/$(date +"%T").html
    done
    cat /root/bounty.sh/output/$domain/alive.txt | nuclei -t /root/nuclei-templates -severity critical -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/critical.txt
    cat /root/bounty.sh/output/$domain/alive.txt | nuclei -t /root/nuclei-templates -severity high -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/high.txt
    cat /root/bounty.sh/output/$domain/alive.txt | nuclei -t /root/nuclei-templates -severity medium -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/medium.txt
    cat /root/bounty.sh/output/$domain/alive.txt | nuclei -t /root/nuclei-templates -severity low -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/low.txt
}

vuln2() {
    echo -e "${BOLD}${BLUE}Subdomain Enumeration...${NC}"
    subfinder -d $domain -silent -all | anew /root/bounty.sh/output/$domain/subs.txt
    assetfinder -subs-only $domain | anew /root/bounty.sh/output/$domain/subs.txt
    amass enum -passive -d $domain | anew /root/bounty.sh/output/$domain/subs.txt

    echo -e "${BOLD}${BLUE}HTTP Probing...${NC}"
    cat /root/bounty.sh/output/$domain/subs.txt | httpx -silent | anew /root/bounty.sh/output/$domain/alive.txt

    echo -e "${BOLD}${BLUE}Parameters finding...${NC}"
    paramspider -l /root/bounty.sh/output/$domain/alive.txt && mv results /root/bounty.sh/output/$domain/ 

    echo -e "${BOLD}${BLUE}Vulnerability Scanning...${NC}"
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
