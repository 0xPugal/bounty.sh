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

if [ "$1" == "--help" ]; then
    help
fi

domain=$2
if [ -z "$domain" ]; then
    echo "Please provide a domain."
    help
fi

mkdir -p /root/bounty.sh/output/"$domain"
mkdir -p /root/bounty.sh/output/"$domain"/xray
mkdir -p /root/bounty.sh/output/"$domain"/nuclei

vuln1() {
    subfinder -d $domain -silent -all | anew /root/bounty.sh/output/$domain/subs.txt
    assetfinder -subs-only $domain | anew /root/bounty.sh/output/$domain/subs.txt
    amass enum -passive -d $domain | anew /root/bounty.sh/output/$domain/subs.txt
    cat /root/bounty.sh/output/$domain/subs.txt | naabu -top-ports full -silent | anew /root/bounty.sh/output/$domain/open-ports.txt
    cat /root/bounty.sh/output/$domain/open-ports.txt | httpx -silent | anew /root/bounty.sh/output/$domain/alive.txt         
    for i in $(cat /root/bounty.sh/output/$domain/alive.txt); do 
        xray_linux_amd64 ws --basic-crawler $i --plugins xss,sqldet,xxe,ssrf,cmd-injection,path-traversal --ho /root/bounty.sh/output/$domain/xray/$(date +"%T").html
    done
    cat /root/bounty.sh/output/$domain/alive.txt | nuclei -t /root/nuclei-templates -severity critical -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/critical.txt
    cat /root/bounty.sh/output/$domain/alive.txt | nuclei -t /root/nuclei-templates -severity high -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/high.txt
    cat /root/bounty.sh/output/$domain/alive.txt | nuclei -t /root/nuclei-templates -severity medium -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/medium.txt
    cat /root/bounty.sh/output/$domain/alive.txt | nuclei -t /root/nuclei-templates -severity low -etags ssl | anew /root/bounty.sh/output/$domain/nuclei/low.txt
}

vuln2() {
    subfinder -d $domain -silent -all | anew /root/bounty.sh/output/$domain/subs.txt
    assetfinder -subs-only $domain | anew /root/bounty.sh/output/$domain/subs.txt
    amass enum -passive -d $domain | anew /root/bounty.sh/output/$domain/subs.txt
    cat /root/bounty.sh/output/$domain/subs.txt | httpx -silent | anew /root/bounty.sh/output/$domain/alive.txt
    paramspider -l /root/bounty.sh/output/$domain/alive.txt && mv results /root/bounty.sh/output/$domain/ 
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
    echo "Unknown option: $1"
    help
fi
