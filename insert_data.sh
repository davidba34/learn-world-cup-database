#! /bin/bash

# using if loop to be able to run tests without affecting original database

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Truncate both games and teams tables
echo $($PSQL "TRUNCATE TABLE games, teams;")

# Read each line from games.csv
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Insert WINNER team into the teams table if not already present
  if [[ $WINNER != "winner" ]] && [[ -n $WINNER ]]  # Avoid the column header
  then
    TEAM1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    if [[ -z $TEAM1 ]]  # If team is not found in the table
    then
      INSERT_TEAM1=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM1 == "INSERT 0 1" ]]
      then
        echo "Inserted team: $WINNER"
      fi
    fi
  fi

  # Insert OPPONENT team into the teams table if not already present
  if [[ $OPPONENT != "opponent" ]] && [[ -n $OPPONENT ]]  # Avoid the column header
  then
    TEAM2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    if [[ -z $TEAM2 ]]  # If opponent is not found in the table
    then
      INSERT_TEAM2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM2 == "INSERT 0 1" ]]
      then
        echo "Inserted team: $OPPONENT"
      fi
    fi
  fi

  # Insert game data if it's not the header row
  if [[ $YEAR != "year" ]]  # Skip the header row
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
    # Insert the game into the games table
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
                         VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo "New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score: $WINNER_GOALS : $OPPONENT_GOALS"
    fi
  fi

done
