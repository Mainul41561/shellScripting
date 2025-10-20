#!/bin/bash

# This is for and while loop
<< task
arguments equal 1 folder name
arguments equal 2 start range
arguments equal 3 end range
task
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <folder_name_prefix> <start_range> <end_range>"
    exit 1
fi

for (( num=$2; num<=$3; num++ ))
do
    mkdir "$1$num"
    echo "Folder created: $1$num"
done


