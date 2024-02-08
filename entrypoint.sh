#!/bin/bash

# Print a message and start the SSH service
echo "Starting SSH Service..."
/usr/sbin/sshd -D &

# Print a message and start Hadoop (replace with your specific Hadoop command)
# Example: start-dfs.sh (Replace with the actual command you need)
#/usr/local/hadoop/bin/start-dfs.sh
#echo "[ENTRYPOINT] Starting cluster.."
start-dsf.sh

#echo "[ENTRYPOINT] Starting yarn service.."
start-yarn.sh

#echo "[ENTRYPOINT] Checking Hadoop services.."
jps

#echo "[ENTRYPOINT] Check Hadoop ports.."
netstat -tuln | grep "9870|8088"


# Keep the container running
tail -f /dev/null
