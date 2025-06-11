#!/bin/bash

# Colors for output
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if system is Debian-based
if ! command -v apt-get &>/dev/null; then
    echo -e "${RED}Error: This script supports Debian-based systems (e.g., Ubuntu). Please use a compatible OS.${NC}"
    exit 1
fi

# Check internet connectivity
echo -e "${GREEN}Checking internet connectivity...${NC}"
if ! ping -c 1 8.8.8.8 &>/dev/null; then
    echo -e "${RED}Error: No internet connection. Please check your network and try again.${NC}"
    exit 1
fi

# Update package list and install snap
echo -e "${GREEN}Updating package list and installing snap...${NC}"
if ! apt-get update -qq || ! apt-get install -y -qq snapd; then
    echo -e "${RED}Error: Failed to update or install snapd. Check your network or permissions.${NC}"
    exit 1
fi

# Install Go with snap
echo -e "${GREEN}Installing Go with snap...${NC}"
if ! snap install go --classic; then
    echo -e "${RED}Error: Failed to install Go with snap. Ensure snap is properly configured.${NC}"
    exit 1
fi

# Add /snap/bin to PATH
echo -e "${GREEN}Adding /snap/bin to PATH...${NC}"
if ! grep -q "/snap/bin" ~/.bashrc; then
    echo 'export PATH=$PATH:/snap/bin' >> ~/.bashrc
fi
export PATH=$PATH:/snap/bin

# Verify Go installation
echo -e "${GREEN}Verifying Go installation...${NC}"
if ! command -v go &>/dev/null; then
    echo -e "${RED}Error: Go is not installed or not in PATH after snap installation.${NC}"
    exit 1
fi
go_version=$(go version)
if [[ -z "$go_version" ]]; then
    echo -e "${RED}Error: Go version check failed. Installation is invalid.${NC}"
    exit 1
fi
echo -e "${GREEN}Go installed successfully: $go_version${NC}"

# Install required tools
tools=("subfinder" "assetfinder" "amass" "katana" "hakrawler" "waybackurls" "gf" "anew" "ffuf" "nuclei" "httpx")

echo -e "${GREEN}Installing required tools...${NC}"
for tool in "${tools[@]}"; do
    if which "$tool" &>/dev/null; then
        echo -e "${GREEN}$tool is already installed at $(which $tool).${NC}"
        continue
    fi

    echo -e "${YELLOW}Installing $tool...${NC}"
    case "$tool" in
        "subfinder")
            GO111MODULE=on go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
            ;;
        "assetfinder")
            go install -v github.com/tomnomnom/assetfinder@latest
            ;;
        "amass")
            GO111MODULE=on go install -v github.com/OWASP/Amass/v3/...@latest
            ;;
        "katana")
            GO111MODULE=on go install github.com/projectdiscovery/katana/cmd/katana@latest
            ;;
        "hakrawler")
            go install -v github.com/hakluke/hakrawler@latest
            ;;
        "waybackurls")
            go install -v github.com/tomnomnom/waybackurls@latest
            ;;
        "gf")
            go install -v github.com/tomnomnom/gf@latest
            ;;
        "anew")
            go install -v github.com/tomnomnom/anew@latest
            ;;
        "ffuf")
            go install -v github.com/ffuf/ffuf@latest
            ;;
        "nuclei")
            GO111MODULE=on go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
            ;;
        "httpx")
            GO111MODULE=on go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
            ;;
    esac

    if which "$tool" &>/dev/null; then
        echo -e "${GREEN}$tool installed successfully at $(which $tool).${NC}"
    else
        echo -e "${RED}Error: Failed to install $tool. Check Go installation or network.${NC}"
    fi
done

# Download and install sector script
echo -e "${GREEN}Installing sector script...${NC}"
if ! curl -fsSL https://raw.githubusercontent.com/Nowafen/sector/main/sector -o /usr/local/bin/sector; then
    echo -e "${RED}Error: Failed to download sector script.${NC}"
    exit 1
fi
chmod +x /usr/local/bin/sector
echo -e "${GREEN}Sector installed successfully at /usr/local/bin/sector${NC}"

# Verify sector and tools
echo -e "${GREEN}Verifying installations...${NC}"
if [ -f /usr/local/bin/sector ] && sector -h &>/dev/null; then
    echo -e "${GREEN}Sector supports -h switch and is functional.${NC}"
else
    echo -e "${YELLOW}Warning: Sector installed but -h switch may not work. Check script implementation.${NC}"
fi

all_tools_ok=true
for tool in "${tools[@]}"; do
    if ! which "$tool" &>/dev/null; then
        echo -e "${RED}Error: $tool is not installed or not in PATH.${NC}"
        all_tools_ok=false
    elif ! "$tool" --help &>/dev/null && ! "$tool" -h &>/dev/null; then
        echo -e "${YELLOW}Warning: $tool may not function correctly.${NC}"
    else
        echo -e "${GREEN}$tool is installed and functional at $(which $tool).${NC}"
    fi
done

if [ "$all_tools_ok" = false ]; then
    echo -e "${RED}Error: One or more tools failed verification.${NC}"
    exit 1
fi

echo -e "\n${GREEN}Installation completed successfully. All tools and sector are ready to use.${NC}"
echo -e "${YELLOW}Note: If tools are not accessible, run 'source ~/.bashrc' or restart your terminal.${NC}"
