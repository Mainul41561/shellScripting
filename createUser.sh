#!/bin/bash

read -p "Enter username " username 
echo "You Entered $username "

# command to add user 
sudo useradd -m $username
echo "New user added "

#To see created user use command ' cat /etc/passwd '
