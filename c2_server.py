#!/usr/bin/env python3
"""
Simple C2 HTTP Server
Receives beacons and logs them
"""

from flask import Flask, request
from datetime import datetime
import json

app = Flask(__name__)

@app.route('/beacon', methods=['GET', 'POST'])
def receive_beacon():
    """Receive beacon from infected host"""
    beacon_data = {
        'timestamp': datetime.now().isoformat(),
        'source_ip': request.remote_addr,
        'user_agent': request.headers.get('User-Agent'),
        'method': request.method
    }
    
    print(f"[{beacon_data['timestamp']}] Beacon from {beacon_data['source_ip']}")
    
    # Log to file
    with open('/tmp/c2_beacons.log', 'a') as f:
        f.write(json.dumps(beacon_data) + '\n')
    
    return "OK", 200

@app.route('/command', methods=['GET'])
def send_command():
    """Send command to beacon"""
    return json.dumps({"cmd": "nop", "sleep": 10})

if __name__ == "__main__":
    print("C2 Server starting on 192.168.56.10:8070")
    app.run(host='0.0.0.0', port=8070, debug=False)
