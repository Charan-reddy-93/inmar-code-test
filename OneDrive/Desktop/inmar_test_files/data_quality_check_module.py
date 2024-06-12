import pandas as pd
import re

def clean_phone(phone):
    if pd.isnull(phone):
        return None
    
    cleaned_phone = re.sub(r'\D', '', str(phone))
    
    if len(cleaned_phone) != 10:
        return None
    return cleaned_phone

def split_phone_numbers(phone):
    if phone is None:
        return None, None
    numbers = phone.split(',')
    if len(numbers) > 1:
        return numbers[0].strip(), numbers[1].strip()
    return numbers[0].strip(), None

def data_quality_check(df):
    bad_records = []
    good_records = []

    for index, row in df.iterrows():
        issues = []
        
        if pd.isnull(row['name']) or pd.isnull(row['phone']) or pd.isnull(row['location']):
            issues.append('null')

        cleaned_phone = clean_phone(row['phone'])
        if cleaned_phone is None:
            issues.append('invalid_phone')

        address = re.sub(r'[^\w\s]', '', str(row['address']))
        reviews_list = re.sub(r'[^\w\s]', '', str(row['reviews_list']))

        cleaned_row = row.copy()
        cleaned_row['phone'] = cleaned_phone
        cleaned_row['address'] = address
        cleaned_row['reviews_list'] = reviews_list
        cleaned_row['contact_number_1'], cleaned_row['contact_number_2'] = split_phone_numbers(cleaned_phone)

        if issues:
            bad_records.append((index, issues, row.to_dict()))
        else:
            good_records.append(cleaned_row)

    return pd.DataFrame(good_records), bad_records

# Test Case
file_path = "data/data_file_20210528182554.csv" 
df = pd.read_csv(file_path)
good_data, bad_data = data_quality_check(df)

# To save output files
good_data.to_csv('cleaned_data.out', index=False)
with open('bad_data.bad', 'w') as bad_file:
    for record in bad_data:
        bad_file.write(f"Row {record[0]}: Issues {record[1]} - Data {record[2]}\n")

print("Data quality check completed.")
