#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "INSERT INTO teams (name) VALUES 
('Brazil'),
('Germany'),
('Argentina'),
('France'),
('Italy'),
('Spain'),
('Netherlands'),
('Portugal'),
('England'),
('Belgium'),
('Croatia'),
('Uruguay'),
('Colombia'),
('Mexico'),
('Chile'),
('Sweden'),
('Denmark'),
('Russia'),
('Poland'),
('Japan'),
('South Korea'),
('Senegal'),
('Tunisia'),
('Iran');"