#!/bin/bash

# Initialize arrays to track installation status
installed_tools=()
failed_tools=()

# Function to print colored output
print_success() { echo -e "\033[32m$1\033[0m"; }
print_error() { echo -e "\033[31m$1\033[0m"; }

# Install Go
echo "Installing Go..."
if ! apt-get update -qq && apt-get install -y -qq snapd && snap install go --classic; then
    echo "Snap installation failed, trying apt..."
    if ! sudo apt update && sudo apt install -y golang-go; then
        print_error "Go installation failed"
        exit 1
    fi
fi
print_success "Go installed successfully"

# Set PATH
echo 'export PATH=$PATH:/snap/bin' >> ~/.bashrc
export PATH=$PATH:/snap/bin

# Set GOPROXY
export GOPROXY=https://goproxy.io,direct
echo "Setting GOPROXY to https://goproxy.io,direct"

# Define tools and their installation commands (excluding amass)
declare -A tools=(
    ["nuclei"]="go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
    ["subfinder"]="go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    ["httpx"]="go install github.com/projectdiscovery/httpx/cmd/httpx@latest"
    ["assetfinder"]="go install github.com/tomnomnom/assetfinder@latest"
    ["hakrawler"]="go install github.com/hakluke/hakrawler@latest"
    ["katana"]="go install github.com/projectdiscovery/katana/cmd/katana@latest"
    ["ffuf"]="go install github.com/ffuf/ffuf/v2@latest"
    ["gf"]="go install github.com/tomnomnom/gf@latest"
    ["waybackurls"]="go install github.com/tomnomnom/waybackurls@latest"
    ["anew"]="go install github.com/tomnomnom/anew@latest"
)

# Install and test each tool individually (excluding amass)
for tool in "${!tools[@]}"; do
    if which "$tool" &>/dev/null; then
        print_success "$tool is already installed"
        installed_tools+=("$tool")
    else
        echo "Installing $tool..."
        if ${tools[$tool]} >/dev/null 2> >(tee /tmp/install_error.log); then
            if which "$tool" &>/dev/null; then
                print_success "$tool installed successfully"
                print_success "$tool is available"
                installed_tools+=("$tool")
            else
                print_error "$tool installation failed: $(cat /tmp/install_error.log)"
                failed_tools+=("$tool")
            fi
        else
            print_error "$tool installation failed: $(cat /tmp/install_error.log)"
            failed_tools+=("$tool")
        fi
    fi
done

# Install amass separately
if which amass &>/dev/null; then
    print_success "amass is already installed"
    installed_tools+=("amass")
else
    echo "Installing amass..."
    if snap install amass >/dev/null 2> >(tee /tmp/install_error.log) && amass -h >/dev/null 2>>/tmp/install_error.log; then
        print_success "amass installed successfully"
        print_success "amass is available"
        installed_tools+=("amass")
    else
        print_error "amass installation failed: $(cat /tmp/install_error.log)"
        failed_tools+=("amass")
    fi
fi

# Print summary
if [ ${#failed_tools[@]} -eq 0 ]; then
    echo "Installation completed successfully!"
else
    echo "Installation completed with errors."
fi
echo "Summary:"
echo "- Installed: ${installed_tools[*]:-None}"
echo "- Failed: ${failed_tools[*]:-None}"

# Clean up temporary error log
rm -f /tmp/install_error.log
