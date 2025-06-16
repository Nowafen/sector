i# Sector

**Sector** is an automation tool for reconnaissance and vulnerability assessment of web targets. It streamlines the discovery of subdomains, JavaScript assets, virtual hosts, and potential security issues, leveraging a wide range of well-established utilities behind the scenes. Sector emphasizes efficiency, configurability, and actionable output for both single and bulk domain analysis.

---

## 🔍 Features

- **Subdomain Discovery:** Gathers subdomains from multiple reliable sources.
- **JavaScript Asset Collection:** Extracts JavaScript URLs for potential analysis or fuzzing.
- **Virtual Host Scanning:** Supports mapping domains to specific IPs to uncover hidden hosts.
- **Smart JS Fuzzing:** Attempts to locate undiscovered JavaScript paths via intelligent fuzzing.
- **Vulnerability Detection:** Highlights suspicious patterns and integrates with advanced scanning engines.
- **Progress Feedback:** Displays interactive progress animations during operation.
- **Clean Output:** Ensures deduplication and structured artifact generation.
- **Self-Updating:** Can automatically update itself to the latest available version.

---

## ⚙️ Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/Nowafen/sector.git
    cd sector
    chmod +x sector
    chmod +x ./install.sh
    ./install.sh
    ```
2. Test:
   ```
   ./sector -h
   ```

4. Ensure dependencies are available in your system environment.
These include external utilities used for domain enumeration, content discovery, and vulnerability scanning.

---

## 🚀 Usage

```
./sector --help

Usage:
 sector [options]

Options:
  
    -d, --domain {domain}  
    Specify a single target domain (e.g., example.com)
  
    -l, --list {file}  
    Specify a file containing a list of domains to scan (e.g., file-domains.txt)
  
    -vhost {ip}  
    Specify an IP for virtual host scanning (e.g., http://5.5.5.5)
  
    -nc, --nuclei
    Smart scaning with private nuclei templates to find attack vectors
  
    -sjf, --smart-js-fuzzer  
    Smart fuzzing of JS file paths using ffuf to discover additional JS files
  
    -up, --update  
    update the version of tools
  
    -h, --help 
    Display this help menu

    Version : 

Examples:
  sector -d google.com
  sector -d google.com -vhost http://1.8.55.55  --nuclei
  sector -l file-domains.txt -nc
```

##### Contact 
[🔗 Telegram Channel](https://t.me/Tellmejs)
