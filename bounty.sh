#!/bin/bash

cat <<"EOF"
    ____                    __               __  
   / __ )____  __  ______  / /___  __  _____/ /_ 
  / __  / __ \/ / / / __ \/ __/ / / / / ___/ __ \
 / /_/ / /_/ / /_/ / / / / /_/ /_/ / (__  ) / / /
/_____/\____/\__,_/_/ /_/\__/\__, (_)____/_/ /_/ 
                            /____/             

   Bug Bounty automation script - $$$ by @0xPugazh
EOF

echo " "
help() {
    echo "Usage:"
    echo "--help            Shows the help menu"
    echo "--vuln1           Subs + port + alive + xray + nuclei"
    echo "--vuln2           Subs + alive + params + xray + nuclei_fuzzing"
    exit 0
    }

domain=$1
mkdir -p output/$1
mkdir -p output/$1/nuclei
mkdir -p output/$1/xray

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        --help)
            help
            ;;
        --vuln1)
            domain="$2"
            shift
            shift
            ;;
        --vuln2)
            domain="$2"
            shift
            shift
            ;;
        *)
            echo "Unknown option: $key"
            display_help
            ;;
    esac
done


vuln1() {
subfinder -d $1 -silent -all | anew /root/bounty.sh/output/$1/subs.txt
assetfinder -subs-only $1 | anew /root/bounty.sh/output/$1/subs.txt
amass enum -passive -d $1 | anew /root/bounty.sh/output/$1/subs.txt
cat /root/bounty.sh/output/$1/subs.txt | naabu -top-ports full -silent | anew /root/bounty.sh/output/$1/open-ports.txt
cat /root/bounty.sh/output/$1/open-ports.txt | httpx -silent | anew /root/bounty.sh/output/$1/alive.txt         
for i in $(cat /root/bounty.sh/output/$1/alive.txt); do xray_linux_amd64 ws --basic-crawler $i --plugins xss,sqldet,xxe,ssrf,cmd-injection,path-traversal --ho /root/bounty.sh/output/$1/xray/$(date +"%T").html ; done
cat /root/bounty.sh/output/$1/alive.txt | nuclei -t /root/nuclei-templates -severity critical -etags ssl | anew /root/bounty.sh/output/$1/nuclei/critical.txt
cat /root/bounty.sh/output/$1/alive.txt | nuclei -t /root/nuclei-templates -severity high -etags ssl | anew /root/bounty.sh/output/$1/nuclei/high.txt
cat /root/bounty.sh/output/$1/alive.txt | nuclei -t /root/nuclei-templates -severity medium -etags ssl | anew /root/bounty.sh/output/$1/nuclei/medium.txt
cat /root/bounty.sh/output/$1/alive.txt | nuclei -t /root/nuclei-templates -severity low -etags ssl | anew /root/bounty.sh/output/$1/nuclei/low.txt
}

vuln2() {
subfinder -d $1 -silent -all | anew /root/bounty.sh/output/$1/subs.txt
assetfinder -subs-only $1 | anew /root/bounty.sh/output/$1/subs.txt
amass enum -passive -d $1 | anew /root/bounty.sh/output/$1/subs.txt
cat /root/bounty.sh/output/$1/subs.txt | httpx -silent | anew /root/bounty.sh/output/$1/alive.txt
paramspider -l /root/bounty.sh/output/$1/alive.txt && mv results /root/bounty.sh/output/$1/ 
cat /root/bounty.sh/output/$1/results/$1.txt | xargs -I @ sh -c 'xray_linux_amd64 ws --url-list @ --plugins xss,sqldet,xxe,ssrf,cmd-injection,path-traversal --ho /root/bounty.sh/output/$1/xray/$(date +"%T").html'
cat /root/bounty.sh/output/$1/results/$1.txt | nuclei -t /root/nuclei-templates -severity critical -etags ssl | anew /root/bounty.sh/output/$1/nuclei/critical.txt
cat /root/bounty.sh/output/$1/results/$1.txt | nuclei -t /root/nuclei-templates -severity high -etags ssl | anew /root/bounty.sh/output/$1/nuclei/high.txt
cat /root/bounty.sh/output/$1/results/$1.txt | nuclei -t /root/nuclei-templates -severity medium -etags ssl | anew /root/bounty.sh/output/$1/nuclei/medium.txt
cat /root/bounty.sh/output/$1/results/$1.txt | nuclei -t /root/nuclei-templates -severity low -etags ssl | anew /root/bounty.sh/output/$1/nuclei/low.txt
}

## Inspired from https://medium.com/@0xelkot/how-i-get-10-sqli-and-30-xss-via-automation-tool-cebbd9104479
