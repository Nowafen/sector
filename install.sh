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
installed_tools=()
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
        if which "$tool" &>/dev/null; then
            installed_tools+=("$tool")
        fi
    fi
done

# Test installed tools with -h or --help
if [ ${#installed_tools[@]} -gt 0 ]; then
    echo "Testing installed tools"
    for tool in "${installed_tools[@]}"; do
        if "$tool" -h &>/dev/null || "$tool" --help &>/dev/null; then
            echo "$tool is working"
        else
            echo "$tool failed to work"
            failed_tools+=("$tool")
        fi
    done
fi

# Install sector
echo "Installing sector"
curl -fsSL https://raw.githubusercontent.com/Nowafen/sector/main/sector -o /usr/local/bin/sector
chmod +x /usr/local/bin/sector

echo "Installation complete"
