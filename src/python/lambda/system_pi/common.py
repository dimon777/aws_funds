"""
Module which handles generic functions across all APIs
- Insert data to RDS
- Puts custom Cloudwatch metric
"""
import logging
import json
import sys
import os
import base64
from urllib.parse import unquote
from io import StringIO
import io
import pandas as pd
import boto3
import mysql.connector


RDS_SECRET = os.environ['RDS_SECRET']

logging.basicConfig(level=os.environ["LOG_LEVEL"])
LOGGER = logging.getLogger(__name__)


def gen_sql(rds_df, t_name):
    r_cols = rds_df.columns
    # TODO: function which takes DF, table, constructs dynamic fields for
    # insert and does db insert
    cols = ",".join(["\n" + c for c in r_cols])
    vals = ",".join(['%s' for i in range(len(r_cols))])
    dups = ",".join(["\n" + c + "=values(" + c + ")" for c in r_cols])
    sql = """
        INSERT INTO {} ({})
            VALUES ({})
            ON DUPLICATE KEY UPDATE {}""".format(t_name, cols, vals, dups)
    return sql


def read_csv_from_s3(record, seperator=",", dtype=None):
    s3c = boto3.client('s3')
    bucket = record['s3']['bucket']['name']
    key = unquote(record['s3']['object']['key'])
    print('DIAG: reading', bucket, key)
    result = s3c.get_object(Bucket=bucket, Key=key)
    df = pd.read_csv(
        io.BytesIO(
            result['Body'].read()),
        encoding='utf8',
        sep=seperator, dtype=dtype)
    return df




def insert_to_rds(database, table, rds_secret, df, sql=None):
    """
    Inserts data to RDS
    data - [][]
    """
    if sql is None:
        sql = gen_sql(df, table)

    #print("SQL:", sql)
    data = df.values.tolist()
    host, port, user, pwd = get_rds_secret(rds_secret)
    try:
        conn = mysql.connector.connect(host=host,
                                       port=port,
                                       user=user,
                                       password=pwd,
                                       database=database)
    except Exception as ex:
        LOGGER.error(
            "Can not connect to RDS, aborting pipeline: %s Error: %s",
            host,
            ex,
            exc_info=True)
        raise ex

    rows_committed = 0
    chunk_size = 1000  # TODO: better to expose via env var
    try:
        cur = conn.cursor()
        i = 0
        rows = len(data)
        while i < rows:
            chunk = data[i:i + chunk_size]
            i += chunk_size
            cur.executemany(sql, chunk)  # data
            conn.commit()
            rows_committed += cur.rowcount
            print("committed chunk of rows:", cur.rowcount)
        LOGGER.info("Committed {} rows to RDS".format(rows_committed))
    except Exception as ex:
        LOGGER.error("when inserting data to RDS", exc_info=True)
        raise ex
    finally:
        cur.close()
        conn.close()

    return rows_committed




def get_rds_secret(rds_secret):
    """
    See https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
    """
    LOGGER.info(f"get_secret() for RDS_SECRET: {rds_secret}")
    if os.environ.get('LOCAL'):
        return 'localhost', 3306, os.environ['MYSQL_USER'], os.environ['MYSQL_ROOT_PASSWORD']
    secretmgr = boto3.client('secretsmanager')
    secret_val = secretmgr.get_secret_value(SecretId=rds_secret)
    secret = secret_val['SecretString'] if 'SecretString' in secret_val else base64.b64decode(
        secret_val['SecretBinary'])
    j = json.loads(secret)
    user = j['username']
    pwd = j['password']
    host = j['host']
    port = j['port']
    return host, port, user, pwd


def main(argv):
    """ Main method """
    LOGGER.info("No main() calls")


if __name__ == "__main__":
    main(sys.argv[1:])
