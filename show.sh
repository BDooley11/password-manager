#!/bin/bash

user=$1
service=$2

if [ $# -ne 2 ]; then
	echo "Error: parameters problems"
elif [ ! -d $user ]; then
	echo "Error: user does not exist"
elif [ ! -f $user/$service ]; then
	echo "Error: service does not exist"
else
	./p.sh $user
	grep -i pass $user/$service
	grep -i login $user/$service
	./v.sh $user
fi
