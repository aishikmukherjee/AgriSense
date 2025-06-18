-- 																DATABASE CREATION QUERY
CREATE DATABASE agrisense;


-- 																TABLE GENERATING QUERIES

# dim_farms
CREATE TABLE dim_farms(
	farm_id INT PRIMARY KEY AUTO_INCREMENT,
    farm_name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    owner_name VARCHAR(100),
    area_size DECIMAL(6,2) 
);


# dim_crops
CREATE TABLE dim_crops (
    crop_id INT PRIMARY KEY,
    name VARCHAR(50),
    type VARCHAR(50),
    planting_date DATE,
    harvest_date DATE,
    growth_duration INT,
    optimal_temperature DECIMAL(4,1),
    optimal_humidity DECIMAL(4,1),
    farm_id INT,
    CONSTRAINT fk_farm_id FOREIGN KEY (farm_id) REFERENCES dim_farms(farm_id)
    ON DELETE CASCADE
);

# dim_devices
CREATE TABLE dim_devices (
    device_id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    device_type ENUM('SensorBox', 'WeatherStation') NOT NULL,
    installation_date DATE,
    status ENUM('Active', 'Inactive', 'Faulty') NOT NULL,
    device_location VARCHAR(255),
    FOREIGN KEY (farm_id) REFERENCES dim_farms(farm_id) 
    ON DELETE CASCADE
);

# dim_sensors
CREATE TABLE dim_sensors (
	sensor_id INTEGER primary key NOT NULL, 
    device_id INTEGER NOT NULL, 
    sensor_type ENUM ('Temperature', 'Humidity', 'SoilMoisture','CropHealth') NOT NULL , 
    unit VARCHAR(20), 
    calibration_date DATE,
    weather ENUM ('Sunny', 'Cloudy', 'Rainy','Snowy', 'Windy') NOT NULL , 
    FOREIGN KEY (device_id) REFERENCES dim_devices(device_id) 
    ON DELETE CASCADE
);

# fact_logs
CREATE TABLE fact_logs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    timestamp DATETIME NOT NULL,
    value DECIMAL(10,4) NOT NULL,
    data_quality ENUM('Good', 'Suspect', 'Missing') NOT NULL,
    FOREIGN KEY (sensor_id) REFERENCES dim_sensors(sensor_id) 
    ON DELETE CASCADE
);

# dim_weather_alerts
CREATE TABLE dim_weather_alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    region VARCHAR(100),
    alert_type VARCHAR(100),
    severity VARCHAR(50),
    alert_time DATETIME
);



-- 																		Appendix

# see all the tables in the database
SHOW TABLES IN agrisense;

# show table queries
SELECT * FROM dim_crops;
SELECT * FROM dim_farms;
SELECT * FROM dim_devices;
SELECT * FROM dim_sensors;
SELECT * FROM fact_logs;
SELECT * FROM dim_crops;

# use this Transaction to reset the database
START TRANSACTION;

-- Drop child tables first to avoid foreign key constraint errors
DROP TABLE IF EXISTS fact_logs;
DROP TABLE IF EXISTS dim_sensors;
DROP TABLE IF EXISTS dim_devices;
DROP TABLE IF EXISTS dim_crops;
DROP TABLE IF EXISTS dim_farms;

CREATE TABLE dim_farms(
	farm_id INT PRIMARY KEY AUTO_INCREMENT,
    farm_name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    owner_name VARCHAR(100),
    area_size DECIMAL(6,2) 
);

# dim_crops
CREATE TABLE dim_crops (
    crop_id INT PRIMARY KEY,
    name VARCHAR(50),
    type VARCHAR(50),
    planting_date DATE,
    harvest_date DATE,
    growth_duration INT,
    optimal_temperature DECIMAL(4,1),
    optimal_humidity DECIMAL(4,1),
    farm_id INT,
    CONSTRAINT fk_farm_id FOREIGN KEY (farm_id) REFERENCES dim_farms(farm_id)
    ON DELETE CASCADE
);

# dim_devices
CREATE TABLE dim_devices (
    device_id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    device_type ENUM('SensorBox', 'WeatherStation') NOT NULL,
    installation_date DATE,
    status ENUM('Active', 'Inactive', 'Faulty') NOT NULL,
    device_location VARCHAR(255),
    FOREIGN KEY (farm_id) REFERENCES dim_farms(farm_id) 
    ON DELETE CASCADE
);

# dim_sensors
CREATE TABLE dim_sensors (
	sensor_id INTEGER primary key NOT NULL, 
    device_id INTEGER NOT NULL, 
    sensor_type ENUM ('Temperature', 'Humidity', 'SoilMoisture','CropHealth') NOT NULL , 
    unit VARCHAR(20), 
    calibration_date DATE,
    weather ENUM ('Sunny', 'Cloudy', 'Rainy','Snowy', 'Windy') NOT NULL , 
    FOREIGN KEY (device_id) REFERENCES dim_devices(device_id) 
    ON DELETE CASCADE
);

# fact_logs
CREATE TABLE fact_logs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    timestamp DATETIME NOT NULL,
    value DECIMAL(10,4) NOT NULL,
    data_quality ENUM('Good', 'Suspect', 'Missing') NOT NULL,
    FOREIGN KEY (sensor_id) REFERENCES dim_sensors(sensor_id) 
    ON DELETE CASCADE
);

# dim_weather_alerts
CREATE TABLE dim_weather_alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    region VARCHAR(100),
    alert_type VARCHAR(100),
    severity VARCHAR(50),
    alert_time DATETIME
);

COMMIT;

