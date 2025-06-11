#!/bin/bash

# Check if system is Debian-based
if ! command -v apt-get &>/dev/null; then
    echo "Error: Requires Debian-based system (e.g., Ubuntu)."
    exit 1
fi

# Install snap and Go
apt-get update -qq && apt-get install -y -qq snapd || { echo "Error: Failed to install snapd."; exit 1; }
snap install go --classic || { echo "Error: Failed to install Go."; exit 1; }

# Update PATH
echo 'export PATH=$PATH:/snap/bin' >> ~/.bashrc
export PATH=$PATH:/snap/bin

# Verify and upgrade Go to 1.24.4 with multiple fallback methods
current_go=$(go version | grep -oP 'go\d+\.\d+\.\d+' | cut -d'go' -f2)
required_go="1.24.4"
if [ "$(printf '%s\n' "$required_go" "$current_go" | sort -V | head -n1)" != "$required_go" ]; then
    echo -n "Upgrading Go to 1.24.4 "
    methods=("default" "goproxy.io" "manual_download")
    for method in "${methods[@]}"; do
        case "$method" in
            "default")
                if go install golang.org/dl/go1.24.4@latest 2>/dev/null && go1.24.4 download 2>/dev/null; then
                    go1.24.4 env -w GOPATH=$HOME/go
                    export PATH=$HOME/go/bin:$PATH
                    break
                fi
                ;;
            "goproxy.io")
                if ! which go1.24.4 &>/dev/null; then
                    export GOPROXY=https://goproxy.io,direct
                    if go install golang.org/dl/go1.24.4@latest 2>/dev/null && go1.24.4 download 2>/dev/null; then
                        go1.24.4 env -w GOPATH=$HOME/go
                        export PATH=$HOME/go/bin:$PATH
                        break
                    fi
                fi
                ;;
            "manual_download")
                if ! which go1.24.4 &>/dev/null; then
                    mirrors=("https://go.dev/dl/go1.24.4.linux-amd64.tar.gz" "https://golang.google.cn/dl/go1.24.4.linux-amd64.tar.gz")
                    for mirror in "${mirrors[@]}"; do
                        if wget -q "$mirror" -O /tmp/go1.24.4.tar.gz 2>/dev/null || curl -L -s "$mirror" -o /tmp/go1.24.4.tar.gz 2>/dev/null; then
                            tar -C /usr/local -xzf /tmp/go1.24.4.tar.gz 2>/dev/null
                            export PATH=$PATH:/usr/local/go/bin
                            rm -f /tmp/go1.24.4.tar.gz
                            break 2
                        fi
                    done
                fi
                ;;
        esac
    done
    if ! which go1.24.4 &>/dev/null; then
        echo "Error: Failed to upgrade Go."
        exit 1
    fi
fi

# Install tools only if not already installed
tools=("subfinder" "katana" "nuclei" "httpx")
other_tools=("assetfinder" "hakrawler" "waybackurls" "gf" "anew" "ffuf" "amass")
failed_tools=()

echo -n "Installing tools "
for tool in "${tools[@]}" "${other_tools[@]}"; do
    if ! which "$tool" &>/dev/null; then
        echo -n "$tool "
        export GOPROXY=https://goproxy.io,direct
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
