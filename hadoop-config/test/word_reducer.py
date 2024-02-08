#!/usr/bin/python

import sys

current_word = None
current_count = 1
word_dict = dict({})
for line in sys.stdin:
    word, count = line.strip().split(' ')
    
    if word in word_dict.keys():
        word_dict[word] = word_dict[word] + 1
        current_count = word_dict[word]
    else:
        word_dict[word] = 1
    current_count = word_dict[word]
    current_word = word

for word in word_dict.keys():
    print(word, word_dict[word])

    

