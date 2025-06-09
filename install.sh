#!/bin/bash

# Update package list and install basic dependencies
if ! command -v apt-get &>/dev/null; then
    echo "Error: This script supports Debian-based systems (e.g., Ubuntu). Please use a compatible OS."
    exit 1
fi

apt-get update -qq
apt-get install -y -qq curl git build-essential > /dev/null 2>&1

# Install Go if not present
if ! command -v go &>/dev/null; then
    curl -fsSL https://golang.org/dl/go1.22.4.linux-amd64.tar.gz -o go.tar.gz > /dev/null 2>&1
    tar -C /usr/local -xzf go.tar.gz > /dev/null 2>&1
    rm go.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
fi

# Set Go environment variables
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Install required tools
tools=("subfinder" "assetfinder" "amass" "katana" "hakrawler" "waybackurls" "gf" "anew" "ffuf" "nuclei" "httpx")

for tool in "${tools[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        case "$tool" in
            "subfinder")
                GO111MODULE=on go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest > /dev/null 2>&1
                ;;
            "assetfinder")
                go install -v github.com/tomnomnom/assetfinder@latest > /dev/null 2>&1
                ;;
            "amass")
                GO111MODULE=on go install -v github.com/OWASP/Amass/v3/...@latest > /dev/null 2>&1
                ;;
            "katana")
                GO111MODULE=on go install -v github.com/projectdiscovery/katana/cmd/katana@latest > /dev/null 2>&1
                ;;
            "hakrawler")
                go install -v github.com/hakluke/hakrawler@latest > /dev/null 2>&1
                ;;
            "waybackurls")
                go install -v github.com/tomnomnom/waybackurls@latest > /dev/null 2>&1
                ;;
            "gf")
                go install -v github.com/tomnomnom/gf@latest > /dev/null 2>&1
                ;;
            "anew")
                go install -v github.com/tomnomnom/anew@latest > /dev/null 2>&1
                ;;
            "ffuf")
                go install -v github.com/ffuf/ffuf@latest > /dev/null 2>&1
                ;;
            "nuclei")
                GO111MODULE=on go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest > /dev/null 2>&1
                ;;
            "httpx")
                GO111MODULE=on go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest > /dev/null 2>&1
                ;;
        esac
    fi
done

# Download and install sector script
curl -fsSL https://raw.githubusercontent.com/Nowafen/sector/main/sector -o /usr/local/bin/sector > /dev/null 2>&1
chmod +x /usr/local/bin/sector

# Verify installation
if [ -f /usr/local/bin/sector ]; then
    echo "Installation completed successfully. Sector is ready to use."
else
    echo "Error: Failed to install sector."
    exit 1
fi
