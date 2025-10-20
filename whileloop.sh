#!/bin/bash

read -p "Enter starting number: " start
read -p "Enter ending number: " end

num=$start

# Loop through the range
while [[ $num -le $end ]]
do
    if [[ $((num % 2)) == 0 ]]; then
        echo "$num"
    fi
    num=$((num+1))
done


