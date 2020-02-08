#!/bin/bash

user=$1
service=$2
directory=`dirname "$service"`
file=`basename "$service"`

if [ $# -ne 2 ]; then
	echo "Error: parameters problem"
elif [ ! -d $user ]; then
	echo "Error: user does not exist"
elif [ ! -f $user/$service ]; then
	echo "Error: service does not exist"
else
	./p.sh $user
	rm $user/$directory/$file
	echo "OK: service removed"
	./v.sh $user
fi
