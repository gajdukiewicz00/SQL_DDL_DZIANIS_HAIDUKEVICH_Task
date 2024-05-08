-- Create the database
CREATE DATABASE mountaineering_db;

-- Connect to the newly created database
\c mountaineering_db;

-- Create schema
CREATE SCHEMA mountaineering_schema;

-- Set search_path to use the newly created schema
SET search_path TO mountaineering_schema;

-- Create tables based on the 3NF model
CREATE TABLE Country (
  country_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE Area (
  area_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  country_id INTEGER NOT NULL,
  FOREIGN KEY (country_id) REFERENCES Country(country_id)
);

CREATE TABLE Mountain (
  mountain_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  height INTEGER,
  country_id INTEGER NOT NULL,
  FOREIGN KEY (country_id) REFERENCES Country(country_id)
);

CREATE TABLE Climber (
  climber_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255)
);

CREATE TABLE Expedition (
  expedition_id SERIAL PRIMARY KEY,
  mountain_id INTEGER NOT NULL,
  start_date DATE NOT NULL CHECK (start_date > DATE '2000-01-01'),
  end_date DATE NOT NULL CHECK (end_date > start_date),
  FOREIGN KEY (mountain_id) REFERENCES Mountain(mountain_id)
);

CREATE TABLE Expedition_Climber (
  expedition_id INTEGER NOT NULL,
  climber_id INTEGER NOT NULL,
  PRIMARY KEY (expedition_id, climber_id),
  FOREIGN KEY (expedition_id) REFERENCES Expedition(expedition_id),
  FOREIGN KEY (climber_id) REFERENCES Climber(climber_id)
);

CREATE TABLE Route (
  route_id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  difficulty VARCHAR(255)
);

CREATE TABLE Expedition_Route (
  expedition_id INTEGER NOT NULL,
  route_id INTEGER NOT NULL,
  PRIMARY KEY (expedition_id, route_id),
  FOREIGN KEY (expedition_id) REFERENCES Expedition(expedition_id),
  FOREIGN KEY (route_id) REFERENCES Route(route_id)
);

CREATE TABLE Equipment (
  equipment_id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE Expedition_Equipment (
  expedition_id INTEGER NOT NULL,
  equipment_id INTEGER NOT NULL,
  PRIMARY KEY (expedition_id, equipment_id),
  FOREIGN KEY (expedition_id) REFERENCES Expedition(expedition_id),
  FOREIGN KEY (equipment_id) REFERENCES Equipment(equipment_id)
);

-- Add 'record_ts' field to each table
ALTER TABLE Country ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_DATE;
ALTER TABLE Area ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_DATE;
ALTER TABLE Mountain ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_DATE;
ALTER TABLE Climber ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_DATE;
ALTER TABLE Expedition ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_DATE;
ALTER TABLE Expedition_Climber ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_DATE;
ALTER TABLE Route ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_DATE;
ALTER TABLE Expedition_Route ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_DATE;
ALTER TABLE Equipment ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_DATE;
ALTER TABLE Expedition_Equipment ADD COLUMN record_ts TIMESTAMP DEFAULT CURRENT_DATE;

-- Populate tables with sample data
INSERT INTO Country (name) VALUES ('Nepal'), ('USA');
INSERT INTO Area (name, country_id) VALUES ('Himalayas', 1), ('Rockies', 2);
INSERT INTO Mountain (name, height, country_id) VALUES ('Mount Everest', 8848, 1), ('Denali', 6190, 2);
INSERT INTO Climber (name, address) VALUES ('John Doe', '123 Main St'), ('Jane Smith', '456 Oak Ave');
INSERT INTO Expedition (mountain_id, start_date, end_date) VALUES (1, '2024-04-01', '2024-05-01'), (2, '2024-06-01', '2024-07-01');
INSERT INTO Expedition_Climber (expedition_id, climber_id) VALUES (1, 1), (2, 2);
INSERT INTO Route (name, difficulty) VALUES ('Standard Route', 'Hard'), ('West Buttress', 'Difficult');
INSERT INTO Expedition_Route (expedition_id, route_id) VALUES (1, 1), (2, 2);
INSERT INTO Equipment (name) VALUES ('Crampons'), ('Ice Axe');
INSERT INTO Expedition_Equipment (expedition_id, equipment_id) VALUES (1, 1), (2, 2);