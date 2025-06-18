import mysql.connector
from tabulate import tabulate
import pandas as pd
from sqlalchemy import create_engine, text




# DB connection info
engine = create_engine('mysql+mysqlconnector://vineeth:remote@192.168.194.204:3306/agrisense')

df = pd.read_csv(r"C:\Users\vinee\OneDrive\Desktop\csv\crop.csv")
df.to_sql(name='dim_crops', con=engine, if_exists='append', index=False)

df = pd.read_csv(r"C:\Users\vinee\OneDrive\Desktop\csv\Device.csv")
df.to_sql(name='dim_devices', con=engine, if_exists='append', index=False)

df = pd.read_csv(r"C:\Users\vinee\OneDrive\Desktop\csv\Farm.csv")
df.to_sql(name='dim_farms', con=engine, if_exists='append', index=False)

df = pd.read_csv(r"C:\Users\vinee\OneDrive\Desktop\csv\Logs.csv")
df.to_sql(name='fact_logs', con=engine, if_exists='append', index=False)

df = pd.read_csv(r"C:\Users\vinee\OneDrive\Desktop\csv\Sensor.csv")
df.to_sql(name='dim_sensors', con=engine, if_exists='append', index=False)


print("All data inserted successfully!")




