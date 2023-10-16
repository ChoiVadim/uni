#!/bin/bash

main()
{	
	while [ True ]; do
		
		echo '<Select a program!>'
		
		select prog in "Calculator" "Game" "End"; do
			break;
		done
					
		if [[ "$prog" == 'Calculator' ]]; then cal
		elif [[ "$prog" == 'Game' ]]; then
			echo 'In developing...'
		elif [[ "$prog" == 'End' ]]; then break
		fi	
	done
	
}		

cal() 
{
	while [ True ]; do
	
		read -p 'Enter first number: ' num1
		read -p 'Enter operator(+,-,*,/): ' oper
		read -p 'Enter second number: ' num2
		
		if [[ "$num1" == 'end' ]]; then main	#BREAK while 
			
		elif [[ "$num1" =~ ^[0-9]{9,}$ || "$num2" =~ ^[0-9]{9,}$ ]]; then	#check how big number
			echo -e "\033[31mSorry, entered number is too big!\033[0m"
			
		elif [[ "$num1" =~ ^-?[0-9]+\.?[0-9]*$ && "$num2" =~ ^-?[0-9]+\.?[0-9]*$ ]]; then
		
			case "${oper}" in	#check entered operator
				'+' | 'sum' | 'sum') sum $num1 $num2;;
				'-' | 'min' | 'minus') sub $num1 $num2;;
				'*' | 'mul' | 'mull') mul $num1 $num2;;
				'/' | 'div' | 'divine') div $num1 $num2;;
				*) echo -e "\033[31mError: unknowing operator\033[0m";;
			esac
			
		elif echo "$num1" | grep -q '[a-zA-Z]' || "$num2" | grep -q '[a-zA-Z]' ; then	#check is number have any eng letter
			echo -e "\033[31mNumbers are not a numeric!\033[0m\nTry again!"
			
		else 
			echo -e "\033[31mUnknowing error!\033[0m"

		fi
	done
}

sum()
{
	float_num=$(echo "scale=2; $num1+$num2" | bc -l)
	echo "$num1 + $num2 = $float_num"
}

sub()
{	
	if [[ "$num2" =~ ^-[0-9]+\.?[0-9]*$ ]]; then
		float_num=$(echo "scale=2; $num1+$(expr $num2 \* -1)" | bc -l)
		echo "$num1 - ($num2) = $float_num"
	else
		float_num=$(echo "scale=2; $num1-$num2" | bc -l)
		echo "$num1 - $num2 = $float_num"
	fi	
}

mul()
{
	float_num=$(echo "scale=2; $num1*$num2" | bc -l)
	echo "$num1 * $num2 = $float_num"
}

div()
{
	if [ "$num2" == 0 ]; then
		echo -e "\033[31mError: dividing by zero\033[0m"
	else
		float_num=$(echo "scale=2; $num1/$num2" | bc -l)
		echo "$num1 / $num2 = $float_num"
	fi
}

main
