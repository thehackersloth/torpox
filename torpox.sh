#!/bin/bash
# Title: Tor Pox

clear

echo -e "\e[36m"
cat << "EOF"
(`-')                   (`-')  _  (`-')           (`-')     
( OO).->       .->   <-.(OO )  \-.(OO )     .->   (OO )_.-> 
/    '._  (`-')----. ,------,) _.'    \(`-')----. (_| \_)--.
|'--...__)( OO).-.  '|   /`. '(_...--''( OO).-.  '\  `.'  / 
`--.  .--'( _) | |  ||  |_.' ||  |_.' |( _) | |  | \    .') 
   |  |    \|  |)|  ||  .   .'|  .___.' \|  |)|  | .'    \  
   |  |     '  '-'  '|  |\  \ |  |       '  '-'  '/  .'.  \ 
   `--'      `-----' `--' '--'`--'        `-----'`--'   '--'
EOF
echo -e "\e[0m"

echo "Welcome to Tor Pox - Automated Tor Proxy and Balancer Installer"
echo ""

function prompt_wireguard_info() {
    echo ""
    read -p "Enter WireGuard Peer Public Key: " WG_KEY
    read -p "Enter WireGuard Server IP: " WG_IP
    echo "WireGuard Key: $WG_KEY"
    echo "WireGuard IP: $WG_IP"
}

function common_install_prereqs() {
    echo "[*] Updating system and installing prerequisites..."
    apt update && apt upgrade -y
    apt install -y tor deb.torproject.org-keyring apt-transport-https gnupg2 curl ufw
}

function install_onionbalance() {
    echo "[*] Installing OnionBalance..."
    apt install -y python3-pip
    pip3 install onionbalance
}

function install_master_proxy() {
    common_install_prereqs
    install_onionbalance
    echo "[*] Setting up Master Proxy Configuration..."
    # Example master onion config placeholder
    mkdir -p /etc/tor/master
    cat <<EOF > /etc/tor/master/torrc
SocksPort 0
ORPort 9001
DirPort 9030
ExitRelay 0
BridgeRelay 0
HiddenServiceDir /var/lib/tor/onion_master/
HiddenServicePort 80 127.0.0.1:80
EOF
    systemctl restart tor
    echo "[*] Master Proxy setup done."
}

function install_slave_proxy() {
    common_install_prereqs
    echo "[*] Setting up Slave Proxy Configuration..."
    mkdir -p /etc/tor/slave
    cat <<EOF > /etc/tor/slave/torrc
SocksPort 0
ORPort 9001
DirPort 9030
ExitRelay 0
BridgeRelay 0
HiddenServiceDir /var/lib/tor/onion_slave/
HiddenServicePort 80 127.0.0.1:80
EOF
    systemctl restart tor
    echo "[*] Slave Proxy setup done."
}

function install_wireguard() {
    echo "[*] Installing WireGuard..."
    apt install -y wireguard
    mkdir -p /etc/wireguard
    cat <<EOF > /etc/wireguard/wg0.conf
[Interface]
PrivateKey = $(wg genkey | tee /etc/wireguard/privatekey)
Address = 10.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = $WG_KEY
Endpoint = $WG_IP:51820
AllowedIPs = 0.0.0.0/0
EOF
    systemctl enable wg-quick@wg0
    systemctl start wg-quick@wg0
}

function install_master_with_wireguard() {
    prompt_wireguard_info
    install_wireguard
    install_master_proxy
}

function install_slave_with_wireguard() {
    prompt_wireguard_info
    install_wireguard
    install_slave_proxy
}

function install_wireguard_host_to_master() {
    prompt_wireguard_info
    install_wireguard
    echo "[*] WireGuard configured for Host to Master relay."
}

function install_bridge() {
    common_install_prereqs
    echo "[*] Configuring Tor Bridge Relay..."
    cat <<EOF > /etc/tor/torrc
SocksPort 0
ORPort 9001
BridgeRelay 1
ExitRelay 0
PublishServerDescriptor bridge
EOF
    systemctl restart tor
    echo "[*] Bridge Relay setup done."
}

function install_exit_node() {
    common_install_prereqs
    echo "[*] Configuring Tor Exit Node..."
    cat <<EOF > /etc/tor/torrc
SocksPort 0
ORPort 9001
DirPort 9030
ExitRelay 1
ExitPolicy accept *:*
EOF
    systemctl restart tor
    echo "[*] Exit Node setup done."
}

while true; do
    echo ""
    echo "Select an option:"
    echo "1) Master Proxy (OnionBalance)"
    echo "2) Slave Proxy"
    echo "3) Master Proxy with WireGuard"
    echo "4) Slave Proxy with WireGuard"
    echo "5) Host Server WireGuard to Master"
    echo "6) Bridge Install"
    echo "7) Exit Node Install"
    echo "8) Exit"
    read -p "Choice: " choice

    case $choice in
        1)
            install_master_proxy
            ;;
        2)
            install_slave_proxy
            ;;
        3)
            install_master_with_wireguard
            ;;
        4)
            install_slave_with_wireguard
            ;;
        5)
            install_wireguard_host_to_master
            ;;
        6)
            install_bridge
            ;;
        7)
            install_exit_node
            ;;
        8)
            echo "[*] Exiting Tor Pox."
            exit 0
            ;;
        *)
            echo "[!] Invalid option. Please try again."
            ;;
    esac
done
