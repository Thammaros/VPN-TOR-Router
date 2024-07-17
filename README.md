
# VPN-TOR-Router

A Bash script that enables or disables routing OpenVPN traffic through the Tor network. This script configures iptables rules, updates OpenVPN and Tor configurations, and restarts the necessary services to ensure secure and anonymous browsing through VPN and Tor. Ideal for users seeking enhanced privacy and security.

**Note:** This script has been tested on Ubuntu Server 24.04 LTS.

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

1. **A running instance of Ubuntu Server 24.04** (other versions or distributions might work, but are not tested).
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

After enabling or disabling, it's recommended to:

1. **Manually reconnect your VPN client** to ensure that the new routing configuration is applied.
2. **Perform an IP leak test** to verify that your traffic is properly routed through Tor. You can use websites like [ipleak.net](https://ipleak.net) to check your IP address and DNS resolution.

## Configuration

This section details the configuration variables you can modify within the script to tailor it to your specific network setup and security requirements. Understanding each variable is crucial for ensuring the script functions correctly in your environment.

### Key Variables

- `VPN_INTERFACE="tun0"`:
  - **Description:** Specifies the network interface that OpenVPN uses for VPN connections.
  - **Default:** `tun0` is typically used for tunneled connections in OpenVPN.
  - **Customization:** Change this if your OpenVPN setup uses a different interface.

- `TOR_TRANSPORT_PORT="9040"`:
  - **Description:** Defines the port used for the Tor Transparent Proxy, which handles the actual data packets from the VPN.
  - **Default:** Port `9040` is commonly used for this purpose but can be changed if it conflicts with other services.
  - **Customization:** Modify this if you need to use a different port for Tor's Transparent Proxy.

- `TOR_DNS_PORT="5353"`:
  - **Description:** The port used for DNS queries over Tor, ensuring that DNS requests are anonymized.
  - **Default:** `5353` is chosen to avoid conflict with other common DNS services.
  - **Customization:** If another service is using this port, or if specific firewall rules require a different port, adjust accordingly.

- `TOR_SERVICE="tor"`:
  - **Description:** The system's service name for Tor.
  - **Default:** `tor` is standard on most Linux distributions but might differ if you have a custom installation.
  - **Customization:** Update this if your Tor service has a different name or if you use a specialized Tor setup.

- `OPENVPN_SERVICE="openvpn@server"`:
  - **Description:** Identifies the OpenVPN service name used for controlling the service via systemd.
  - **Default:** `openvpn@server` assumes a systemd service instance named after a configuration file `server.conf`.
  - **Customization:** Adjust this to match the actual service name of your OpenVPN instance, especially if using multiple configurations.

- `OPENVPN_CONF="/etc/openvpn/server.conf"`:
  - **Description:** The path to the OpenVPN configuration file.
  - **Default:** `/etc/openvpn/server.conf` is standard but may vary based on your installation or specific setup.
  - **Customization:** Ensure this path points to your active OpenVPN configuration file.

- `TOR_CONF="/etc/tor/torrc"`:
  - **Description:** The path to the Tor configuration file.
  - **Default:** `/etc/tor/torrc` is used in typical installations.
  - **Customization:** Should be adjusted if Tor is configured differently on your system.

- `DNS_OPTION="push \"dhcp-option DNS 10.8.0.1\""`:
  - **Description:** Configures the DNS server pushed to VPN clients. This setting ensures that DNS requests from clients go through the VPN.
  - **Default:** `10.8.0.1` is often used as a local DNS resolver in VPN setups.
  - **Customization:** Change this to the IP of your DNS resolver, especially if it's different from the VPN server or if you use external DNS services.

- `TOR_OPTIONS=("AutomapHostsOnResolve 1" "TransPort 0.0.0.0:9040" "DNSPort 0.0.0.0:5353")`:
  - **Description:** An array of options added to the Tor configuration file to enable automatic hostname resolution, transport redirection, and DNS port assignment.
  - **Default:** These options are set to typical values for integrating OpenVPN with Tor.
  - **Customization:** Each of these settings can be individually tailored based on network requirements or security policies.

### Adjusting Configuration

To modify these settings, open the script using a text editor of your choice, locate the variables listed above, and change their values as needed. Ensure that any changes align with your overall network and security configuration to prevent disruptions in service or vulnerabilities.

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
