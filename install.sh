#!/bin/bash

# Colors for output
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to display progress
progress() {
    local message="$1"
    local percent="$2"
    local bar_length=20
    local filled_length=$((percent * bar_length / 100))
    local bar=$(printf "%${filled_length}s" | tr ' ' '=')
    local empty=$(printf "%$((bar_length - filled_length))s")
    printf "\r${GREEN}%s [%s%s] %d%%${NC}" "$message" "$bar" "$empty" "$percent"
}

# Function to check internet connectivity
check_internet() {
    if ! ping -c 1 8.8.8.8 &>/dev/null; then
        echo -e "${RED}Error: No internet connection. Please check your network and try again.${NC}"
        exit 1
    fi
}

# Function to check write permissions
check_write_permissions() {
    local dir="$1"
    if [ ! -w "$dir" ]; then
        echo -e "${RED}Error: No write permissions for $dir. Try running with sudo or fix permissions.${NC}"
        exit 1
    fi
}

# Check if system is Debian-based
if ! command -v apt-get &>/dev/null; then
    echo -e "${RED}Error: This script supports Debian-based systems (e.g., Ubuntu). Please use a compatible OS.${NC}"
    exit 1
fi

# Check internet connectivity
echo -e "${GREEN}Checking internet connectivity...${NC}"
check_internet
progress "Checking system" 5

# Check write permissions for installation directories
check_write_permissions "/usr/local"
check_write_permissions "$HOME"

# Update package list and install basic dependencies
echo -e "${GREEN}Updating package list and installing dependencies...${NC}"
if ! apt-get update -qq; then
    echo -e "${RED}Error: Failed to update package list. Check your network or repository settings.${NC}"
    exit 1
fi
if ! apt-get install -y -qq curl git build-essential; then
    echo -e "${RED}Error: Failed to install basic dependencies. Check apt-get logs.${NC}"
    exit 1
fi
progress "Installing system dependencies" 10

# Check and install/update Go
required_go_version="1.22.4"
if command -v go &>/dev/null; then
    current_go_version=$(go version | awk '{print $3}' | sed 's/go//')
    if [ "$(printf '%s\n' "$required_go_version" "$current_go_version" | sort -V | head -n1)" != "$required_go_version" ]; then
        echo -e "${YELLOW}Updating Go to version $required_go_version...${NC}"
        if ! curl -fsSL "https://golang.org/dl/go${required_go_version}.linux-amd64.tar.gz" -o go.tar.gz; then
            echo -e "${RED}Error: Failed to download Go. Trying alternative mirror...${NC}"
            if ! curl -fsSL "https://go.dev/dl/go${required_go_version}.linux-amd64.tar.gz" -o go.tar.gz; then
                echo -e "${RED}Error: Failed to download Go from all mirrors.${NC}"
                exit 1
            fi
        fi
        if ! tar -C /usr/local -xzf go.tar.gz; then
            echo -e "${RED}Error: Failed to extract Go. Check disk space or permissions.${NC}"
            exit 1
        fi
        rm go.tar.gz
        progress "Installing Go" 20
    else
        echo -e "${GREEN}Go version $current_go_version is already installed.${NC}"
        progress "Checking Go" 20
    fi
else
    echo -e "${GREEN}Installing Go version $required_go_version...${NC}"
    if ! curl -fsSL "https://golang.org/dl/go${required_go_version}.linux-amd64.tar.gz" -o go.tar.gz; then
        echo -e "${RED}Error: Failed to download Go. Trying alternative mirror...${NC}"
        if ! curl -fsSL "https://go.dev/dl/go${required_go_version}.linux-amd64.tar.gz" -o go.tar.gz; then
            echo -e "${RED}Error: Failed to download Go from all mirrors.${NC}"
            exit 1
        fi
    fi
    if ! tar -C /usr/local -xzf go.tar.gz; then
        echo -e "${RED}Error: Failed to extract Go. Check disk space or permissions.${NC}"
        exit 1
    fi
    rm go.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
    progress "Installing Go" 20
fi

# Verify Go installation
if ! command -v go &>/dev/null; then
    echo -e "${RED}Error: Go installation failed. Check logs above.${NC}"
    exit 1
fi
if ! which go &>/dev/null; then
    echo -e "${RED}Error: Go is installed but not in PATH. Adding to PATH...${NC}"
    export PATH=$PATH:/usr/local/go/bin
    if ! which go &>/dev/null; then
        echo -e "${RED}Error: Failed to add Go to PATH. Please add /usr/local/go/bin manually.${NC}"
        exit 1
    fi
}
echo -e "${GREEN}Go is installed and configured.${NC}"
progress "Configuring environment" 25

# Set Go environment variables
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
mkdir -p "$GOPATH/bin"

# Install required tools
tools=("subfinder" "assetfinder" "amass" "katana" "hakrawler" "waybackurls" "gf" "anew" "ffuf" "nuclei" "httpx")
total_tools=${#tools[@]}
installed=0

echo -e "${GREEN}Installing required tools...${NC}"
for tool in "${tools[@]}"; do
    if which "$tool" &>/dev/null; then
        echo -e "${GREEN}$tool is already installed at $(which $tool).${NC}"
        installed=$((installed + 1))
        progress "Installing tools" $((25 + installed * 60 / total_tools))
        continue
    fi

    echo -e "${YELLOW}Installing $tool...${NC}"
    for attempt in {1..2}; do
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
            installed=$((installed + 1))
            progress "Installing tools" $((25 + installed * 60 / total_tools))
            break
        else
            if [ $attempt -eq 2 ]; then
                echo -e "${RED}Error: Failed to install $tool after $attempt attempts.${NC}"
                exit 1
            fi
            echo -e "${YELLOW}Retrying $tool installation (attempt $((attempt + 1)))...${NC}"
            sleep 2
        fi
    done
done

# Download and install sector script
echo -e "${GREEN}Installing sector script...${NC}"
check_write_permissions "/usr/local/bin"
for attempt in {1..2}; do
    if curl -fsSL https://raw.githubusercontent.com/Nowafen/sector/main/sector -o /usr/local/bin/sector; then
        chmod +x /usr/local/bin/sector
        break
    else
        if [ $attempt -eq 2 ]; then
            echo -e "${RED}Error: Failed to download sector after $attempt attempts.${NC}"
            exit 1
        fi
        echo -e "${YELLOW}Retrying sector download (attempt $((attempt + 1)))...${NC}"
        sleep 2
    fi
done
progress "Installing sector" 90

# Verify sector installation and -h switch
if [ -f /usr/local/bin/sector ]; then
    if sector -h &>/dev/null; then
        echo -e "${GREEN}Sector installed successfully at /usr/local/bin/sector and supports -h switch.${NC}"
    else
        echo -e "${YELLOW}Warning: Sector installed, but -h switch failed. Check sector script implementation.${NC}"
    fi
else
    echo -e "${RED}Error: Failed to install sector. File not found at /usr/local/bin/sector.${NC}"
    exit 1
fi
progress "Verifying installation" 95

# Verify all tools are functional
echo -e "${GREEN}Verifying all tools...${NC}"
all_tools_ok=true
for tool in "${tools[@]}"; do
    if ! which "$tool" &>/dev/null; then
        echo -e "${RED}Error: $tool is not installed or not in PATH.${NC}"
        all_tools_ok=false
    elif ! "$tool" --help &>/dev/null && ! "$tool" -h &>/dev/null; then
        echo -e "${YELLOW}Warning: $tool is installed but may not function correctly.${NC}"
    else
        echo -e "${GREEN}$tool is installed and functional.${NC}"
    fi
done

if [ "$all_tools_ok" = false ]; then
    echo -e "${RED}Error: One or more tools failed verification. Please check the logs above.${NC}"
    exit 1
fi
progress "Finalizing" 100

echo -e "\n${GREEN}Installation completed successfully. All tools and sector are ready to use.${NC}"
echo -e "${YELLOW}Note: If tools are not accessible, run 'source ~/.bashrc' or restart your terminal.${NC}"
