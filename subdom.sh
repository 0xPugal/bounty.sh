#!/bin/bash

#Assetfinder started...

assetfinder --subs-only $1 | tee -a assetfinder.txt


#Amass started...

amass enum -passive -d $1 -config ~/.config/amass/config.ini -o amass.txt


#SubFinder started...

subfinder -d $1 -pc ~/.config/subfinder/provider-config.yaml -o subfinder.txt


#Findomain started...

findomain-linux -t $1 --quiet | tee -a findomain.txt

#Removing Duplicates && Sorting 
echo "...Sorting the suubdomains...\n"
cat * | sort -u | tee -a all.txt


#Checking for live domains
echo "...Checking for Live Domains...\n"

httpx -l all.txt -p 80,8080,443,8443,9000,8000 -o alive.txt
