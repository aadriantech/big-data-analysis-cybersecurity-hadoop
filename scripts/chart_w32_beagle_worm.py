import sys
import pandas as pd
import plotly.express as px
import pydoop.hdfs as hdfs

# Check if an argument is provided for the output directory path
if len(sys.argv) < 2:
    print("Usage: script.py <output_directory_path>")
    sys.exit(1)

# Ensure the output directory path ends with a '/'
output_dir = 'hdfs://localhost:9000/' + sys.argv[1].strip('/')
if not output_dir.endswith('/'):
    output_dir += '/'
print(f"Output directory: {output_dir}")

# Attempt to list all files in the directory
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
            data.append(line.strip().split('\t'))

# Convert the collected data into a DataFrame
df = pd.DataFrame(data, columns=['IP Address', 'Page', 'Count'])
df['Count'] = pd.to_numeric(df['Count'])

# Generate a bar chart using Plotly
fig = px.bar(df, x='IP Address', y='Count', color='Page', barmode='group', title='Web Page Access Counts per IP Address')

# Save the figure as an HTML file
html_file_path = '/app/runtime/w32_beagle_worm_chart.html'
fig.write_html(html_file_path)

print(f"Visualization saved as HTML at {html_file_path}")
