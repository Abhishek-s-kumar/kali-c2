#!/usr/bin/env python3
"""
Simple C2 Beacon Generator
Sends periodic HTTP requests to simulate C2 traffic
"""

import requests
import time
import random
from datetime import datetime

C2_SERVER = "http://192.168.56.10:8080"
BEACON_INTERVAL = 10  # seconds
JITTER_PERCENT = 10   # 10% jitter

def beacon():
    """Send beacon to C2 server"""
    try:
        response = requests.get(
            f"{C2_SERVER}/beacon",
            timeout=5,
            headers={'User-Agent': 'Mozilla/5.0'}
        )
        print(f"[{datetime.now().strftime('%H:%M:%S')}] Beacon sent - Status: {response.status_code}")
    except Exception as e:
        print(f"[{datetime.now().strftime('%H:%M:%S')}] Beacon failed: {e}")

def main():
    print(f"Starting beacon to {C2_SERVER}")
    print(f"Interval: {BEACON_INTERVAL}s (±{JITTER_PERCENT}%)")
    print()
    
    while True:
        beacon()
        
        # Calculate sleep time with jitter
        jitter = random.uniform(-JITTER_PERCENT/100, JITTER_PERCENT/100)
        sleep_time = BEACON_INTERVAL * (1 + jitter)
        
        time.sleep(sleep_time)

if __name__ == "__main__":
    main()
