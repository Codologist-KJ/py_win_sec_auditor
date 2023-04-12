import os
import csv
import argparse
from datetime import datetime
from typing import List
import subprocess

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Windows Security Event Log Auditor')
    parser.add_argument('-l', '--logname', type=str, required=True, help='Windows Event Log name to be processed.')
    parser.add_argument('-f', '--filter', type=str, required=True, help='Filter parameters for event logs.')
    parser.add_argument('-o', '--output', type=str, required=True, help='Output file path for the exported CSV file.')
    return parser.parse_args()

def filter_parameters(filter: str) -> str:
    filters = filter.split(';')
    filter_hashtable = '@{'

    for f in filters:
        key, value = f.split('=')
        filter_hashtable += f"{key}='{value}';"

    filter_hashtable = filter_hashtable.rstrip(';')
    filter_hashtable += '}'
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
    args = parse_args()
    filter_hashtable = filter_parameters(args.filter)
    export_event_logs(args.logname, filter_hashtable, args.output)

if __name__ == '__main__':
    main()
