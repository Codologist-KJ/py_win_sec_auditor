import os
import csv
import argparse
from datetime import datetime
from typing import List
import subprocess
import logging

def setup_logging() -> None:
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def get_input() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Export Windows Event Logs to CSV")
    parser.add_argument("logname", choices=["System", "Security", "Application"], help="The Windows Event Log name to be processed")
    parser.add_argument("start_time", help="The start date and time to check the events from (format: YYYY-MM-DDTHH:MM:SS)")
    parser.add_argument("output", help="The output file path for the exported CSV file")
    args = parser.parse_args()

    # Validate start_time format
    try:
        datetime.strptime(args.start_time, "%Y-%m-%dT%H:%M:%S")
    except ValueError:
        parser.error("start_time must be in the format YYYY-MM-DDTHH:MM:SS")

    return args

def filter_parameters(logname: str, start_time: str) -> str:
    filter_hashtable = f"@{{Logname='{logname}'; StartTime='{start_time}';}}"
    return filter_hashtable

def export_event_logs(logname: str, filter_hashtable: str, output_file: str) -> None:
    script = f"""
    $Events = Get-WinEvent -FilterHashTable {filter_hashtable}
    $Events | Export-Csv -Path {output_file} -NoTypeInformation
    """
    try:
        subprocess.run(["powershell", "-Command", script], check=True)
        logging.info(f"Successfully exported {logname} event logs to {output_file}")
    except subprocess.CalledProcessError as e:
        logging.error(f"An error occurred while exporting {logname} event logs: {e}")

def main() -> None:
    setup_logging()
    args = get_input()
    filter_hashtable = filter_parameters(args.logname, args.start_time)
    export_event_logs(args.logname, filter_hashtable, args.output)

if __name__ == '__main__':
    main()
