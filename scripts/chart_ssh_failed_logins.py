import sys
import pandas as pd
import plotly.express as px
import pydoop.hdfs as hdfs

# Check if an argument is provided
if len(sys.argv) < 2:
    print("Usage: script.py <output_directory_path>")
    sys.exit(1)

# Ensure the output directory path ends with a '/'
output_dir = 'hdfs://localhost:9000/' + sys.argv[1].strip('/')
if not output_dir.endswith('/'):
    output_dir += '/'
print(f"Output directory: {output_dir}")

# List all files in the directory
try:
    files = hdfs.ls(output_dir)
except Exception as e:
    print(f"Error listing files in {output_dir}: {e}")
    sys.exit(1)

# Filter for part files
part_files = [file for file in files if 'part-' in file]
print(f"Part files: {part_files}")

if not part_files:
    print("No part files found.")
    sys.exit(1)

data = []

# Iterate through each part file and append its data
for part_file in part_files:
    with hdfs.open(part_file, "rt") as f:
        while True:
            line = f.readline()
            if not line:
                break
            data.append(line.strip())

# Assuming the MapReduce output is in the form of "IP Address\tLog Type\tCount"
processed_data = [line.split('\t') for line in data]
df = pd.DataFrame(processed_data, columns=['IP Address', 'Log Type', 'Count'])
df['Count'] = pd.to_numeric(df['Count'])

# Generate and save the visualization
fig = px.bar(df, x='IP Address', y='Count', color='Log Type', title='MapReduce Results Visualization')
html_file_path = '/app/runtime/ssh_failed_chart.html'
fig.write_html(html_file_path)

print(f"Visualization saved as HTML at {html_file_path}")
