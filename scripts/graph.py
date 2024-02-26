import pandas as pd
import plotly.express as px
import pydoop.hdfs as hdfs

# Specify the path to your MapReduce output file in HDFS
hdfs_path = 'hdfs://localhost:8020/path/to/mapreduce/output/part-r-00000'

# Read the MapReduce output file from HDFS
with hdfs.open(hdfs_path, "rt") as f:
    data = f.readlines()

# Process the data
# Assuming the MapReduce output is in the form of "key\tvalue\n"
processed_data = [line.strip().split('\t') for line in data]
df = pd.DataFrame(processed_data, columns=['Key', 'Value'])

# Convert values to numeric type for visualization
df['Value'] = pd.to_numeric(df['Value'])

# Generate a simple bar chart using Plotly
fig = px.bar(df, x='Key', y='Value', title='MapReduce Results Visualization')
fig.show()
