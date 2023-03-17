#!/bin/bash
sleep 1
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
||        Made with ❤️ by Pugalarasan - aka 🧑‍💻 0xPugazh           ||
||      Run this script against your target to earn 💰💰💰       ||
 \===============================================================/
EOF

echo ""
sleep 1

mkdir -p ~/bounty.sh/recon
cd ~/bounty.sh/recon/
##############################################################################################################################

#Variables
amass=~/.config/amass/config.ini
subfinder=~/.config/subfinder/provider-config.yaml
resolver=~/bounty.sh/wordlists/resolvers.txt
dns=~/bounty.sh/wordlists/dns.txt
fuzz=~/bounty.sh/wordlists/fuzz.txt
CHAOS="YOUR_CHAOS_API_KEY"
GITHUB="YOUR_GITHUB_API_KEY"
GITLAB="YOUR_GITLAB_API_KEY"
SHODAN="YOUR_SHODAN_API_KEY"
echo ""

#SubDomain Enumeration...
assetfinder --subs-only $1 | tee -a ~/bounty.sh/recon/$1/assetfinder.txt
amass enum -passive -d $1 -config $amass -o ~/bounty.sh/recon/$1/amass.txt
subfinder -silent -all -d $1 -pc $subfinder -o ~/bounty.sh/recon/$1/subfinder.txt
findomain-linux -t $1 --quiet | tee -a ~/bounty.sh/recon/$1/findomain.txt
gau -subs $1 | unfurl -u domains | tee -a ~/bounty.sh/recon/$1/gau.txt
waybackurls $1 | unfurl -u domains | tee -a ~/bounty.sh/recon/$1/waybackurls.txt
ctfr -d $1 | tee -a ~/bounty.sh/recon/$1/ctfr.txt
shuffledns -d $1 -w $dns -o ~/bounty.sh/recon/$1/shuffledns.txt
#Sorting
cat ~/bounty.sh/recon/$1/assetfinder.txt amass.txt subfinder.txt findomain.txt gau.txt waybackurls.txt ctfr.txt shuffledns.txt | sort -u | tee -a ~/bounty.sh/recon/$1/all.txt
rm ~/bounty.sh/recon/$1/assetfinder.txt amass.txt subfinder.txt findomain.txt gau.txt waybackurls.txt ctfr.txt shuffledns.txt
echo ""

#Resolving domains
cat ~/bounty.sh/recon/$1/all.txt | puredns resolve --resolvers-trusted $resolver --rate-limit-trusted 200 -q | tee ~/bounty.sh/recon/$1/resolved.txt

#Checking for live domains
httpx -l ~/bounty.sh/recon/$1/all.txt -p 80,8080,443,8443,9000,8000 -rl 100 -timeout 30 -o ~/bounty.sh/recon/$1/alive.txt

#Running Portscan
naabu -l ~/bounty.sh/recon/$1/resolved.txt -port 0-65535 -nmap -o open-ports.txt

#Subdomain Takeover
cd ~/bounty.sh/recon/$1/
SubOver -l alive.txt -v | tee -a subover.txt
echo ""
subjack -w alive.txt -ssl -o subjack.txt
echo ""

#Vulnerability Scanning - Nuclei...
nuclei -l ~/bounty.sh/recon/$1/alive.txt -severity info -rl 100 -c 10 -o ~/bounty.sh/recon/$1/nuclei_info.txt;
nuclei -l ~/bounty.sh/recon/$1/alive.txt -severity low -rl 100 -c 10 -o ~/bounty.sh/recon/$1/nuclei_low.txt;
nuclei -l ~/bounty.sh/recon/$1/alive.txt -severity medium -rl 100 -c 10 -o ~/bounty.sh/recon/$1/nuclei_medium.txt;
nuclei -l ~/boutny.sh/recon/$1/alive.txt -severity high -rl 100 -c 10 -o ~/bounty.sh/recon/$1/nuclei_high.txt;
nuclei -l ~/bounty.sh/recon/$1/alive.txt -severity critical -rl 100 -c 10 -o ~/bounty.sh/recon/$1/nuclei_critical.txt;
nuclei -l ~/bounty.sh/recon/$1/alive.txt -tags cves -rl 100 -c 10 -o ~/bounty.sh/recon/$1/nuclei_cves.txt
echo ""

#Smuggler started...
cd ~/bounty.sh/recon/$1/
cat alive.txt | python3 ~/bounty.sh/tools/smuggler/smuggler.py -m POST -q | tee ~/bounty.sh/recon/$1/smuggler-post.txt
cat alive.txt | python3 ~/bounty.sh/tools/smuggler/smuggler.py -m GET -q | tee ~/bounty.sh/recon/$1/smuggler-get.txt
echo ""

#Fuzzing started - ffuf...
cd ~/bounty.sh/recon/$1/
cat alive.txt | xargs -I @ sh -c 'ffuf -c -w $fuzz -u @ -mc 200 -ac -v | tee ~/bounty.sh/recon/$1/ffuf_get.txt'
cat alive.txt | xargs -I @ sh -c 'ffuf -c -w $fuzz -u @ -mc 200 -ac -v | tee ~/bounty.sh/recon/$1/ffuf_post.txt'
echo ""

#Gathering URLs....
cd ~/bounty.sh/recon/$1/
cat alive.txt | waybackurls | uro | tee -a way.txt 
cat alive.txt | gau | uro | tee -a gau.txt 
katana -list alive.txt -o katana.txt
cat alive.txt | hakrawler | tee -a hakrawler.txt
cat way.txt gau.txt katana.txt hakrawler.txt | sort -u | tee -a waybackurls.txt
rm way.txt gau.txt katana.txt hakrawler.txt 
echo ""

#CRLF scanning
cd ~/bounty.sh/recon/$1/
crlfuzz -l alive.txt -X GET -s -o crlf-get.txt &&
crlfuzz -l alive.txt -X POST -s -o crlf-post.txt &&
cat crlf-get.txt crlf-post.txt | tee crlf.txt
rm crlf-*
echo ""

#Gathering JS Files
cd ~/bounty.sh/recon/$1/
cat alive.txt | waybackurls | grep -iE '\.js'|grep -iEv '(\.jsp|\.json)' >> js1.txt &&
cat alive.txt | gau | grep -iE '\.js'|grep -iEv '(\.jsp|\.json)' >> js2.txt &&
cat alive.txt | hakrwler | grep -iE '\.js' | grep -iEv '(\.jsp|\.json)' >> js3.txt &&
katana -list alive.txt | grep -iE '\.js' | grep -iEv '(\.jsp|\.json)' >> js4.txt &&
subjs -i alive.txt | tee -a subjs.txt &&
cat js1.txt js2.txt js3.txt js4.txt subjs.txt | sort -u | tee -a js-files.txt
rm js1.txt js2.txt js3.txt js4.txt subjs.txt
echo ""

#Parameter fuzzing
python3 ~/bounty.sh/tools/ParamSpider/paramspider.py -d $1
echo ""

##################################################################################################################################

echo "This tool is under developement :)"
