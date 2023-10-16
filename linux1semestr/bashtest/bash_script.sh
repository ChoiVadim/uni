#!/bin/bash

main() 
{
	while [ true ]; do
	
		read -p 'Enter first number: ' num1
		read -p 'Enter operator(+,-,*,/): ' oper
		read -p 'Enter second number: ' num2
				
		if [[ "$num1" =~ ^-?[0-9]+\.?[0-9]*$ && "$num2" =~ ^-?[0-9]+\.?[0-9]*$ ]]; then 
			
			if [[ "$num1" =~ ^[0-9]{9,}$ || "$num2" =~ ^[0-9]{9,}$ ]]; then
				echo -e "\033[31mSorry, entered number is too big!\033[0m"	
			#elif [[ "$num1" =~ ^-[0-9]+\.?[0-9]?$ || "$num2" =~ ^-[0-9]+\.?[0-9]?$ ]]; then
				#echo -e "\033[31mError: Please, enter ONLY positive number!\033[0m"	
			else
				if [ "$oper" == '+' ]; then
					sum $num1 $num2
				elif [ "$oper" == '-' ]; then
					sub $num1 $num2
				elif [ "$oper" == '*' ]; then
					mul $num1 $num2
				elif [ "$oper" == '/' ]; then
					div $num1 $num2
				else 
					echo -e "\033[31mError: unknowing operator\033[0m"
				fi
			fi
			
		else 
			echo -e "\033[31mFirst number or second number is not a numeric!\033[0m
Try again!"
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
