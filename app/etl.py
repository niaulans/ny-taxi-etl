import argparse
import os
import sys
from time import time
import pandas as pd
import pyarrow.parquet as pq
from sqlalchemy import create_engine

def extract(url):
    """Download file from URL and return file name"""
    
    file_name = url.rsplit('/', 1)[-1].strip()
    print(f'Downloading {file_name} ...')
    os.system(f'curl {url.strip()} -o {file_name}')
    return file_name

def transform(file_name):
    """Read data from CSV or Parquet and return an iterator of DataFrames"""
    
    if file_name.endswith('.csv'):
        df = pd.read_csv(file_name, nrows=10)
        df_iter = pd.read_csv(file_name, iterator=True, chunksize=100000)
    elif file_name.endswith('.parquet'):
        file = pq.ParquetFile(file_name)
        df = next(file.iter_batches(batch_size=10)).to_pandas()
        df_iter = file.iter_batches(batch_size=100000)
    else:
        print('Error: Only .csv or .parquet files are allowed.')
        sys.exit()
    return df, df_iter

def load(df, df_iter, engine, table_name):
    """Load transformed data into the database"""
    
    df.head(0).to_sql(name=table_name, con=engine, if_exists='replace')
    count = 0
    
    for batch in df_iter:
        count += 1
        batch_df = batch.to_pandas() if hasattr(batch, 'to_pandas') else batch
        print(f'Inserting batch {count}...')
        batch_df.to_sql(name=table_name, con=engine, if_exists='append')
        print(f'Inserted!')
    
    print(f'Completed inserting {count} batches.')

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url

    engine = create_engine(f'postgresql://{params.user}:{params.password}@{params.host}:{params.port}/{params.db}')
    file_name = extract(params.url)
    df, df_iter = transform(file_name)
    load(df, df_iter, engine, params.table_name)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='ETL process to load data into PostgreSQL.')
    parser.add_argument('--user', required=True, help='Postgres username')
    parser.add_argument('--password', required=True, help='Postgres password')
    parser.add_argument('--host', required=True, help='Postgres host')
    parser.add_argument('--port', required=True, help='Postgres port')
    parser.add_argument('--db', required=True, help='Postgres database name')
    parser.add_argument('--table_name', required=True, help='Destination table name')
    parser.add_argument('--url', required=True, help='URL of the CSV/Parquet file')
    args = parser.parse_args()
    main(args)
