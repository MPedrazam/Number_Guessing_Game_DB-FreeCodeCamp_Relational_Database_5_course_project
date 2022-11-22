#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess -t --no-align -c"

RANDOM_NUMBER=$[ 1 + $RANDOM % 1000 ] # randomly generate a number between 1 and 1000
#echo $RANDOM_NUMBER

echo -e "Enter your username: " 
read USER_NAME

NAME=$($PSQL "SELECT * FROM number_guess WHERE user_name = '$USER_NAME'")
GAMES_PLAYED=$($PSQL "SELECT COUNT (user_name) FROM number_guess WHERE user_name = '$USER_NAME'") # getting the times a user with a same name had payed
BEST_GAME=$($PSQL "SELECT MIN(guessing_attempts) FROM number_guess WHERE user_name = '$USER_NAME'") # selecting the min number of attempts


if [[ -z $NAME ]]
then
  INSERT_USER=$($PSQL "INSERT INTO number_guess(user_name) VALUES ('$USER_NAME')")
  GUESS_ID=$($PSQL " SELECT MAX(guess_id) FROM number_guess WHERE user_name='$USER_NAME'") #getting the guess_id for the user that is paying
  echo "Welcome, $USER_NAME! It looks like this is your first time here."

else
  INSERT_USER=$($PSQL "INSERT INTO number_guess(user_name) VALUES ('$USER_NAME')")
  GUESS_ID=$($PSQL " SELECT MAX(guess_id) FROM number_guess WHERE user_name='$USER_NAME'")
  echo "Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi


echo "Guess the secret number between 1 and 1000: "
read CHOICEN_NUMBER
ATTEMPTS=0 


MAIN() {

if [[ ! $CHOICEN_NUMBER =~ (^[+-]?[0-9]+$) ]] # testing if the imput is not a integer
then 
  echo "That is not an integer, guess again: "
  read CHOICEN_NUMBER
fi


if [[ $CHOICEN_NUMBER == $RANDOM_NUMBER ]]
then
  ATTEMPTS=$(( $ATTEMPTS + 1)) # adding the attempts to guess the number
  echo "You guessed it in $ATTEMPTS tries. The secret number was $RANDOM_NUMBER. Nice job!"
  INSERT_ATTEMPTS=$($PSQL "UPDATE number_guess SET guessing_attempts = $ATTEMPTS WHERE guess_id = $GUESS_ID")
  exit

else

  if [[ $CHOICEN_NUMBER > $RANDOM_NUMBER ]] 
  then
    ATTEMPTS=$(( $ATTEMPTS + 1))
    echo "It's lower than that, guess again: "
    read CHOICEN_NUMBER
    MAIN # retuns to the initial loop

  elif [[ $CHOICEN_NUMBER < $RANDOM_NUMBER ]]
  then
    ATTEMPTS=$(( $ATTEMPTS + 1))
  	echo "It's higher than that, guess again: "
    read CHOICEN_NUMBER
    MAIN
  fi
fi

}

MAIN
