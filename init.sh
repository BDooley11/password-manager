#!/bin/bash

user=$1

if [ "$#" -ne 1 ]; then
	echo "Error: parameters problem"
elif [ -d $user ]; then
	echo "Error: user already exists"
else 
	./p.sh $user
	mkdir $user
	echo "OK: user created"
	./v.sh $user
fi
