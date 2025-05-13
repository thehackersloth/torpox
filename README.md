```bash
.=========================================================================.
|                                                                         |
|    (`-')                   (`-')  _  (`-')           (`-')             |
|    ( OO).->       .->   <-.(OO )  \-.(OO )     .->   (OO )_.->         |
|    /    '._  (`-')----. ,------,) _.'    \(`-')----. (_| \_)--.        |
|    |'--...__)( OO).-.  '|   /`. '(_...--''( OO).-.  '\  `.'  /         |
|    `--.  .--'( _) | |  ||  |_.' ||  |_.' |( _) | |  | \    .')         |
|       |  |    \|  |)|  ||  .   .'|  .___.' \|  |)|  | .'    \          |
|       |  |     '  '-'  '|  |\  \ |  |       '  '-'  '/  .'.  \         |
|       `--'      `-----' `--' '--'`--'        `-----'`--'   '--'        |
|                                                                         |
|               TOR POX - TOR PROXY & BALANCER INSTALLER                  |
|                                                                         |
'========================================================================='
```


Automated Tor Proxy, OnionBalance, and WireGuard Deployment Script

Overview
Tor Pox is a fully automated bash script designed for Ubuntu and Debian-based systems to quickly deploy various Tor roles including:

Master Proxy with OnionBalance

Slave Proxy

Master & Slave Proxies with WireGuard integration

Host WireGuard relay to Master

Bridge Relay

Exit Node

This tool simplifies the deployment of a scalable Tor network setup with optional encrypted tunnels using WireGuard.

Features
🛡️ Master Proxy with OnionBalance support

🌐 Slave Proxy auto-configuration

🔐 WireGuard tunneling options for Master/Slave

🔗 Bridge relay setup for private connections

🚪 Exit node setup for public relay

⚙️ Simple text-based menu interface

Requirements
Ubuntu 20.04+ or Debian 10+

Root or sudo privileges

Usage
1. Download the script:

```bash
wget https://github.com/thehackersloth/torpox/blob/main/torpox.sh
chmod +x tor_pox.sh
```

3. Run the installer:
```bash
./torpox.sh
```
5. Follow the menu prompts:
```javascript

1) Master Proxy (OnionBalance)
2) Slave Proxy
3) Master Proxy with WireGuard
4) Slave Proxy with WireGuard
5) Host Server WireGuard to Master
6) Bridge Install
7) Exit Node Install
8) Exit
```

If you select a WireGuard option, you will be prompted to enter:

```console

WireGuard Peer Public Key

WireGuard Server IP Address
```

Example Setup Scenarios
Scenario	Use Options
High-availability hidden service	1 (Master) + multiple 2 (Slave)
Secure proxy behind VPN tunnel	3 or 4 (with WireGuard)
Remote host relaying traffic	5 (WireGuard to Master)
Tor private bridge relay	6
Public exit relay	7

Important Notes
Ensure your VPS provider allows Tor and Exit Node setups.

For Exit Nodes, ensure compliance with Tor guidelines and local laws.

WireGuard configurations require manual key input for secure peer linkage.

Disclaimer
This script is for educational and research purposes only.
Misuse may violate local laws or ISP policies.
Use at your own risk.

