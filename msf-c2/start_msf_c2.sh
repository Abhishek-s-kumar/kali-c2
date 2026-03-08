#!/bin/bash

# C2 Infrastructure Startup Script
C2_DIR="/home/kali/Desktop/c2/msf-c2"

echo "[*] Starting Kali Linux C2 Infrastructure..."

# 1. Start Database
echo "[*] Ensuring PostgreSQL is running..."
sudo systemctl start postgresql 

# 2. Initialize Database (if needed)
if [ ! -f /usr/share/metasploit-framework/config/database.yml ]; then
    echo "[!] Database not initialized. Attempting init..."
    sudo msfdb init
fi

# 3. Launch Metasploit Handler
echo "[*] Launching Multi-Port Research Handlers..."

# Launch in quiet mode (-q) executing the research resource script
msfconsole -q -r "$C2_DIR/research_handlers.rc"
