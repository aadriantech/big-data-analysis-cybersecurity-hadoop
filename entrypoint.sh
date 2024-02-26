#!/bin/bash

# Set environment variables
export HADOOP_HOME=/hadoop/
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export JAVA_HOME=/usr/local/openjdk-11

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

# Generate logs before starting Hadoop services
echo "[ENTRYPOINT] Generating logs..."
python /app/scripts/logs_generator_beagle.py
python /app/scripts/logs_generator_ssh_failed.py
echo "[ENTRYPOINT] Logs generation completed."

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
