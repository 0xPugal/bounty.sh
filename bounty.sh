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
echo ""
sleep 1

mkdir -p ~/bounty.sh/recon
cd ~/bounty.sh/Recon/
##############################################################################################################################

#SubDomain Enumeration Started...
echo "-----------------------------------"
echo "...Subdomain enumeration started..."
echo "-----------------------------------"

#Assetfinder started...
assetfinder --subs-only $1 | tee -a ~/bounty.sh/recon/$1/assetfinder.txt

#Amass started...
amass enum -passive -d $1 -config ~/.config/amass/config.ini -o ~/bounty.sh/recon/$1/amass.txt

#SubFinder started...
subfinder -silent -d $1 -pc ~/.config/subfinder/provider-config.yaml -o ~/bounty.sh/recon/$1/subfinder.txt

#Findomain started...
findomain-linux -t $1 --quiet | tee -a ~/bounty.sh/recon/$1/findomain.txt
echo ""
echo ""
#Removing Duplicates && Sorting 
sleep 1
echo "----------------------------"
echo "...Sorting the subdomains..."
echo "----------------------------"

cat ~/bounty.sh/recon/$1/assetfinder.txt amass.txt subfinder.txt findomain.txt | sort -u | tee -a ~/bounty.sh/recon/$1/all.txt
rm ~/bounty.sh/recon/$1/assetfinder.txt amass.txt subfinder.txt findomain.txt
echo ""
echo ""
sleep 1
#Checking for live domains
echo "-------------------------------"
echo "...Checking for Live Domains..."
echo "-------------------------------"

httpx -l ~/bounty.sh/recon/$1/all.txt -p 80,8080,443,8443,9000,8000 -o ~/bounty.sh/recon/$1/alive.txt
echo ""
#############################################################################################################################

echo ""
sleep 1
#Subdomain Takeover...
echo "------------------------"
echo "...SubDomain Takeover..."
echo "------------------------"
python3 ~/bounty.sh/tools/sub404/sub404.py -f ~/bounty.sh/recon/$1/alive.txt -o ~/bounty.sh/recon/$1/sub404.txt
echo ""
cd ~/bounty.sh/recon/$1/
SubOver -l alive.txt -v | tee -a subover.txt
echo ""
subjack -w alive.txt -ssl -o subjack.txt
echo ""

################################################################################################################################

echo ""
sleep 1
#Vulnerability Scanning - Nuclei...
echo "----------------------------"
echo "...Vulnerability Scanning..."
echo "----------------------------"
nuclei -l ~/bounty.sh/recon/$1/alive.txt -severity info -o ~/bounty.sh/recon/$1/nuclei-info.txt &&
nuclei -l ~/bounty.sh/recon/$1/alive.txt -severity low,medium,high,critical -o ~/bounty.sh/recon/$1/nuclei.txt
echo ""

################################################################################################################################

echo ""
sleep 1
#Smuggler started...
echo "----------------------"
echo "...Smuggler started..."
echo "----------------------"
cd ~/bounty.sh/recon/$1/
cat alive.txt | python3 ~/bounty.sh/tools/smuggler/smuggler.py -m POST -q 
cat alive.txt | python3 ~/bounty.sh/tools/smuggler/smuggler.py -m GET -q 
echo ""

#################################################################################################################################

echo ""
sleep 1
#Fuzzing started - ffuf...
echo "---------------------"
echo "...Fuzzing started..."
echo "---------------------"
cd ~/bounty.sh/recon/$1/
for URL in $(<alive.txt); do ( ffuf -u "${URL}/FUZZ" -w ~/bounty.sh/wordlists/fuzz.txt -v -mc 200 -ac ); done | tee -a ffuf.txt
echo ""

############################################################################################################################

echo ""
sleep 1
#PortScanning started...
echo "----------------------"
echo "...Portscan - Naabu..."
echo "----------------------"
cd ~/bounty.sh/recon/$1/
naabu -l all.txt -p 1-65535 -o portscan.txt
echo ""

#################################################################################################################################

echo ""
sleep 1
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

#################################################################################################################################

echo ""
sleep 1
#CRLF scanning
echo "----------------------------"
echo "...CRLF injection scanner..."
echo "----------------------------"
cd ~/bounty.sh/tools/CRLF-Injection-Scanner
python3 crlf.py scan -i ~/bounty.sh/recon/$1/all.txt | egrep -v "No" | tee -a ~/bounty.sh/recon/$1/crlf.txt
echo ""

##################################################################################################################################

echo ""
sleep 1
#Gathering JS Files...
echo "------------------------"
echo "...Gathering JS Files..."
echo "------------------------"
cd ~/bounty.sh/recon/$1/
cat alive.txt | waybackurls | grep -iE '\.js'|grep -iEv '(\.jsp|\.json)' >> js1.txt &&
        cat alive.txt | gauplus | grep -iE '\.js'|grep -iEv '(\.jsp|\.json)' >> js2.txt &&
        cat alive.txt | gau | grep -iE '\.js'|grep -iEv '(\.jsp|\.json)' >> js3.txt &&
subjs -i alive.txt | tee -a subjs.txt &&
cat js1.txt js2.txt js3.txt subjs.txt | sort -u | tee -a js-files.txt
echo ""

#################################################################################################################################

echo ""
sleep 1
#Parameter fuzzing
echo "-------------------------"
echo "...ParamSpider started..."
echo "-------------------------"
python3 ~/bounty.sh/tools/ParamSpider/paramspider.py -d $1
echo ""

##################################################################################################################################


echo ""
echo ""
echo "This tool is under developement :)"
