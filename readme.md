PortCatcher

PortCatcher is a versatile and efficient port scanning tool that helps you identify open ports and determine the services running on them. It supports scanning specific ports or all ports on a target IP address and can optionally detect service versions.
Features

Scan Specific Ports: Check the status of specified ports.
Scan All Ports: Conduct a comprehensive scan of all ports (1-65535).
Service Detection: Identify the services running on open ports.
Version Detection: Attempt to detect the version of services on open ports.
Ping Host: Verify if a host is reachable.

Usage
Basic Usage

bash

	./portcatcher.sh -t <TARGET_IP> -p <PORTS> [-sv]

Options

    -h, --help: Display the help message.
    -t, --target <IP_ADDRESS>: Specify the target IP address.
    -p, --port <PORTS>: Specify the port range (comma-separated list or range).
    -p-, --all-ports: Scan all ports (1-65535).
    -sn, --ping <HOST>: Ping a host to check if it's alive.
    -sv, --version: Attempt to detect the version of the service running on open ports.

Examples

Scan Specific Ports

bash

	./portcatcher.sh -t 192.168.0.1 -p 22,80,443

Scan All Ports

bash

	./portcatcher.sh -t 192.168.0.1 -p-

Scan Specific Ports and Detect Service Versions

bash

	./portcatcher.sh -t 192.168.0.1 -p 22,80 -sv

Ping a Host

bash

    	./portcatcher.sh -sn example.com

Installation

Clone the Repository

bash

	git clone https://github.com/yourusername/portcatcher.git

Navigate to the Directory

bash

	cd portcatcher

Make the Script Executable

bash

    chmod +x portcatcher.sh

Contributing

Contributions are welcome! Please submit issues or pull requests to improve the functionality or fix bugs. Ensure that you follow the coding guidelines and test your changes before submitting.
License



For any questions or feedback, please reach out to your dheerajbalan7@gmail.com.
