### Sector is 
###### A high-performance attack surface mapping and vulnerability assessment tool for modern web targets. It automates reconnaissance workflows with precision, covering subdomains, JavaScript assets, virtual hosts, and potential weaknesses using a curated stack of battle-tested utilities. Sector is built for speed, flexibility, and delivering clear, actionable results; whether scanning a single domain or at scale.

---
## Summray
* [Features](#Features)
* [Installation](#Installation)
* [How worked?](#Usage)


#### Features

- ###### Comprehensive Subdomain Enumeration: Discovers subdomains by aggregating data from diverse, trusted sources for thorough coverage.
- ###### Advanced JavaScript Asset Discovery: Identifies and extracts JavaScript URLs for in-depth analysis or targeted fuzzing.
- ###### Virtual Host Mapping: Maps domains to specific IP addresses to reveal hidden or unlisted hosts with precision.
- ###### Smart JS Fuzzing: Employs smart fuzzing techniques to uncover hidden JavaScript paths and expand attack surface visibility.
- ###### Robust Vulnerability Scanning: Detects potential vulnerabilities by analyzing patterns and leveraging integration with cutting-edge scanning engines.
- ###### Real-Time Progress Tracking: Provides dynamic, interactive progress indicators for a clear view of scan operations.
- ###### Clean Output: Ensures deduplication and structured artifact generation.
- ###### Automatic Updates: Seamlessly updates itself to the latest version to ensure access to the newest features and improvements.

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
[tellme](https://t.me/Tellmejs)
