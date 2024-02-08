#!/bin/bash

# Set environment variables
export HADOOP_HOME=/hadoop/
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# copy hadoop config to config folder
echo "[ENTRYPOINT] Copying config folder to hadoop config folder..."
cp -R /app/hadoop-config/* /hadoop/etc/hadoop

echo "[ENTRYPOINT] Starting SSH Service..."
/usr/sbin/sshd -D &

# Check if the initialization has already been completed
echo "[ENTRYPOINT] Initializing..."
if [ -f "/.init_completed" ]; then
    echo "Initialization has already been completed."
else
    echo "Formatting the HDFS namenode..."
    $HADOOP_HOME/bin/hdfs namenode -format
    
    touch "/.init_completed"
    echo "Initialization completed and marked as done."
fi

# Start Hadoop services
echo "[ENTRYPOINT] Starting cluster.."
$HADOOP_HOME/sbin/start-dfs.sh

echo "[ENTRYPOINT] Starting yarn service.."
$HADOOP_HOME/sbin/start-yarn.sh

echo "[ENTRYPOINT] Checking Hadoop services.."
jps

echo "[ENTRYPOINT] Check Hadoop ports.."
netstat -tuln | grep -E "9870|8088"

# Keep the container running
echo "[ENTRYPOINT] Startup completed!"
tail -f /dev/null
