"""
system-pi module to handle personal information

"""
import sys
import getopt
import os
import datetime
import logging
import numpy as np
import common


API = "system-pi"
DB_NAME = "funds"
TABLE_NAME = "investor_address"
URL = "https://"

RDS_SECRET = os.environ['RDS_SECRET']
ENV = os.environ['ENV']

assert RDS_SECRET
assert ENV


SQL = f"""
INSERT INTO {TABLE_NAME}() VALUES (%s, %s, %s, %s)
ON DUPLICATE KEY UPDATE investor_address=values(investor_address), start_date=values(start_date)
"""

logging.basicConfig()
LOGGER = logging.getLogger()
LOGGER.setLevel(os.environ["LOG_LEVEL"])


def to_rds(api, db_name, table, record):
    """
    RDS processor
    Args:
        param1 (str): API name
        param2 (str): database name
        param3 (str): table name
        param4 (dict): S3 event object from Cloudwatch

    Returns:
        DataFrame: The return value of the Pandas DataFrame
        str: SQL statement (default = None)
    """
    df = common.read_csv_from_s3(record)
    df.replace([np.inf,np.nan], 0, inplace=True)
    print(df)
    common.insert_to_rds(db_name, table, RDS_SECRET, df)
    return df


def api_handler(event, context):
    """ Lambda Entrypoint """
    LOGGER.info("Invoking lambda for event:")
    LOGGER.info(event)
    # scheduled events go to dropzone
    if ('detail-type' in event and event['detail-type'] == 'Scheduled Event'):
        print('handle scheduled call')
    else:
        for record in event['Records']:
            bucket = record['s3']['bucket']['name'].lower()
            if "sftp" in bucket:
                to_rds(API, DB_NAME, TABLE_NAME, record)


def api_request(monitor, date_for, end_date):
    """
    Gets latest sftp data
    """
    LOGGER.info(f"Requesting SFTP data for date_for: {date_for}, end_date: {end_date}")
    return True


def main(argv):
    """ Main method """
    date_for = ''
    end_date = ''
    try:
        opts, args = getopt.getopt(argv, "hm:d:e:", ["monitor=", "date-for=", "end-date="])
    except getopt.GetoptError:
        print('system_pi.py -d <date: 2020-01-01> -e <end date: 2021-01-01>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('system_pi.py -d <date: 2020-01-01> -e <end date>')
            sys.exit()
        elif opt in ("-d", "--date-for"):
            date_for = datetime.datetime.strptime(arg, '%Y-%m-%d')
        elif opt in ("-e", "--end-date"):
            end_date = datetime.datetime.strptime(arg, '%Y-%m-%d')

    if not end_date:
        end_date = date_for



if __name__ == "__main__":
    main(sys.argv[1:])
