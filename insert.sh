#!/bin/bash

user=$1
service=$2
payload=$4
directory=`dirname "$service"`
file=`basename "$service"`
filepath=$user/$service

if [ $# -ne 4 ]; then
	echo "Error: parameters problem"
elif [ ! -d $user ]; then 
	echo "Error: user does not exist" 
elif [ -f "$user/$directory/$file" ] && [ "$3" != "f" ]; then
	echo "Error: service already exists"
else 
	./p.sh $user
	if [ ! -d "$user/$directory" ]; then
		mkdir -p "$user/$directory"
	fi
	if [ -f "$user/$directory/$file" ] && [ "$3" = "f" ]; then
		echo -e $payload > "$user/$directory/$file"
		echo "OK: service updated"
		./v.sh $user
	else
		echo -e $payload > "$user/$directory/$file"
		echo "OK: service created"
		./v.sh $user
	fi
fi                                                                                                                                                                                                            	
