# Bounty.sh [![Twitter](https://img.shields.io/badge/0xPugal-%231DA1F2.svg?logo=Twitter&logoColor=white)](https://twitter.com/0xPugal) [![LinkedIn](https://img.shields.io/badge/0xPugazh-%230077B5.svg?logo=linkedin&logoColor=white)](https://linkedin.com/in/0xPugazh)
A simple bash script to do bug bounty automation against your target and helps to earn some $$$.
```
$ ./bounty.sh
    ____                    __               __  
   / __ )____  __  ______  / /___  __  _____/ /_ 
  / __  / __ \/ / / / __ \/ __/ / / / / ___/ __ \
 / /_/ / /_/ / /_/ / / / / /_/ /_/ / (__  ) / / /
/_____/\____/\__,_/_/ /_/\__/\__, (_)____/_/ /_/ 
                            /____/             

   Bug Bounty automation script - $$$ by @0xPugazh
```


## Prerequisites
+ Download and Install golang from https://go.dev/doc/install
+ Install and configure Xray manually if any error occurs

## Installation
```
git clone https://github.com/0xPugazh/bounty.sh
cd bounty.sh
chmod +x install.sh bounty.sh
./install.sh
```

## Usage
```
Usage:
--help            Shows the help menu
--vuln1           Subs + port + alive + xray + nuclei
--vuln2           Subs + alive + params + xray + nuclei_fuzzing
```

## Credits
Inspired from https://medium.com/@0xelkot/how-i-get-10-sqli-and-30-xss-via-automation-tool-cebbd9104479
