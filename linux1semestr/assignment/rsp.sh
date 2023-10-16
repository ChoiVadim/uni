#!/bin/bash

read -p "Please enter the number of people to play the game! (1 or 2) : " choice

if [ "$choice" -eq 1 ]; then
   ./rsp1
elif [ "$choice" -eq 2 ]; then
    ./rsp2
else
    echo "Wrong Number!Please try again."
    exit 1
fi

./RSP
