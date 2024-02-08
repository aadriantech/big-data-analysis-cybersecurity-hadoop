#!/usr/bin/python

import sys 
for line in sys.stdin: 
    # remove leading and trailing whitespace 
    line = line.strip() 
    # split the line into words 
    words = line.split() 
    # increase counters 
    for word in words: 
        print(word, "1")
