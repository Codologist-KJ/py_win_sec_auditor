#!/usr/bin/env python3

import sys
import subprocess

ps_script = "./ps/WinSecAudit_v1.ps1"

def run_pscript():
    cmd = ["PowerShell", "-ExecutionPolicy", "RemoteSigned", "-File", ps_script ]  # Specify relative or absolute path to the script
    ec = subprocess.call(cmd)
    print("Powershell returned: {0:d}".format(ec))


if __name__ == "__main__":
    run_pscript()
    print("\nThe Windows security auditing process is complete...")
