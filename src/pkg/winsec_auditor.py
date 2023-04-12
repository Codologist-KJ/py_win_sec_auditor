import os
import csv
import argparse
from datetime import datetime
from typing import List
import subprocess

def get_input() -> argparse.Namespace:
    logname = input("Enter the Windows Event Log name to be processed (System, Security, Application): ")
    start_time = input("Enter the start date and time to check the events from (format: YYYY-MM-DDTHH:MM:SS): ")
    output = input("Enter the output file path for the exported CSV file: ")
    return argparse.Namespace(logname=logname, start_time=start_time, output=output)

def filter_parameters(start_time: str) -> str:
    filter_hashtable = f"@{{Logname='{logname}'; StartTime='{start_time}';}}"
    return filter_hashtable

def export_event_logs(logname: str, filter_hashtable: str, output_file: str) -> None:
    script = f"""
    $Events = Get-WinEvent -FilterHashTable {filter_hashtable}
    $Events | Export-Csv -Path {output_file} -NoTypeInformation
    """
    try:
        subprocess.run(["powershell", "-Command", script], check=True)
        print(f"Successfully exported {logname} event logs to {output_file}")
    except subprocess.CalledProcessError as e:
        print(f"An error occurred while exporting {logname} event logs: {e}")

def main() -> None:
    args = get_input()
    filter_hashtable = filter_parameters(args.start_time)
    export_event_logs(args.logname, filter_hashtable, args.output)

if __name__ == '__main__':
    main()
