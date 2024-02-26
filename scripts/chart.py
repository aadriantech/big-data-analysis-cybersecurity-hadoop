import pandas as pd
import plotly.express as px
import pydoop.hdfs as hdfs

# Specify the directory containing your MapReduce output files
output_dir = 'hdfs://localhost:9000/WordcountSsh/part-00000'

# List all the part-r-* files in the directory
files = hdfs.ls(output_dir)
part_files = [file for file in files if 'part-r-' in file]

data = []  # Initialize an empty list to store data from all files

# Iterate through each part file and append its data
for part_file in part_files:
    with hdfs.open(part_file, "rt") as f:
        for line in f:
            data.append(line.strip().split('\t'))

# Process the combined data
df = pd.DataFrame(data, columns=['Key', 'Value'])
df['Value'] = pd.to_numeric(df['Value'])

# Generate a simple bar chart using Plotly
fig = px.bar(df, x='Key', y='Value', title='MapReduce Results Visualization')

# Save the figure as an HTML file
html_file_path = '/app/runtime/mapreduce_results.html'
fig.write_html(html_file_path)

print(f"Visualization saved as HTML at {html_file_path}")
