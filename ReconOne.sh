#!/bin/bash
# Automatic tool for Recon
echo " ____                       ___             "
echo "|  _ \ ___  ___ ___  _ __  / _ \ _ __   ___ "
echo "| |_) / _ \/ __/ _ \| '_ \| | | | '_ \ / _ \ "
echo "|  _ <  __/ (_| (_) | | | | |_| | | | |  __/ "
echo "|_| \_\___|\___\___/|_| |_|\___/|_| |_|\___| "
echo "			@ Intelliroot"
echo ""
echo "        	  👉 github.com/intelliroot-tech"
echo ""
# Colors
green=`tput setaf 1`
yellow=`tput setaf 2`
orange=`tput setaf 3`
white=`tput setaf 4`
# Domain to Search
read -p  " 🎯 Target              : "  domain
echo "${green}"  "🥷 Tools               :"  "Subfinder AssetFInder Waybackurls GF Knocky Dirsearch Nuclei SQLmap"
echo "${yellow}" "🚀 Method              :"  "GET"
echo "${orange}" "📂 Ouput               :"  "/root/ReconOne/$domain"
echo "${white}"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo ""

# Create a folder for the domain
output_folder="$domain"
mkdir -p "$output_folder"

# Use Subfinder to find subdomains
echo "Using Subfinder ..."
subfinder -d "$domain" -o "$output_folder/subdomains.txt"

# Use Assetfinder to find subdomains
python /root/ReconOne/powerd/assetfinder.py
echo "Using Assetfinder ..."
assetfinder --subs-only "$domain" | tee "$output_folder/assetdomains.txt"

# Combined subdomains
echo "Combining All Subdomains ..."
> "$output_folder/Final_subdomains.txt"

for file in "$output_folder/subdomains.txt" "$output_folder/assetdomains.txt"; do
  while IFS= read -r line; do
    if ! grep -qFx "$line" "$output_folder/Final_subdomains.txt"; then
      echo "$line" >> "$output_folder/Final_subdomains.txt"
    fi
  done < "$file"

  rm "$file"
done

# Subdomains to IP address
python /root/ReconOne/powerd/web_to_ip.py
echo "Subdomains to IPs ..."

while IFS= read -r subdomain; do
  ip=$(nslookup "$subdomain" | awk '/^Address: / { print $2 }')
  echo "[+]Subdomain: $subdomain, [+]IP: $ip"
done < "$output_folder/Final_subdomains.txt" > "$output_folder/subdomains_ip.txt"

# IP output to excel
grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$output_folder/subdomains_ip.txt" > "$output_folder/final_ip_output.txt"

# Generate the Excel sheet
echo "Generating Excel sheet ..."
python3 - <<EOF
import pandas as pd

subdomains = []
with open("$output_folder/Final_subdomains.txt", "r") as file:
    subdomains = file.read().splitlines()
data = {"S.L No": list(range(1, len(subdomains) + 1)),
        "Subdomains": subdomains,
        "All IPs": "$output_folder/final_ip_output.txt"}
df = pd.DataFrame(data)
df.to_excel("$output_folder/Excel_output.xlsx", index=False)
EOF

# Delete final ip text file
rm "$output_folder/final_ip_output.txt"

# Use Knockpy
echo "Using knockpy ..."
python /root/ReconOne/knock/knockpy.py "$domain" | tee "$output_folder/knockpy_subdomains.txt"

# Use waybackurls to retrieve URLs from the Wayback Machine
python /root/ReconOne/powerd/waybackurls.py
echo "Using Waybackurls ..."
waybackurls "$domain" | tee "$output_folder/waybackurls.txt"

# URL endpoint xss,sql,ssrf,ssti using Waybackurls
echo "Using GF Tool ..."
cat "$output_folder/waybackurls.txt" | grep "=" | bhedak "" | tee "$output_folder/endpoint_waybackurls.txt"

# Using gf for XSS
echo "GF_XSS"
cat "$output_folder/waybackurls.txt" | gf xss | tee "$output_folder/gf_XSS.txt"

if [ ! -s "$output_folder/gf_XSS.txt" ]; then
  rm "$output_folder/gf_XSS.txt"
fi

#  Using gf for SQL
echo "GF_SQL"
cat "$output_folder/waybackurls.txt" | gf sqli | tee "$output_folder/gf_SQL.txt"

if [ ! -s "$output_folder/gf_SQL.txt" ]; then
  rm "$output_folder/gf_SQL.txt"
fi

# Using gf for SSRF
echo "GF_SSRF"
cat "$output_folder/waybackurls.txt" | gf ssrf | tee "$output_folder/gf_SSRF.txt"

if [ ! -s "$output_folder/gf_SSRF.txt" ]; then
  rm "$output_folder/gf_SSRF.txt"
fi

# Using gf for RCE
echo "GF_RCE"
cat "$output_folder/waybackurls.txt" | gf rce | tee "$output_folder/gf_RCE.txt"

if [ ! -s "$output_folder/gf_RCE.txt" ]; then
  rm "$output_folder/gf_RCE.txt"
fi

# Using gf for SSTI
echo "GF_SSTI"
cat "$output_folder/waybackurls.txt" | gf ssti | tee "$output_folder/gf_SSTI.txt"

if [ ! -s "$output_folder/gf_SSTI.txt" ]; then
  rm "$output_folder/gf_SSTI.txt"
fi

# Using gf for LFI
echo "GF_LFI"
cat "$output_folder/waybackurls.txt" | gf lfi | tee "$output_folder/gf_LFI.txt"

if [ ! -s "$output_folder/gf_LFI.txt" ]; then
  rm "$output_folder/gf_LFI.txt"
fi

# Using gf for Open Redirect
echo "GF_OpenRedirect"
cat "$output_folder/waybackurls.txt" | gf redirect | tee "$output_folder/gf_OpenRedirect.txt"

if [ ! -s "$output_folder/gf_OpenRedirect.txt" ]; then
  rm "$output_folder/gf_OpenRedirect.txt"
fi

# Subdomain Takeover Testing
echo "Checking domain Takeover .."
nuclei -l "$output_folder/Final_subdomains.txt" -t /root/ReconOne/takeovers.yaml -o "$output_folder/domaintakeover.txt"

if [ ! -s "$output_folder/domaintakeover.txt" ]; then
  rm "$output_folder/domaintakeover.txt"
fi

echo "Scan completed...."
