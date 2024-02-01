#!/bin/bash

# Print a message and start the SSH service
echo "Starting SSH Service..."
/usr/sbin/sshd -D &

# Print a message and start Hadoop (replace with your specific Hadoop command)
echo "Starting Hadoop..."
# Example: start-dfs.sh (Replace with the actual command you need)
# /usr/local/hadoop/bin/start-dfs.sh

# Keep the container running
tail -f /dev/null
