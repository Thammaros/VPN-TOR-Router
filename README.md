
# VPN-TOR-Router

A Bash script that enables or disables routing OpenVPN traffic through the Tor network. This script configures iptables rules, updates OpenVPN and Tor configurations, and restarts the necessary services to ensure secure and anonymous browsing through VPN and Tor. Ideal for users seeking enhanced privacy and security.

**Note:** This script has been tested on Ubuntu Server 22.04.

## Features

- Redirect VPN traffic through Tor
- Modify iptables rules for both IPv4 and IPv6
- Update OpenVPN and Tor configurations dynamically
- Enable and disable routing easily

## Requirements

- OpenVPN (setup using [angristan/openvpn-install](https://github.com/angristan/openvpn-install))
- Tor
- iptables

## Prerequisites

Before running the script, ensure you have the following:

1. **A running instance of Ubuntu Server 22.04** (other versions or distributions might work, but are not tested).
2. **Root or sudo access** to install and configure the required services.
3. **Installed and configured OpenVPN**:
   - Follow the instructions in the [angristan/openvpn-install](https://github.com/angristan/openvpn-install) repository to set up OpenVPN.
4. **Installed Tor**:
   - Install Tor using the package manager:
     ```sh
     sudo apt update
     sudo apt install tor
     ```
5. **Installed iptables**:
   - Install iptables if it is not already installed:
     ```sh
     sudo apt update
     sudo apt install iptables
     ```

## Installation

### Setting Up OpenVPN

1. **Clone the OpenVPN install repository:**
   ```sh
   git clone https://github.com/angristan/openvpn-install.git
   cd openvpn-install
   chmod +x openvpn-install.sh
   ```

2. **Run the OpenVPN install script:**
   ```sh
   sudo ./openvpn-install.sh
   ```
   Follow the on-screen instructions to complete the setup.

### Setting Up VPN-TOR-Router

1. **Clone the VPN-TOR-Router repository:**
   ```sh
   git clone https://github.com/Thammaros/VPN-TOR-Router.git
   cd VPN-TOR-Router
   ```

2. **Make the script executable:**
   ```sh
   chmod +x vpn_tor_router.sh
   ```

## Usage

Run the script with `sudo` and provide either `enable` or `disable` as an argument:

```sh
sudo ./vpn_tor_router.sh enable
sudo ./vpn_tor_router.sh disable
```

### Configuration

You can modify the configuration variables in the script to suit your setup. Below are the key variables you might need to adjust:

- `VPN_INTERFACE="tun0"`
- `TOR_TRANSPORT_PORT="9040"`
- `TOR_DNS_PORT="5353"`
- `TOR_SERVICE="tor"`
- `OPENVPN_SERVICE="openvpn@server"`
- `OPENVPN_CONF="/etc/openvpn/server.conf"`
- `TOR_CONF="/etc/tor/torrc"`
- `DNS_OPTION="push "dhcp-option DNS 10.8.0.1""`
- `TOR_OPTIONS=("AutomapHostsOnResolve 1" "TransPort 0.0.0.0:9040" "DNSPort 0.0.0.0:5353")`

## Example

To enable Tor routing:

```sh
sudo ./vpn_tor_router.sh enable
```

To disable Tor routing:

```sh
sudo ./vpn_tor_router.sh disable
```

## Contributing

This project is for my personal learning purposes, and I am not accepting contributions. However, feel free to fork the repository and experiment on your own.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
