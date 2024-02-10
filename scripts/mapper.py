#!/usr/bin/env python3
"""A more advanced Mapper, using Python iterators and generators."""

import sys

def read_input(file):
    for line in file:
        # Strip the line to remove leading/trailing whitespace and split the line into words
        yield line.strip().split()

def main(separator='\t'):
    # Input comes from STDIN (standard input)
    data = read_input(sys.stdin)
    for words in data:
        # Write the results to STDOUT (standard output);
        # What we output here will be the input for the
        # Reduce step, i.e., the input for reducer.py
        #
        # Tab-delimited; the trivial word count is 1
        for word in words:
            print("%s%s%d" % (word, separator, 1))


if __name__ == "__main__":
    main()
