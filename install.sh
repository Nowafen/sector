#!/bin/bash

# Install snap and Go
echo "Installing Go"
apt-get update -qq && apt-get install -y -qq snapd
snap install go --classic

# Set PATH
echo 'export PATH=$PATH:/snap/bin' >> ~/.bashrc
export PATH=$PATH:/snap/bin

# Set proxy
export GOPROXY=https://goproxy.io,direct
echo "Proxy set to https://goproxy.io,direct"

# Install tools only if not present
tools=("subfinder" "katana" "nuclei" "httpx" "assetfinder" "hakrawler" "waybackurls" "gf" "anew" "ffuf" "amass")
failed_tools=()

echo "Checking and installing tools"
for tool in "${tools[@]}"; do
    if ! which "$tool" &>/dev/null; then
        echo "Installing $tool"
        case "$tool" in
            "subfinder"|"katana"|"nuclei"|"httpx")
                go install -v "github.com/projectdiscovery/${tool}/cmd/${tool}@latest" 2>/dev/null || failed_tools+=("$tool")
                ;;
            "assetfinder"|"hakrawler"|"waybackurls"|"gf"|"anew"|"ffuf")
                go install -v "github.com/tomnomnom/${tool}@latest" 2>/dev/null || failed_tools+=("$tool")
                ;;
            "amass")
                go install -v github.com/owasp-amass/amass/v4/...@master 2>/dev/null || failed_tools+=("$tool")
                ;;
        esac
    fi
done

# Verify tools
for tool in "${tools[@]}"; do
    if ! which "$tool" &>/dev/null; then
        echo "Failed to install $tool"
    fi
done

# Install sector
echo "Installing sector"
curl -fsSL https://raw.githubusercontent.com/Nowafen/sector/main/sector -o /usr/local/bin/sector
chmod +x /usr/local/bin/sector

echo "Installation complete"
