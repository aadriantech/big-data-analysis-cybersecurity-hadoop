#!/usr/bin/env python3
import sys
import pydoop.hdfs as hdfs
import os

def prepare_hdfs_environment(hdfs_dir_path, local_file_path):
    # Create HDFS directory if it doesn't exist
    if not hdfs.path.exists(hdfs_dir_path):
        hdfs.mkdir(hdfs_dir_path)
        print(f"Created HDFS directory {hdfs_dir_path}")
    else:
        print(f"HDFS directory {hdfs_dir_path} already exists")

    # Define HDFS file path
    hdfs_file_path = os.path.join(hdfs_dir_path, os.path.basename(local_file_path))

    # Upload the file to HDFS
    if not hdfs.path.exists(hdfs_file_path):
        hdfs.put(local_file_path, hdfs_file_path)
        print(f"File {local_file_path} uploaded to HDFS at {hdfs_file_path}")
    else:
        print(f"File {local_file_path} already exists in HDFS at {hdfs_file_path}")

def main():
    if len(sys.argv) != 2:
        print("Usage: script.py <local_file_path>")
        sys.exit(1)

    local_file_path = sys.argv[1]
    hdfs_dir_path = "/logs"
    prepare_hdfs_environment(hdfs_dir_path, local_file_path)

if __name__ == "__main__":
    main()
