#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random
import csv

def generate_log():
    # Base parts of the log entries
    ip = "192.168.2.204"
    status = "TCP_MISS/404"
    methods = ["GET"]
    domains = ["www.ordendeslichts.de", "www.levada.ru", "www.etype.hostingcity.net",
               "www.deadlygames.de", "stroyindustry.ru", "service6.valuehost.ru",
               "schiffsparty.de"]
    paths = ["/intern/", "/htmlarea/images/", "/mysql_admin_new/images/", "/DG/BF/BF­Links/clans/",
             "/service/construction/", "/images/", "/bilder/uploads/"]
    file_names = ["xxx3.php?", "blst.php?"]  # Added another file name
    protocols = ["DIRECT"]
    ips = ["81.201.107.6", "62.118.252.213", "217.158.10.80", "81.169.145.95",
           "217.16.16.135", "217.112.42.95", "212.227.94.133"]
    content_type = "text/html"
    
    # Randomize parts of the log entry
    method = random.choice(methods)
    domain = random.choice(domains)
    path = random.choice(paths)
    file_name = random.choice(file_names)  # Choose between the two file names
    protocol = random.choice(protocols)
    ip_address = random.choice(ips)
    size = random.randint(400, 1500)
    duration = random.randint(400, 1000)
    
    # Construct the log entry
    log_entry = f"{size},{ip},{status},{duration},{method},http://{domain}{path}{file_name}-{protocol}/{ip_address},{content_type}"
    
    return log_entry

# Generate 1000 logs
logs = [generate_log() for _ in range(1000)]

# Save the logs to a CSV file in the /app/runtime folder
csv_file_path = "/app/runtime/generated_logs.csv"  # Adjusted path
with open(csv_file_path, "w", newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Size", "IP", "Status", "Duration", "Method", "URL", "Content-Type"])  # Header
    for log in logs:
        writer.writerow(log.split(','))

print(f"Generated 1000 logs and saved to {csv_file_path}")
