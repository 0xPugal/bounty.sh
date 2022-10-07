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
||        Made with ❤️ by Pugalarasan - aka 🧑‍💻 litt1eb0y        ||
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
echo ""

#SubDomain Enumeration...
assetfinder --subs-only $1 | tee -a ~/bounty.sh/recon/$1/assetfinder.txt
amass enum -passive -d $1 -config $amass -o ~/bounty.sh/recon/$1/amass.txt
subfinder -silent -all -d $1 -pc $subfinder -o ~/bounty.sh/recon/$1/subfinder.txt
findomain-linux -t $1 --quiet | tee -a ~/bounty.sh/recon/$1/findomain.txt
gau -subs $1 | unfurl -u domains | tee -a ~/bounty.sh/recon/$1/gau.txt
waybackurls $1 | unfurl -u domains | tee -a ~/bounty.sh/recon/$1/waybackurls.txt
ctfr -d $1 | tee -a ~/bounty.sh/recon/$1/ctfr.txt
puredns $dns $1 --resolvers-trusted $resolver --rate-limit-trusted 200 -q | tee -a ~/bounty.sh/recon/$1/puredns.txt
#Sorting
cat ~/bounty.sh/recon/$1/assetfinder.txt amass.txt subfinder.txt findomain.txt gau.txt waybackurls.txt ctfr.txt puerdns.txt | sort -u | tee -a ~/bounty.sh/recon/$1/all.txt
rm ~/bounty.sh/recon/$1/assetfinder.txt amass.txt subfinder.txt findomain.txt gau.txt waybackurls.txt ctfr.txt puredns.txt
echo ""

#Resolving domains
cat ~/bounty.sh/recon/$1/all.txt | puredns resolve --resolvers-trusted $resolver --rate-limit-trusted 200 -q | tee ~/bounty.sh/recon/$1/resolved.txt

#Checking for live domains
httpx -l ~/bounty.sh/recon/$1/all.txt -p 80,8080,443,8443,9000,8000 -rl 100 -timeout 30 -o ~/bounty.sh/recon/$1/alive.txt

#Running Portscan
naabu -l ~/bounty.sh/recon/$1/resolved.txt -port 0-65535 -c 10 -rl 100 -o open-ports.txt

#Subdomain Takeover
python3 ~/bounty.sh/tools/sub404/sub404.py -f ~/bounty.sh/recon/$1/alive.txt -o ~/bounty.sh/recon/$1/sub404.txt
echo ""
cd ~/bounty.sh/recon/$1/
SubOver -l alive.txt -v | tee -a subover.txt
echo ""
subjack -w alive.txt -ssl -o subjack.txt
echo ""

#Vulnerability Scanning - Nuclei...
nuclei -l ~/bounty.sh/recon/$1/alive.txt -severity info -rl 100 -c 5 -o ~/bounty.sh/recon/$1/nuclei-info.txt;
nuclei -l ~/bounty.sh/recon/$1/alive.txt -severity low -rl 100 -c 5 -o ~/bounty.sh/recon/$1/nuclei-low.txt;
nuclei -l ~/bounty.sh/recon/$1/alive.txt -severity medium -rl 100 -c 5 -o ~/bounty.sh/recon/$1/nuclei-medium.txt;
nuclei -l ~/boutny.sh/recon/$1/alive.txt -severity high -rl 100 -c 5 -o ~/bounty.sh/recon/$1/nuclei-high.txt;
nuclei -l ~/bounty.sh/recon/$1/alive.txt -severity critical -rl 100 -c 5 -o ~/bounty.sh/recon/$1/nuclei-critical.txt;
echo ""

#Smuggler started...
cd ~/bounty.sh/recon/$1/
cat alive.txt | python3 ~/bounty.sh/tools/smuggler/smuggler.py -m POST -q;
cat alive.txt | python3 ~/bounty.sh/tools/smuggler/smuggler.py -m GET -q 
echo ""

#Fuzzing started - ffuf...
cd ~/bounty.sh/recon/$1/
for URL in $(<alive.txt); do ( ffuf -u "${URL}/FUZZ" -w ~/bounty.sh/wordlists/fuzz.txt -v -mc 200 -ac ); done | tee -a ffuf.txt
echo ""

#Gathering URLs....
echo "----------------------------------------------"
echo "...Gathering URLs - Waybackurls,Gau,Gauplus..."
echo "----------------------------------------------"
cd ~/bounty.sh/recon/$1/
cat alive.txt | waybackurls | uro | tee -a way.txt 
cat alive.txt | gauplus | uro | tee -a gaupl.txt 
cat alive.txt | gau | uro | tee -a gau.txt 
cat way.txt gaupl.txt gau.txt | sort -u | tee -a waybackurls.txt
rm way.txt gaupl.txt gau.txt
echo ""

#CRLF scanning
cd ~/bounty.sh/tools/CRLF-Injection-Scanner
python3 crlf.py scan -i ~/bounty.sh/recon/$1/all.txt | egrep -v "No" | tee -a ~/bounty.sh/recon/$1/crlf.txt
echo ""

#Gathering JS Files
cd ~/bounty.sh/recon/$1/
cat alive.txt | waybackurls | grep -iE '\.js'|grep -iEv '(\.jsp|\.json)' >> js1.txt &&
cat alive.txt | gau | grep -iE '\.js'|grep -iEv '(\.jsp|\.json)' >> js3.txt &&
subjs -i alive.txt | tee -a subjs.txt &&
cat js1.txt js2.txt js3.txt subjs.txt | sort -u | tee -a js-files.txt
echo ""

#Parameter fuzzing
python3 ~/bounty.sh/tools/ParamSpider/paramspider.py -d $1
echo ""

##################################################################################################################################


echo ""
echo ""
echo "This tool is under developement :)"
