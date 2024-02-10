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


# su hadoop
# hdfs dfs -mkdir -p /var/log && hdfs dfs -put /var/log/alternatives.log /var/log/alternatives.log

# hadoop jar /hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \-file "/app/scripts/mapper.py" -mapper "python3 /app/scripts/mapper.py" \-file "/app/scripts/reducer.py" -reducer "python3 /app/scripts/reducer.py" \-input /var/log/alternatives.log -output /hadoop-output/Wordcount
# hadoop jar /hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \-files "/app/scripts/mapper.py","/app/scripts/reducer.py" -mapper "python3 /app/scripts/mapper.py" -reducer "python3 /app/scripts/reducer.py" \-input /var/log/alternatives.log -output /hadoop-output/Wordcount
# hadoop jar /hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \-files "/app/scripts/mapper.py","/app/scripts/reducer.py" -mapper "/usr/local/openjdk-11/bin/java mapper.py" -reducer "/usr/local/openjdk-11/bin/java reducer.py" \-input /var/log/alternatives.log -output /hadoop-output/Wordcount
# hadoop jar /hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar -files "/app/scripts/mapper.py,/app/scripts/reducer.py" -mapper "python mapper.py" -reducer "python reducer.py" -input "hdfs://localhost:9000/var/log/alternatives.log" -output "/hadoop-output/Wordcount"
