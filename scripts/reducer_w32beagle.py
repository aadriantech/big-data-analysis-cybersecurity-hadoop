#!/usr/bin/env python3
"""Simple Reducer for aggregating log entry counts."""

import sys
from itertools import groupby
from operator import itemgetter

def read_mapper_output(file, separator='\t'):
    for line in file:
        # Split the line into parts based on the separator and strip whitespace
        yield line.rstrip().split(separator, 2)

def main(separator='\t'):
    # Input comes from STDIN
    data = read_mapper_output(sys.stdin, separator=separator)
    # Sort the data by IP address and file name to ensure grouping works
    sorted_data = sorted(data, key=itemgetter(0, 1))
    # Group the sorted data by the IP address and filename (the first two fields)
    for (ip_address, file_name), group in groupby(sorted_data, key=itemgetter(0, 1)):
        try:
            # Sum the counts, which are the third element in each group's items
            total_count = sum(int(count) for _, _, count in group)
            print(f"{ip_address}{separator}{file_name}{separator}{total_count}")
        except ValueError:
            # If count is not a number, skip this group
            continue

if __name__ == "__main__":
    main()
