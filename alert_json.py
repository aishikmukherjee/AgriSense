import json
from datetime import datetime
from connection_resources import connection_dbms, disconnect_dbms


def handle_weather_alert(alert_json_file, cursor):
    """This function Handles semi-structured weather alert JSON data and alerts when there is a concern"""
    try:
        # extracting the data from the json file
        region = alert_json_file.get("region") or alert_json_file.get("location", {}).get("state", "Unknown")
        alert_type = alert_json_file.get("alert_type") or alert_json_file.get("type", "Unknown")
        severity = alert_json_file.get("severity") or alert_json_file.get("level", "Unknown")
        alert_time = (alert_json_file.get("alert_time") or alert_json_file.get("issued_at") or
                      datetime.now().strftime("%Y-%m-%d %H:%M:%S"))

        # Checks for weather severity concerns and alerts
        if severity.lower() in ["high", "critical", "severe"]:
            print(f"🚨 WARNING: {alert_type} in {region} — Severity: {severity}\n")

        # Stores the data into weather_alerts table for analytical purposes
        cursor.execute("""
            INSERT INTO weather_alerts (region, alert_type, severity, alert_time)
            VALUES (%s, %s, %s, %s)
        """, (region, alert_type, severity, alert_time))

        mydb.commit()
        print(f"\n✅ Stored alert: {alert_type} in {region} ({severity})")

    except Exception as er:
        print(f"❌ Error while handling alert:{er.args[1]}")

if __name__ == "__main__":
    try:
        # ✅ Use your custom connection function
        mydb = connection_dbms()
        cursor_main = mydb.cursor()

        # calling the function to deal with JSON file for weather alerts
        print("⚠️⚠️⚠️ Message: THE WEATHER ALERT SYSTEM IS INITIATED")
        with open('alert_data_input.json') as jsonfile:
            data = json.load(jsonfile)

            if isinstance(data, list):
                for alert in data:
                    handle_weather_alert(alert, cursor_main)
            else:
                handle_weather_alert(data,  cursor_main)

        # closing the connection with dbms object "mydb"
        cursor_main.close()
        disconnect_dbms(mydb)
    except Exception as er_main:
        print(f"❌ Failed to read alert.json: {er_main.args[1]}")