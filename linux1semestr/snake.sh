#!/bin/bash

# Set up the game board
declare -A board
for ((i=1; i<=20; i++))
do
	for ((j=1; j<=20; j++))
	do
		board[$i,$j]=" "
	done
done

# Place the initial snake head at a random location
snake_row=$((RANDOM % 20 + 1))
snake_col=$((RANDOM % 20 + 1))
board[$snake_row,$snake_col]="@"

# Set up the initial game state
snake_length=1
snake_direction="right"
score=0

# Game loop
while true
	do
  # Handle user input
		read -s -n 1 key
		case "$key" in
			"w") snake_direction="up";;
			"a") snake_direction="left";;
			"s") snake_direction="down";;
			"d") snake_direction="right";;
			"q") exit;;
		esac

  # Update the snake's position
		case "$snake_direction" in
			"up") snake_row=$((snake_row - 1));;
			"down") snake_row=$((snake_row + 1));;
			"left") snake_col=$((snake_col - 1));;
			"right") snake_col=$((snake_col + 1));;
		esac
		board[$snake_row,$snake_col]="@"
		snake_length=$((snake_length + 1))

  # Detect collisions with the game board edges or the snake's own body
		if ((snake_row < 1 || snake_row > 20 || snake_col < 1 || snake_col > 20))
		then
			echo "Game over! Your score is $score."
			break
		elif [[ "${board[$snake_row,$snake_col]}" = "@" ]]
		then
			echo "Game over! Your score is $score."
			break
		fi

  # Update the score
		score=$((score + 10))

  # Redraw the game board
		clear
		for ((i=1; i<=20; i++))
		do
			for ((j=1; j<=20; j++))
			do
				echo -n "${board[$i,$j]}"
			done
			echo ""
		done

  # Sleep for a short amount of time to slow down the game
	sleep 0.2
done
