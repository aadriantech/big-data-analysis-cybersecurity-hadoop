#!/usr/bin/env python
# -*- coding: utf-8 -*-

import csv
import random
from datetime import datetime, timedelta

def generate_web_logs(count=1000):
    base_ips = ["200.179.157.1", "192.168.1.105"]  # Added an extra IP address
    paths = [
        "/blog/xmlrpc.php",
        "/blog/xmlsrv/xmlrpc.php",
        "/blogs/xmlsrv/xmlrpc.php",
        "/drupal/xmlrpc.php",
        "/phpgroupware/xmlrpc.php",
        "/wordpress/xmlrpc.php",
        "/xmlrpc/xmlrpc.php",
        "/xmlsrv/xmlrpc.php"
    ]
    start_time = datetime(2019, 1, 13, 1, 0, 0)

    with open('/app/runtime/generated_logs_vulnerable_4xx.csv', mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["IP", "Timestamp", "Request", "Status Code", "Response Size"])  # Writing the header

        for i in range(count):
            ip = random.choice(base_ips)  # Randomly choose an IP address
            path = random.choice(paths)
            timestamp = start_time + timedelta(seconds=i)
            status_code = "404"
            response_size = random.randint(288, 300)
            log_entry = [ip, timestamp.strftime("%d/%b/%Y:%H:%M:%S -0200"), f"POST {path} HTTP/1.0", status_code, response_size]
            writer.writerow(log_entry)  # Writing the log entry

# Call the function to generate and save logs
generate_web_logs()
