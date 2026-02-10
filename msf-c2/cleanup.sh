#!/bin/bash

echo "[*] Stopping C2 Infrastructure..."

# Kill all msfconsole processes
pkill -f msfconsole
echo "[+] Metasploit processes terminated."

# Optional: Stop postgresql if desired (commented out by default)
# sudo systemctl stop postgresql
# echo "[+] Database stopped."

echo "[*] Cleanup complete."
