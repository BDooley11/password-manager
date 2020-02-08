#!/bin/bash

user=$1
folder=$2

if [ $# -gt 2 ]; then
	echo "Error: parameters problem"
elif [ ! -d $user ]; then
	echo "Error: user does not exist"
elif [ $# -eq 2 ]; then
	./p.sh $user
	if [ ! -d $user/$folder ]; then
		echo "Error: folder does not exist"
		./v.sh $user
	else 
		cd $user
		echo "OK:"
		tree --noreport $folder
		cd ..
		./v.sh $user
	fi
else
	./p.sh $user
	echo "OK:"
	tree --noreport $user
	./v.sh $user
fi
