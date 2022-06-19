#!/bin/bash
echo "                                                                  "
echo "   /$$                                       /$$                  "
echo "  | $$                                      | $$                  "
echo "  | $$$$$$$   /$$$$$$  /$$   /$$ /$$$$$$$  /$$$$$$   /$$   /$$    "
echo "  | $$__  $$ /$$__  $$| $$  | $$| $$__  $$|_  $$_/  | $$  | $$    "
echo "  | $$  \ $$| $$  \ $$| $$  | $$| $$  \ $$  | $$    | $$  | $$    "
echo "  | $$  | $$| $$  | $$| $$  | $$| $$  | $$  | $$ /$$| $$  | $$    "
echo "  | $$$$$$$/|  $$$$$$/|  $$$$$$/| $$  | $$  |  $$$$/|  $$$$$$$    "
echo "  |_______/  \______/  \______/ |__/  |__/   \___/   \____  $$    "
echo "                                                     /$$  | $$    "
echo "                                                    |  $$$$$$/    "
echo "                                                     \______/     "

echo "          Developed by Pugalarasan - aka @litt1eb0y "
echo "        Run this script against your target to earn $$$$"
###############################################################################################################################
#SubDomain Enumeration Started...
echo "...Subdomain enumeration started..."

#Assetfinder started...
assetfinder --subs-only $1 | tee -a assetfinder.txt

#Amass started...
amass enum -passive -d $1 -config ~/.config/amass/config.ini -o amass.txt

#SubFinder started...
subfinder -d $1 -pc ~/.config/subfinder/provider-config.yaml -o subfinder.txt

#Findomain started...
findomain-linux -t $1 --quiet | tee -a findomain.txt

#Removing Duplicates && Sorting 
echo "...Sorting the subdomains..."
cat assetfinder.txt amass.txt subfinder.txt findomain.txt | sort -u | tee -a all.txt
rm assetfinder.txt amass.txt subfinder.txt findomain.txt

#Checking for live domains
echo "...Checking for Live Domains..."
httpx -l all.txt -p 80,8080,443,8443,9000,8000 -o alive.txt

#############################################################################################################################
#Vulnerability Scanning - Nuclei...
echo "...Nuclei started..."
nuclei -l alive.txt -severity low -o nuclei-low.txt &&
        nuclei -l alive.txt -severity medium -o nuclei-medium.txt &&
        nuclei -l alive.txt -severity high -o nuclei-high.txt &&
        nuclei -l alive.txt -severity critical -o nuclei-critical.txt &&
        nuclei -l alive.txt -severity info -o nuclei-info.txt

################################################################################################################################
#Fuzzing started - ffuf...
echo "...Fuzzing started..."
for URL in $(<alive.txt); do ( ffuf -u "${URL}/FUZZ" -w wordlists.txt -v -mc 200 -ac ); done | tee -a fuff.txt

############################################################################################################################
#PortScanning started...
echo "...Portscan - Naabu..."
naabu -l all.txt -p 1-65535 -o portscan.txt

#################################################################################################################################
#Gathering URLs....
echo "...Gathering URLs - Waybackurls,Gau,Gauplus..."
cat alive.txt | waybackurls | uro | tee -a way.txt &&
cat alive.txt | gauplus | uro | tee -a gaupl.txt &&
cat alive.txt | gau | uro | tee -a gau.txt &&
cat way.txt gaupl.txt gau.txt | sort -u | tee -a waybackurls.txt
rm way.txt gaupl.txt gau.txt

#################################################################################################################################
#Gathering JS Files...
echo "...Gathering JS Files..."
cat alive.txt | waybackurls | grep -iE '\.js'|grep -iEv '(\.jsp|\.json)' >> js1.txt &&
        cat alive.txt | gauplus | grep -iE '\.js'|grep -iEv '(\.jsp|\.json)' >> js2.txt &&
        cat alive.txt | gau | grep -iE '\.js'|grep -iEv '(\.jsp|\.json)' >> js3.txt &&
subjs -i alive.txt | tee -a subjs.txt &&
cat js1.txt js2.txt js3.txt subjs.txt | sort -u | tee -a js-files.txt

#################################################################################################################################
