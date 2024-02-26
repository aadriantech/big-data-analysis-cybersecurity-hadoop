#!/usr/bin/env python3
import sys
from collections import defaultdict

def reduce_failed_password_logs():
    current_count = defaultdict(int)  # A dictionary to hold counts of failed password attempts per IP and log type

    for line in sys.stdin:
        parts = line.strip().split('\t')
        if len(parts) == 3:
            ip_address, log_type, count = parts
            key = (ip_address, log_type)  # Creating a tuple to use as a key
            current_count[key] += int(count)
    
    for key, count in current_count.items():
        ip_address, log_type = key
        print(f"{ip_address}\t{log_type}\t{count}")

if __name__ == "__main__":
    reduce_failed_password_logs()
