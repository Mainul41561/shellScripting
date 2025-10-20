#!/bin/bash

: <<'comment'
This is the condition in shell scripting
comment

read -p "You are loyal if your gf's name is: " name
read -p "Enter your love percentage: " percent

<< comment2
if [[ "$name" == "Sadia" ]]; then
    echo "You are loyal"
elif [[ "$percent" -ge 100 ]]; then
    echo "You are hundred percent loyal"
else
    echo "You are not loyal"
fi
comment2

if [[ "$name" == "Sadia" ]]; then
    echo "You are loyal"
fi

if [[ "$percent" -ge 100 ]]; then
    echo "You are hundred percent loyal"
else
    echo "You are not loyal"
fi
