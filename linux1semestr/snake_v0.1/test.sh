#!/bin/bash

setup()
{
	screen_width=42
	score_string="You score: $score"
	padding=$((($screen_width - ${#score_string}) / 2))
	lives_string="Lives: $lives"
	padding1=$((($screen_width - ${#lives_string}) / 2))
	
	snake_x=10
	snake_y=10
	
	snake_body=( $(($snake_x + 1)),$snake_y 2,3 5,6 )
	
	fruit_x=5	
	fruit_y=5
	direction=0
	score=0
	gameover=0
	lives=3
	
	fruit_list=("🍇" "🍈" "🍉" "🍊" "🍋" "🍌" "🍍" "🥭" "🍎" "🍏" "🍐" "🍑" "🍒" "🍓" "🫐" "🥝" "🍅" "🫒" "🥑" "🍆")
	random_index=$((RANDOM % ${#fruit_list[@]}))
	random_fruit=${fruit_list[$random_index]}

	return 0
}

draw()
{
	clear
	echo ${snake_body[@]}
	
	printf "\e[1m%15sMove: A,D,W,S\n%13sExit: X Pause: C\n%11sBoost: press and hold\n\n\e[0m"
	
	for (( i=0; i<=20; i++ ))
	do
		for (( j=0; j<=20; j++ ))
		do
			if [[ $i -eq 0 || $i -eq 20 || $j -eq 0 || $j -eq 20 ]]; then
				printf '\U0001F38B'
				
			elif [[ $i == $snake_y && $j == $snake_x ]]; then
				printf '\033[42m\U0001F435\033[0m'
				
			elif [[ ${snake_body[@]} =~ (^| )$i,$j($| ) ]]; then
				printf '\033[42m\B\033[0m'

			elif [[ $i == $fruit_y && $j == $fruit_x ]]; then
				printf "\e[5m\033[42m%s\e[0m" "$random_fruit"
				
			else
				printf '\033[42m  \033[0m'
			fi
			
		done
		printf "\n"
	done
	
	printf "\e[1m\n%${padding}sYour score: \e[5m$score\e[0m\e[0m\n"
	printf "\e[1m%${padding1}sLives: $lives\n\n\e[0m"
	
	return 0
}
setup
draw

