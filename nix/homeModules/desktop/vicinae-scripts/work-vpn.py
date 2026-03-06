#!/usr/bin/env python3
# @vicinae.schemaVersion 1
# @vicinae.title Work Vpn
# @vicinae.mode silent
# @vicinae.argument1 {"type": "text", "placeholder": "on/off"}
import sys
import subprocess

CMD_ON = ["nmcli", "connection", "up", "nizelnikii"]
CMD_OFF = ["nmcli", "connection", "down", "nizelnikii"]

arg = sys.argv[1]
cmd = []

if "on".startswith(arg.lower()):
    cmd = CMD_ON
elif "off".startswith(arg.lower()):
    cmd = CMD_OFF
else:
    exit(0)

status = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8")

print(status.stdout)
print(status.stderr)
