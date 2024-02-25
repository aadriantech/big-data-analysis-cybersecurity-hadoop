import subprocess
import pandas as pd
import plotly.express as px
import pydoop.hdfs as hdfs

# Step 1: Define and execute the Hadoop streaming command
# Note: Adjust the paths and filenames as necessary
hadoop_command = [
    "hadoop", "jar", "/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar",
    "-files", "hdfs://localhost:9000/path/to/mapper.py,hdfs://localhost:9000/path/to/reducer.py",
    "-mapper", "python mapper.py",
    "-reducer", "python reducer.py",
    "-input", "hdfs://localhost:9000/path/to/input",
    "-output", "hdfs://localhost:9000/path/to/output"
]

subprocess.run(hadoop_command, check=True)

# Step 2: Read the Hadoop job output from HDFS
output_path = 'hdfs://localhost:9000/path/to/output/part-r-00000'

with hdfs.open(output_path, "rt") as f:
    data = f.readlines()

# Step 3: Process the data
processed_data = [line.strip().split('\t') for line in data]
df = pd.DataFrame(processed_data, columns=['Key', 'Value'])

# Convert 'Value' column to numeric
df['Value'] = pd.to_numeric(df['Value'])

# Step 4: Generate a simple bar chart using Plotly
fig = px.bar(df, x='Key', y='Value', title='MapReduce Results Visualization')

# Step 5: Save the figure as an HTML file
# Adjust the file path as necessary
fig.write_html("mapreduce_results.html")
