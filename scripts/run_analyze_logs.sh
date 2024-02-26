#!/bin/bash

# Run the Python script with the specified file path
su - hadoop -c "python /app/scripts/prepare_hdfs_environment.py /app/runtime/generated_logs_beagle.csv"


