### Sector is 
###### A high-performance attack surface mapping and vulnerability assessment tool for modern web targets. It automates reconnaissance workflows with precision, covering subdomains, JavaScript assets, virtual hosts, and potential weaknesses using a curated stack of battle-tested utilities. Sector is built for speed, flexibility, and delivering clear, actionable results; whether scanning a single domain or at scale.

---
## Summray
* [Features](#Features)
* [Installation](#Installation)
* [How worked?](#Usage)


#### Features

- ###### Subdomain Discovery: Gathers subdomains from multiple reliable sources.
- ###### JavaScript Asset Collection: Extracts JavaScript URLs for potential analysis or fuzzing.
- ###### Virtual Host Scanning: Supports mapping domains to specific IPs to uncover hidden hosts.
- ###### Smart JS Fuzzing: Attempts to locate undiscovered JavaScript paths via intelligent fuzzing.
- ###### Vulnerability Detection: Highlights suspicious patterns and integrates with advanced scanning engines.
- ###### Progress Feedback: Displays interactive progress animations during operation.
- ###### Clean Output: Ensures deduplication and structured artifact generation.
- ###### Self-Updating: Can automatically update itself to the latest available version.

---

### Installation

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

### Usage

```
./sector -h

Usage:
 sector [options]

Options:
  
    -d, --domain
    {domain}  Specify a single target domain (e.g., example.com)
  
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


    Version : 1.2.3

Examples:
  sector -d google.com
  sector -d google.com -vhost http://85.85.1.1  -nuclei
  sector -l file-domains.txt -nc
```

##### Contact 
[🔗 Telegram Channel](https://t.me/Tellmejs)
