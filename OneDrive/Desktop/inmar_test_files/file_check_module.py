import os
import pandas as pd

processed_files = set()

def is_new_file(file_name):
    return file_name not in processed_files

def is_non_empty(file_path):
    return os.path.getsize(file_path) > 0

def has_csv_extension(file_name):
    return file_name.endswith('.csv')

def file_check(file_path):
    file_name = os.path.basename(file_path)
    if not is_new_file(file_name):
        return False, "File already processed"
    if not has_csv_extension(file_name):
        return False, "Invalid file extension"
    if not is_non_empty(file_path):
        return False, "Empty file"

    processed_files.add(file_name)
    return True, "File is valid"

# Test Case
file_path = "data/data_file_20210527182730.csv"  
is_valid, message = file_check(file_path)
print(f"File check result: {message}")
