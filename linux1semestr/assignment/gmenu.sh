#!/bin/bash

SELECTED=1;
INPUT="";
MIN_MENU=1;
MAX_MENU=4; 
ESC=`printf "\033"`;
PAGE=1;
MIN_PAGE=1;
MAX_PAGE=2;

input() {
    read -s -n3 INPUT;
    echo $INPUT;
}

check_selected() {
    if [ $1 = $2 ];
    then echo " -> "
    else echo "    "
    fi
}

select_menu() {	
    	clear
    	printf "\e[1m%15sMINIACADE\n";
        for (( i=1; i<=MAX_MENU; i++))
        do
            printf "\e[2K$(check_selected $i $SELECTED) $i) ${!i}\n";
        done
        printf "\n\e[2K상하방향키로 고르고 Enter로 선택\n";
        printf "\e[2K좌우방향키로 페이지 선택(1/2)\n";
        INPUT=$(input);
        if [[ $INPUT = "" ]];
        then gameplay $SELECTED;
        fi
        
        if [[ $INPUT = $ESC[A ]];
        then SELECTED=$(expr $SELECTED - 1);
        elif [[ $INPUT = $ESC[B ]];
        then SELECTED=$(expr $SELECTED + 1);
        elif [[ $INPUT = $ESC[D ]];
        then PAGE=$(expr $PAGE - 1);
        elif [[ $INPUT = $ESC[C ]];
        then PAGE=$(expr $PAGE + 1);
        
        else
        continue
        fi
        
        if [[ $SELECTED -lt $MIN_MENU ]];
        then SELECTED=${MIN_MENU};
        elif [[ $SELECTED -gt $MAX_MENU ]];
        then SELECTED=${MAX_MENU};
        elif [[ $PAGE -gt $MAX_PAGE ]];
        then PAGE=${MAX_PAGE};
        elif [[ $PAGE -lt $MIN_PAGE ]];
        then PAGE=${MIN_PAGE};
        fi
}

select_menu2() {	
    	clear
    	printf "\e[1m%15sMINIACADE\n";
        for (( i=1; i<=MAX_MENU; i++))
        do
            printf "\e[2K$(check_selected $i $SELECTED) $i) ${!i}\n";
        done
        printf "\n\e[2K상하방향키로 고르고 Enter로 선택\n";
        printf "\e[2K좌우방향키로 페이지 선택(2/2)\n";
        INPUT=$(input);
        if [[ $INPUT = "" ]];
        then gameplay2 $SELECTED;
        fi
        
        if [[ $INPUT = $ESC[A ]];
        then SELECTED=$(expr $SELECTED - 1);
        elif [[ $INPUT = $ESC[B ]];
        then SELECTED=$(expr $SELECTED + 1);
        elif [[ $INPUT = $ESC[D ]];
        then PAGE=$(expr $PAGE - 1);
        elif [[ $INPUT = $ESC[C ]];
        then PAGE=$(expr $PAGE + 1);
        
        else
        continue
        fi
        
        if [[ $SELECTED -lt $MIN_MENU ]];
        then SELECTED=${MIN_MENU};
        elif [[ $SELECTED -gt $MAX_MENU ]];
        then SELECTED=${MAX_MENU};
        elif [[ $PAGE -gt $MAX_PAGE ]];
        then PAGE=${MAX_PAGE};
        elif [[ $PAGE -lt $MIN_PAGE ]];
        then PAGE=${MIN_PAGE};
        fi
}


select_setting() {
    arr_params=("Snake game" "Wordle" "RSP" "EXIT");
    echo "Select Value";
    select_menu "${arr_params[@]}";
}

select_setting2() {
    arr_params=("car game" "remember game" "MAZE" "EXIT");
    echo "Select Value";
    select_menu2 "${arr_params[@]}";
}


gameplay()
{
	if [ $SELECTED -eq 1 ];
	then ./snake_v0.1.sh
	elif [ $SELECTED -eq 2 ];
	then ./word
	elif [ $SELECTED -eq 3 ];
	then ./rsp.sh
	elif [ $SELECTED -eq 4 ];
	then exit
	fi
}

gameplay2()
{
	if [ $SELECTED -eq 1 ];
	then ./car
	elif [ $SELECTED -eq 2 ];
	then ./remember_game
	elif [ $SELECTED -eq 3 ];
	then ./maze
	elif [ $SELECTED -eq 4 ];
	then exit
	fi
}


main() {
while [ true ];
do
if [ $PAGE -eq 1 ];
then
   select_setting;
elif [ $PAGE -eq 2 ];
then
   select_setting2;
fi  
done
}

main
