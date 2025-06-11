#!/bin/bash

# Colors for output
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if system is Debian-based
if ! command -v apt-get &>/dev/null; then
    echo -e "${RED}Error: This script supports Debian-based systems (e.g., Ubuntu).${NC}"
    exit 1
fi

# Check internet connectivity
echo -e "${GREEN}Checking internet...${NC}"
if ! ping -c 1 8.8.8.8 &>/dev/null; then
    echo -e "${RED}Error: No internet connection.${NC}"
    exit 1
fi

# Update and install snap
echo -e "${GREEN}Updating system and installing snap...${NC}"
apt-get update -qq && apt-get install -y -qq snapd || { echo -e "${RED}Error: Failed to install snapd.${NC}"; exit 1; }

# Install Go with snap
echo -e "${GREEN}Installing Go...${NC}"
snap install go --classic || { echo -e "${RED}Error: Failed to install Go.${NC}"; exit 1; }

# Add /snap/bin to PATH
echo -e "${GREEN}Configuring PATH...${NC}"
echo 'export PATH=$PATH:/snap/bin' >> ~/.bashrc
export PATH=$PATH:/snap/bin

# Verify Go
echo -e "${GREEN}Verifying Go...${NC}"
if ! go version &>/dev/null; then
    echo -e "${RED}Error: Go installation failed.${NC}"
    exit 1
fi
echo -e "${GREEN}Go installed: $(go version)${NC}"

# Install required tools
tools=("subfinder" "assetfinder" "amass" "katana" "hakrawler" "waybackurls" "gf" "anew" "ffuf" "nuclei" "httpx")
failed_tools=()

echo -e "${GREEN}Installing tools:${NC}"
for tool in "${tools[@]}"; do
    echo -n "$tool "
    if which "$tool" &>/dev/null; then
        continue
    fi
    case "$tool" in
        "subfinder"|"katana"|"nuclei"|"httpx")
            # Try Project Discovery tools with fallback mirror
            if ! GO111MODULE=on go install -v "github.com/projectdiscovery/${tool}/cmd/${tool}@latest"; then
                echo -e "${YELLOW}Trying mirror for $tool...${NC}"
                if ! GO111MODULE=on go install -v "https://git.mirror.uncool.com/projectdiscovery/${tool}/cmd/${tool}@latest"; then
                    echo -e "${RED}Failed: $tool${NC}"
                    failed_tools+=("$tool")
                fi
            fi
            ;;
        "assetfinder"|"hakrawler"|"waybackurls"|"gf"|"anew"|"ffuf"|"amass")
            if ! go install -v "github.com/tomnomnom/${tool}@latest" && [[ "$tool" == "amass" ]]; then
                if ! GO111MODULE=on go install -v "github.com/OWASP/Amass/v3/...@latest"; then
                    echo -e "${RED}Failed: $tool${NC}"
                    failed_tools+=("$tool")
                fi
            elif ! go install -v "github.com/tomnomnom/${tool}@latest"; then
                echo -e "${RED}Failed: $tool${NC}"
                failed_tools+=("$tool")
            fi
            ;;
    esac
done
echo -e "\n${GREEN}Tool installation complete.${NC}"

# Install sector script
echo -e "${GREEN}Installing sector...${NC}"
if ! curl -fsSL https://raw.githubusercontent.com/Nowafen/sector/main/sector -o /usr/local/bin/sector; then
    echo -e "${RED}Error: Failed to download sector.${NC}"
    exit 1
fi
chmod +x /usr/local/bin/sector
echo -e "${GREEN}Sector installed.${NC}"

# Verify sector -h switch
if sector -h &>/dev/null; then
    echo -e "${GREEN}Sector -h switch works.${NC}"
else
    echo -e "${YELLOW}Warning: Sector -h switch failed.${NC}"
fi

# Verify all tools
echo -e "${GREEN}Verifying tools...${NC}"
all_ok=true
for tool in "${tools[@]}"; do
    if ! which "$tool" &>/dev/null; then
        echo -e "${RED}Error: $tool not found.${NC}"
        all_ok=false
    elif ! "$tool" --help &>/dev/null && ! "$tool" -h &>/dev/null; then
        echo -e "${YELLOW}Warning: $tool may not work.${NC}"
    else
        echo -e "${GREEN}$tool is functional.${NC}"
    fi
done

if [ ${#failed_tools[@]} -gt 0 ]; then
    echo -e "${RED}Failed tools: ${failed_tools[*]}${NC}"
    all_ok=false
fi

if [ "$all_ok" = false ]; then
    echo -e "${RED}Installation incomplete due to failures.${NC}"
    exit 1
fi

echo -e "\n${GREEN}All installations successful. Ready to use.${NC}"
echo -e "${YELLOW}Run 'source ~/.bashrc' if tools are not accessible.${NC}"
