#!/bin/bash

setup() #initial parameters
{	
	#snake setup
	snake_x=10
	snake_y=10
	snake_body=(10,11 10,12)
	
	#fruit setup
	fruit_x=$((RANDOM % 20))
	fruit_y=$((RANDOM % 20))
	
	while [ $fruit_x -eq 0 ]; do
		fruit_x=$((RANDOM % 20))
	done
	while [ $fruit_y -eq 0 ]; do
		fruit_y=$((RANDOM % 20))
	done
	
	#game setup
	direction=0
	score=0
	gameover=0
	lives=3
	speed=0.35
	
	#setup for a padding
	screen_width=42
	score_string="You score: $score"
	padding=$((($screen_width - ${#score_string}) / 2))
	lives_string="Lives: $lives"
	padding1=$((($screen_width - ${#lives_string}) / 2))
	
	#max player score
	read -r maxscore < maxscore.txt 
	maxscore_string="Max score: $maxscore"
	padding2=$((($screen_width - ${#maxscore_string}) / 2))
	
	#generate random fruit
	fruit_list=("🍇" "🍈" "🍉" "🍊" "🍋" "🍌" "🍍" "🥭" "🍎" "🍐" "🍑" "🍒" "🍓" "🫐" "🥝")
	random_index=$((RANDOM % ${#fruit_list[@]}))
	random_fruit=${fruit_list[$random_index]}
	
	#list for a random borders
	tree_list=("🌲" "🌳" "🌴" "🌵" "🌱")
	
	back=42
	return 0
}


draw() #function to display image
{
	clear
	
	#control info
	printf "\e[1m%15sMove: A,D,W,S\n%13sExit: X Pause: C\n\e[0m"
	printf "\e[1m%11sBoost: press and hold\n\n\e[0m"
	
	for (( i=0; i<=20; i++ ))
	do
		for (( j=0; j<=20; j++ ))
		do
			#print borders
			if [[ $i -eq 0 || $i -eq 20 || $j -eq 0 || $j -eq 20 ]]; then
				random_tree_index=$((RANDOM % ${#tree_list[@]}))
				random_tree=${tree_list[$random_tree_index]}
				printf "$random_tree"
			
			#print snake head
			elif [[ $i == $snake_y && $j == $snake_x ]]; then 
				printf '\033[%dm\U0001F438\033[0m' "$back"
			
			#print snake body
			elif [[ ${snake_body[@]} =~ (^| )$i,$j($| ) ]]; then
				printf '\033[%dm\U0001F7E2\033[0m' "$back"
			
			#print fruit
			elif [[ $i == $fruit_y && $j == $fruit_x ]]; then 
				printf "\e[5m\033[%dm%s\e[0m" "$back" "$random_fruit"
				
			#print empty fields	
			else 
				printf '\033[%dm  \033[0m' "$back"
				
			fi
		done
		printf "\n"
	done
	
	#score
	printf "\e[1m\n%${padding}sYour score: \e[5m$score\e[0m\e[0m\n" 
	#maxscore
	printf "\e[1m%${padding2}s$maxscore_string\e[0m\e[0m\n"
	#lives
	printf "\e[1m%${padding1}sLives: $lives\n\n\e[0m"
	
	return 0
}


input() #function to read pressed key
{	 
	read -t $speed -n 1 key #-t (reading time) -n 1 (read 1 char)
	
	if [ $key ]; then
		case $key in
			A | a) 
			if [ $direction = "right" ]; then
				continue
			else
				direction='left'
			fi
			;;
			
			D | d) 
			if [ $direction = "left" ]; then
				continue
			else
				direction='right'
			fi
			;;
			
			W | w) 
			if [ $direction = "down" ]; then
				continue
			else			
				direction='up'
			fi
			;;
			
			S | s)
			if [ $direction = "up" ]; then
				continue
			else
				direction='down'
			fi
			;;
			
			C | c) direction=0;;
			
			X | x) gameover=1;;
			
			*) continue
		esac
	fi
	
	return 0
}


logic()	#function for a main rules
{
	snake_head="$snake_y,$snake_x"
	
	#make a snake hade move
	case "$direction" in 
		up) snake_y=$(($snake_y-1));;
		down) snake_y=$(($snake_y+1));;
		left) snake_x=$(($snake_x-1));;
		right) snake_x=$(($snake_x+1));;
	esac
	
	#make a snake body move
	if [ $direction != 0 ]; then 
	
		for (( i=${#snake_body[@]}-1; i>=0; i-- ))
		do
			if [ $i = 0 ]; then
				snake_body[$i]=$snake_head
			else
				snake_body[$i]=${snake_body[$(($i - 1))]}
			fi
		done
	fi
	
	#snake touch a borders
	if [[ $snake_x -le 0 || $snake_x -ge 20 || $snake_y -le 0 || $snake_y -ge 20 ]]; then 
	
		lives=$(($lives - 1))
		score=0
		snake_body=()
		snake_x=10
		snake_y=10
		direction=0
		
		play fail.8svx > /dev/null 2>&1 &
		sleep 1
		
	#snake touch a body
	elif [[ ${snake_body[@]} =~ (^| )$snake_y,$snake_x($| ) ]]; then 
	
		lives=$(($lives - 1))
		play fail.8svx > /dev/null 2>&1 &
		sleep 1
		
	#game over rule
	elif [ $lives -le 0 ];then 
	
		gameover=1
		play game-death.8svx > /dev/null 2>&1 &
		sleep 2
		
		if [ $score -gt $maxscore ]; then
			echo $score > maxscore.txt
		fi
		
	#score plus rule
	elif [[ $snake_x == $fruit_x && $snake_y == $fruit_y ]]; then 
		
		snake_body+=(0,0)
		
		score=$((score + 10))
		
		#make a sound
		echo -e "\a"
		
		#change emoji for a fruit
		random_index=$((RANDOM % ${#fruit_list[@]}))
		random_fruit=${fruit_list[$random_index]}
		
		#change a fruit location
		fruit_x=$((RANDOM % 20))
		fruit_y=$((RANDOM % 20))
		
		#check the coordinates not equals zero
		while [ $fruit_x -eq 0 ]; do
			fruit_x=$((RANDOM % 20))
		done
		while [ $fruit_y -eq 0 ]; do
			fruit_y=$((RANDOM % 20))
		done
	fi
	
	#backround color change
	if [ $score = 100 ]; then
		back=43
	elif [ $score = 200 ];then
		back=44
	elif [ $score = 300 ];then
		back=45
	elif [ $score = 400 ];then
		back=47
	fi
	
	return 0
}


main() #start all sub-function
{
	setup 
	
	#main music theme
	play maintheme.8svx > /dev/null 2>&1 &

	while [ $gameover != 1 ] 
	do
		draw
		input
		logic
	done
	
	#stop music
	music=`pgrep play`
	if [ $music ]; then
		kill $music
	fi
	
	return 0
}

main
