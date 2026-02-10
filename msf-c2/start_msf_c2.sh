#!/bin/bash

# C2 Infrastructure Startup Script
C2_DIR="/home/kali/Desktop/c2/msf-c2"

echo "[*] Starting Kali Linux C2 Infrastructure..."

# 1. Start Database
echo "[*] Ensuring PostgreSQL is running..."
sudo systemctl start postgresql 

# 2. Check Database Status (Optional)
# sudo msfdb status

# 3. Launch Metasploit Handler
echo "[*] Launching Metasploit Multi-Handler..."
echo "[*] Loading Resource: $C2_DIR/advanced_handler.rc"

# Launch in quiet mode (-q) executing resource script (-r)
msfconsole -q -r "$C2_DIR/advanced_handler.rc"
