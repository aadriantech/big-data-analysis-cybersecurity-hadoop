#!/usr/bin/env python3
"""Custom Mapper for parsing specific log entries."""

import sys

def read_input(file):
    for line in file:
        yield line.strip()

def main(separator='\t'):
    # Input comes from STDIN (standard input)
    data = read_input(sys.stdin)
    for line in data:
        # Splitting each line by comma to extract fields
        fields = line.split(',')
        if len(fields) > 5:  # Ensuring the line has enough fields
            # Extracting the IP address and URL
            ip_address = fields[1]
            url = fields[5]
            
            # Checking if the URL contains either 'xxx3.php' or 'blst.php'
            if 'xxx3.php' in url or 'blst.php' in url:
                # Extracting the file name from the URL
                file_name = 'xxx3.php' if 'xxx3.php' in url else 'blst.php'
                
                # Writing the IP address and file name to STDOUT
                # This will be the input for the Reduce step
                print(f"{ip_address}{separator}{file_name}{separator}1")

if __name__ == "__main__":
    main()
