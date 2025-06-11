#!/bin/bash

# Check if system is Debian-based
if ! command -v apt-get &>/dev/null; then
    echo "Error: Requires Debian-based system (e.g., Ubuntu)."
    exit 1
fi

# Check internet
if ! ping -c 1 8.8.8.8 &>/dev/null; then
    echo "Error: No internet connection."
    exit 1
fi

# Install snap and Go
apt-get update -qq && apt-get install -y -qq snapd || { echo "Error: Failed to install snapd."; exit 1; }
snap install go --classic || { echo "Error: Failed to install Go."; exit 1; }

# Update PATH
echo 'export PATH=$PATH:/snap/bin:$HOME/.pdtm/go/bin' >> ~/.bashrc
export PATH=$PATH:/snap/bin:$HOME/.pdtm/go/bin

# Verify and upgrade Go to 1.24.4 if needed
current_go=$(go version | grep -oP 'go\d+\.\d+\.\d+' | cut -d'go' -f2)
required_go="1.24.4"
if [ "$(printf '%s\n' "$required_go" "$current_go" | sort -V | head -n1)" != "$required_go" ]; then
    echo -n "Upgrading Go to 1.24.4 "
    if ! go install golang.org/dl/go1.24.4@latest 2>/dev/null || ! go1.24.4 download 2>/dev/null; then
        export GOPROXY=https://goproxy.cn,direct
        go install golang.org/dl/go1.24.4@latest 2>/dev/null && go1.24.4 download 2>/dev/null || { echo "Error: Failed to upgrade Go."; exit 1; }
    fi
    go1.24.4 env -w GOPATH=$HOME/go
    export PATH=$HOME/go/bin:$PATH
fi

# Install pdtm
echo -n "Installing tools: pdtm "
if ! go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest 2>/dev/null; then
    export GOPROXY=https://goproxy.cn,direct
    go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest 2>/dev/null || { echo "Error: Failed to install pdtm."; exit 1; }
fi

# Install ProjectDiscovery tools using pdtm
tools=("subfinder" "katana" "nuclei" "httpx")
other_tools=("assetfinder" "hakrawler" "waybackurls" "gf" "anew" "ffuf" "amass")
failed_tools=()

echo -n "Installing ProjectDiscovery tools "
pdtm -i "${tools[*]}" 2>/dev/null || failed_tools+=("${tools[@]}")

# Install other tools
for tool in "${other_tools[@]}"; do
    echo -n "$tool "
    if which "$tool" &>/dev/null; then
        continue
    fi
    case "$tool" in
        "assetfinder"|"hakrawler"|"waybackurls"|"gf"|"anew"|"ffuf")
            go install -v "github.com/tomnomnom/${tool}@latest" 2>/dev/null || failed_tools+=("$tool")
            ;;
        "amass")
            go install -v github.com/owasp-amass/amass/v4/...@master 2>/dev/null || failed_tools+=("$tool")
            ;;
    esac
done
echo

# Verify all tools
all_ok=true
all_tools=("${tools[@]}" "${other_tools[@]}")
for tool in "${all_tools[@]}"; do
    if ! which "$tool" &>/dev/null; then
        echo "Error: $tool not found."
        all_ok=false
    fi
done

if [ ${#failed_tools[@]} -gt 0 ]; then
    echo "Failed tools: ${failed_tools[*]}"
    exit 1
fi

# Install sector only if all tools are installed
curl -fsSL https://raw.githubusercontent.com/Nowafen/sector/main/sector -o /usr/local/bin/sector || { echo "Error: Failed to download sector."; exit 1; }
chmod +x /usr/local/bin/sector

echo "Installation complete. Run 'source ~/.bashrc' if tools are not accessible."
