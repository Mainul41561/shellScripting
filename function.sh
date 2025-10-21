#!/bin/bash


: <<'comment'
This is the function in shell scripting
comment

function isLoyal(){
read -p "$1 is loyal if your gf's name is: " name
read -p "Enter $1 love percentage: " percent

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
    echo "$1 is loyal"

elif [[ "$percent" -ge 100 ]]; then
    echo "$1 is loyal"
else
    echo "$1 are not loyal"
fi

}

#calling the function
isLoyal "tom"
