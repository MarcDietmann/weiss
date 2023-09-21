from influxdb_client import InfluxDBClient, Point
from influxdb_client.client.write_api import SYNCHRONOUS
import csv


weiss_token = "GBrTQl7C-3RDzIkG_7wNM4hwLPhgweF9CBso-4x6fuvuc1m8I8VxKvwfYckeQqLECm-_BcUAbVjaIZfVAe0pqg=="
weiss_org = "Weiss-GmbH"

client = InfluxDBClient(url="10.1.70.4:8086", token=weiss_token, org=weiss_org)

write_api = client.write_api(write_options=SYNCHRONOUS)
query_api = client.query_api()

# # using Table structure
# tables = query_api.query('from(bucket:"sensor_raw") |> range(start: -5m)')
# # # csv_result = query_api.query_csv('from(bucket:"plc_dS") |> range(start: -60m)')

# for table in tables:
#     print(table)
#     for row in table.records:
#         print (row.values)

# For plc
# print("Start writing to csv file")
# with open('plc_dS_7d.csv', mode='w', newline='') as csv_file:
#     fieldnames = ['_start', '_stop', '_time', '_value', 'Device',
#                   '_field', '_measurement', 'article_no', 'serial_no']
#     writer = csv.DictWriter(csv_file, fieldnames=fieldnames)

#     # Write the header row
#     writer.writeheader()

#     # Write data to the CSV file
#     for table in tables:
#         for row in table.records:
#             writer.writerow({
#                 '_start': row['_start'],
#                 '_stop': row['_stop'],
#                 '_time': row['_time'],
#                 '_value': row['_value'],
#                 'Device': row['Device'],
#                 '_field': row['_field'],
#                 '_measurement': row['_measurement'],
#                 'article_no': row['article_no'],
#                 'serial_no': row['serial_no']
#             })


tables = query_api.query('from(bucket:"sensor_raw") |> range(start: -2h)')

# for table in tables:
#     print(table)
#     for row in table.records:
#         print (row.values)

with open("sensor_raw_2h_temp.csv", mode='w', newline='') as csv_file:
    fieldnames = ['result', 'table', '_start', '_stop', '_time', '_value', 'Device Type', 'Key Values',
                  'Manufacturer', '_field', '_measurement', 'article_no', 'measuring_time', 'rotation',
                  'sensor', 'serial_no']

    writer = csv.DictWriter(csv_file, fieldnames=fieldnames)

    # Write the header row
    writer.writeheader()

    # Iterate through the data in 'tables' and write each row to the CSV file
    for table in tables:
        for row in table.records:

            # Initialize placeholders for 'Key Values' and 'sensor'
            key_values = 'NaN'
            sensor = 'NaN'
            device_type = 'NaN'
            manufacturer = 'NaN'
            measuring_time = None


            # Check if 'Key Values' and 'sensor' exist in the row
            try:
                key_values = row['Key Values']
                sensor = row['sensor']
                device_type = row['Device Type']
                manufacturer = row['Manufacturer']
                measuring_time = row['measuring_time']
            except:
                pass

            writer.writerow({
                'result': row['result'],
                'table': row['table'],
                '_start': row['_start'],
                '_stop': row['_stop'],
                '_time': row['_time'],
                '_value': row['_value'],
                'Device Type': device_type,
                'Key Values': key_values,
                'Manufacturer': manufacturer,
                '_field': row['_field'],
                '_measurement': row['_measurement'],
                'measuring_time': measuring_time,
                'rotation': row['rotation'],
                'sensor': sensor,
                'serial_no': row['serial_no']
            })
