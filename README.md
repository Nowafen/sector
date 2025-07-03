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

    ```
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
<details>
  <summary>Expand full help flags
  </summary>
    
```
sector -h

Sector is a high-performance attack surface mapping and vulnerability assessment tool,
designed to enhance your attack surface discovery with precision and depth.

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
    Perform advanced scanning to uncover potential attack vectors
  
    -pd, --parameter-discovery
    Identify hidden URL parameters to expand attack surface
  
    -sjf, --smart-js-fuzzer
    Enhance JS file discovery to broaden attack surface coverage
  
    -dbf, --dns-bruteforce
    Enable comprehensive DNS enumeration (requires -dbw and -dbr)
  
    -dbw, --dns-bruteforce-wordlist {file}
    Specify wordlist file for DNS enumeration (e.g., wordlist.txt)
  
    -dbr, --dns-bruteforce-resolvers {file}
    Specify resolvers file for DNS enumeration (e.g., resolvers.txt)
  
    -t, --thread {low|medium|high}
    Control parallel execution: low (2 tasks), medium (3 tasks, may stress the OS), high (all tasks, can heavily stress the OS (Default: None))
  
    -up, --update
    Update the tool to the latest version
  
    -h, --help
    Display this help menu
    
    Examples:
    sector -d google.com -t medium
    sector -d google.com -vhost http://85.85.69.69 -nc -t high
    sector -l file-domains.txt -nc -t low

    Version : 1.3.1
    
    Notes:
     Using multiple switches will trigger a deep scan.
     Please be patient as it may take significant time to complete.
```
</details>

##### Contact 
[🔗 Telegram Channel](https://t.me/Tellmejs)
