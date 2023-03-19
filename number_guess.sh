#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

echo "Enter your username:"
read CHOSEN_USERNAME

USERNAME=$($PSQL "SELECT name FROM users where name='$CHOSEN_USERNAME'")

if [[ ! $USERNAME ]]
  then
    echo "Welcome, $CHOSEN_USERNAME! It looks like this is your first time here."
    INSERT_RESULT=$($PSQL "insert into users(name) values('$CHOSEN_USERNAME')")
  else
    USER_ID=$($PSQL "SELECT user_id FROM users where name='$CHOSEN_USERNAME'")
    BESTGAME=$($PSQL "SELECT min(number_of_guesses) FROM games where player='$USER_ID'")
    NUMBER_OF_GAMES=$($PSQL "SELECT count(*) FROM games where player='$USER_ID'")
    echo Welcome back, $USERNAME! You have played $NUMBER_OF_GAMES games, and your best game took $BESTGAME guesses.
  fi
USER_ID=$($PSQL "SELECT user_id FROM users where name='$CHOSEN_USERNAME'")

echo "Guess the secret number between 1 and 1000:"
read GUESS
SECRET_NUMBER=$((1 + $RANDOM % 1000))
NUMBER_OF_GUESSES=1
if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    if [[ $GUESS -gt $SECRET_NUMBER ]]
      then
        echo "It's lower than that, guess again:"
      elif [[ $GUESS -lt $SECRET_NUMBER ]]
      then
        echo "It's higher than that, guess again:"
      else
        echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
      fi
  fi

while [[ $SECRET_NUMBER -ne $GUESS ]]
do
  read GUESS
  ((NUMBER_OF_GUESSES++))

  if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"
    else
      if [[ $GUESS -gt $SECRET_NUMBER ]]
        then
          echo "It's lower than that, guess again:"
        elif [[ $GUESS -lt $SECRET_NUMBER ]]
        then
          echo "It's higher than that, guess again:"
        else
          echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
        fi
    fi
done

INSERT_RESULT=$($PSQL "insert into games(player, number_of_guesses) values('$USER_ID', $NUMBER_OF_GUESSES)")
