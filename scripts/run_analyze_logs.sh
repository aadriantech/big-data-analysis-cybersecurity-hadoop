#!/bin/bash

# Run the Python script with the specified file path, RUN AS hadoop user
python /app/scripts/prepare_hdfs_environment.py /app/runtime/generated_logs_beagle.csv
python /app/scripts/prepare_hdfs_environment.py /app/runtime/generated_logs_ssh.csv

# Run the Java streaming command to run the mapper and 
# the reducer for Beagle Worm Analysis
#hadoop jar /hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
  -files "/app/scripts/mapper_w32beagle.py,/app/scripts/reducer_w32beagle.py" \
  -mapper "python mapper_w32beagle.py" \
  -reducer "python reducer_w32beagle.py" \
  -input "hdfs://localhost:9000/logs/generated_logs_beagle.csv" \
  -output "/Wordcount"

hdfs dfs -ls /Wordcount

# Run the Java streaming command to run the mapper and 
# the reducer for SSH Failed Analysis
hdfs dfs -rm -r /WordcountSsh
hadoop jar /hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
  -D mapred.reduce.tasks=2 \
  -files "/app/scripts/mapper_ssh_failed.py,/app/scripts/reducer_ssh_failed.py" \
  -mapper "python mapper_ssh_failed.py" \
  -reducer "python reducer_ssh_failed.py" \
  -input "hdfs://localhost:9000/logs/generated_logs_ssh.csv" \
  -output "/WordcountSsh"

hdfs dfs -ls /WordcountSsh

#hdfs dfs -cat /logs/generated_logs_beagle.csv | python /app/scripts/mapper_w32beagle.py | sort
#hdfs dfs -cat /logs/generated_logs_ssh.csv | python /app/scripts/mapper_ssh_failed.py | sort | python /app/scripts/reducer_ssh_failed.py
# hdfs dfs -cat /WordcountSsh/part-00000
