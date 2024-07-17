#!/bin/bash

# Configuration variables
VPN_INTERFACE="tun0"
TOR_TRANSPORT_PORT="9040"
TOR_DNS_PORT="5353"
TOR_SERVICE="tor"
OPENVPN_SERVICE="openvpn@server"
OPENVPN_CONF="/etc/openvpn/server.conf"
TOR_CONF="/etc/tor/torrc"
DNS_OPTION="push \"dhcp-option DNS 10.8.0.1\""
TOR_OPTIONS=("AutomapHostsOnResolve 1" "TransPort 0.0.0.0:9040" "DNSPort 0.0.0.0:5353")

function enable_tor() {
    echo "Enabling Tor routing for OpenVPN..."

    # Add iptables rules to route VPN traffic through Tor
    sudo iptables -t nat -A PREROUTING -i $VPN_INTERFACE -p tcp --syn -j REDIRECT --to-ports $TOR_TRANSPORT_PORT
    sudo iptables -t nat -A PREROUTING -i $VPN_INTERFACE -p udp --dport 53 -j REDIRECT --to-ports $TOR_DNS_PORT
    sudo iptables -t nat -A PREROUTING -i $VPN_INTERFACE -p tcp --dport 53 -j REDIRECT --to-ports $TOR_DNS_PORT

    # Save iptables rules
    sudo iptables-save | sudo tee /etc/iptables/rules.v4 > /dev/null

    # For IPv6
    sudo ip6tables -t nat -A PREROUTING -i $VPN_INTERFACE -p tcp --syn -j REDIRECT --to-ports $TOR_TRANSPORT_PORT
    sudo ip6tables -t nat -A PREROUTING -i $VPN_INTERFACE -p udp --dport 53 -j REDIRECT --to-ports $TOR_DNS_PORT
    sudo ip6tables -t nat -A PREROUTING -i $VPN_INTERFACE -p tcp --dport 53 -j REDIRECT --to-ports $TOR_DNS_PORT
    sudo ip6tables-save | sudo tee /etc/iptables/rules.v6 > /dev/null

    # Add DNS option to OpenVPN configuration if not already present
    if ! grep -q "$DNS_OPTION" "$OPENVPN_CONF"; then
        echo "$DNS_OPTION" | sudo tee -a "$OPENVPN_CONF"
    fi

    # Add Tor options to torrc if not already present
    for option in "${TOR_OPTIONS[@]}"; do
        if ! grep -q "^$option" "$TOR_CONF"; then
            echo "$option" | sudo tee -a "$TOR_CONF"
        fi
    done

    # Restart services
    sudo systemctl restart $TOR_SERVICE
    sudo systemctl restart $OPENVPN_SERVICE

    echo "Tor routing enabled."
}

function disable_tor() {
    echo "Disabling Tor routing for OpenVPN..."

    # Remove iptables rules to stop routing VPN traffic through Tor
    sudo iptables -t nat -D PREROUTING -i $VPN_INTERFACE -p tcp --syn -j REDIRECT --to-ports $TOR_TRANSPORT_PORT
    sudo iptables -t nat -D PREROUTING -i $VPN_INTERFACE -p udp --dport 53 -j REDIRECT --to-ports $TOR_DNS_PORT
    sudo iptables -t nat -D PREROUTING -i $VPN_INTERFACE -p tcp --dport 53 -j REDIRECT --to-ports $TOR_DNS_PORT

    # Save iptables rules
    sudo iptables-save | sudo tee /etc/iptables/rules.v4 > /dev/null

    # For IPv6
    sudo ip6tables -t nat -D PREROUTING -i $VPN_INTERFACE -p tcp --syn -j REDIRECT --to-ports $TOR_TRANSPORT_PORT
    sudo ip6tables -t nat -D PREROUTING -i $VPN_INTERFACE -p udp --dport 53 -j REDIRECT --to-ports $TOR_DNS_PORT
    sudo ip6tables -t nat -D PREROUTING -i $VPN_INTERFACE -p tcp --dport 53 -j REDIRECT --to-ports $TOR_DNS_PORT
    sudo ip6tables-save | sudo tee /etc/iptables/rules.v6 > /dev/null

    # Remove DNS option from OpenVPN configuration
    sudo sed -i "/$DNS_OPTION/d" "$OPENVPN_CONF"

    # Remove Tor options from torrc
    for option in "${TOR_OPTIONS[@]}"; do
        sudo sed -i "/^$option/d" "$TOR_CONF"
    done

    # Restart services
    sudo systemctl stop $TOR_SERVICE
    sudo systemctl restart $OPENVPN_SERVICE

    echo "Tor routing disabled."
}

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

# Main script logic
case $1 in
    enable)
        enable_tor
        ;;
    disable)
        disable_tor
        ;;
    *)
        echo "Usage: $0 {enable|disable}"
        exit 1
        ;;
esac
