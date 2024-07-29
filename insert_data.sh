#! /bin/bash


if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi


# Do not change code above this line. Use the PSQL variable above to query your database.


echo "$($PSQL "truncate games, teams")"
INSERT_TEAM()
{
  TMP_TEAM=$($PSQL "select name from teams where name = '$1'");
  if [[ -z $TMP_TEAM ]]
  then
    $($PSQL "insert into teams(name) values('$1')")
  fi
}




cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    #insert teams
      WINNING_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      echo $WINNING_TEAM_ID
      if [[ -z $WINNING_TEAM_ID ]]
      then
        $($PSQL "insert into teams(name) values('$WINNER')")
        WINNING_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
        echo $WINNING_TEAM_ID
      fi
      OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
      if [[ -z $OPPONENT_TEAM_ID ]]
      then
        $($PSQL "insert into teams(name) values('$OPPONENT')")
        OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
      fi


    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, winner_goals, opponent_goals, opponent_id) VALUES($YEAR, '$ROUND', $WINNING_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS, $OPPONENT_TEAM_ID)")

  fi
done

