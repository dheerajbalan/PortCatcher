#!/bin/bash

function help() {
    echo "Usage: ./script.sh [-t 192.168.0.2 -p 22,21,3306 | -p-] [-sn target_to_ping] [-sv]"
    echo ""
    echo "OPTIONS:"
    echo " -h ,--help        display this help message"
    echo " -t, --target      specify the target IP (optional for ping)"
    echo " -p, --port        specify the port range (optional for ping)"
    echo " -p-, --all-ports  scan all ports (1-65535) on the target"
    echo " -sn,--ping        specify a host or IP to ping"
    echo " -sv,--version     attempt to detect the version of the service running on open ports"
}

# Initialize variables
target=""
port=""
ping_target=""
scan_all_ports=false
detect_version=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            help
            exit 0
            ;;
        -t|--target)
            target=$2
            shift 2
            ;;
        -p|--port)
            port=$2
            shift 2
            ;;
        -p-|--all-ports)
            scan_all_ports=true
            shift 1
            ;;
        -sn|--ping)
            ping_target=$2
            shift 2
            ;;
        -sv|--version)
            detect_version=true
            shift 1
            ;;
        *)
            echo "Invalid option: $1"
            help
            exit 1
            ;;
    esac
done

# Perform ping if specified
if [ -n "$ping_target" ]; then
    echo "Pinging $ping_target..."
    ping -c 3 $ping_target > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Host $ping_target is alive"
    else
        echo "Host $ping_target is dead"
    fi
    exit 0
fi

# If neither target nor port is specified, print an error
if [ -z "$target" ]; then
    echo "Please specify the target address for port scanning!!"
    exit 2
fi

# Function to detect service version using nc
function detect_service_version() {
    local port=$1
    # Use nc with a timeout to connect to the port and grab the banner
    version_info=$(echo '' | nc -nv -w 3 $target $port 2>/dev/null | tr -d '\0')
    
    if [ -z "$version_info" ]; then
        version_info="Unknown"
    fi
    
    echo "$version_info"
}

# Determine the service name based on the port number
function get_service_name() {
    local port=$1
    service_name=$(getent services "$port" | awk '{print $1}')
    if [ -z "$service_name" ]; then
        service_name="Unknown"
    fi
    echo "$service_name"
}

echo "scan report of $target"
echo 
# Perform port scan
echo -e "PORT\tSTATE SERVICE VERSION"

if [ "$scan_all_ports" = true ]; then
    for port in $(seq 1 65535); do
        timeout 1 bash -c "echo > /dev/tcp/$target/$port" 2>/dev/null
        if [ $? -eq 0 ]; then
            service_name=$(get_service_name $port)
            echo -n -e "$port/tcp  open  $service_name"
            if [ "$detect_version" = true ]; then
                version_info=$(detect_service_version $port)
                echo "  $version_info"
            else
                echo ""
            fi
        fi
    done
else
    if [ -z "$port" ]; then
        echo "Please specify the port range or use the --all-ports option!"
        exit 2
    fi

    IFS=',' read -ra PORT_ARRAY <<< "$port"
    for port in "${PORT_ARRAY[@]}"; do
        timeout 1 bash -c "echo > /dev/tcp/$target/$port" 2>/dev/null
        if [ $? -eq 0 ]; then
            service_name=$(get_service_name $port)
            echo -n "$port/tcp  open   $service_name"
            if [ "$detect_version" = true ]; then
                version_info=$(detect_service_version $port)
                echo "  $version_info"
            else
                echo ""
            fi
        else
            echo "$port/tcp  closed"
        fi
    done
fi
