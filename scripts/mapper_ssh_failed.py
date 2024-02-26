#!/usr/bin/env python3
import sys
import csv

def map_failed_password_logs():
    reader = csv.reader(sys.stdin)
    next(reader)  # Skip the header row
    
    for row in reader:
        if len(row) == 5:
            pid, username, ip_address, port, log_type = row
            if log_type == "Failed password":
                print(f"{ip_address}\t{log_type}\t1")

if __name__ == "__main__":
    map_failed_password_logs()
