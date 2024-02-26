#!/usr/bin/env python
# -*- coding: utf-8 -*-

import csv
import random

def generate_sshd_log():
    base_log = "sshd[{}]: {} for invalid user {} from {} port {} ssh2"
    invalid_user_log = "sshd[{}]: Invalid user {} from {}"
    
    # Simulate process IDs (PIDs)
    pid = random.randint(9000, 10000)
    
    # Sample usernames and IP addresses
    usernames = ["admin", "fluffy", "slasher", "sifak", "guest", "test"]
    ip_addresses = ["200.30.175.162", "192.168.1.1", "172.16.0.1", "10.0.0.1"]
    
    # Random selections for the log
    username = random.choice(usernames)
    ip_address = random.choice(ip_addresses)
    port = random.randint(58000, 59000)
    
    # Constructing the logs
    failed_password_log = base_log.format(pid, "Failed password", username, ip_address, port)
    invalid_user_log = invalid_user_log.format(pid, username, ip_address)
    
    return [pid, username, ip_address, port, "Failed password"], [pid, username, ip_address, port, "Invalid user"]

# Generate 1000 pairs of logs
logs = [generate_sshd_log() for _ in range(1000)]

# Define the path where you want to save the CSV file
csv_file_path = "/app/runtime/generated_logs_ssh.csv"

# Writing to CSV in the specified directory
with open(csv_file_path, mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["PID", "Username", "IP Address", "Port", "Log Type"])  # Writing the header
    for log_pair in logs:
        writer.writerow(log_pair[0])  # Writing the failed password log
        writer.writerow(log_pair[1])  # Writing the invalid user log

print(f"Generated {len(logs)*2} SSHD logs and saved to {csv_file_path}")

