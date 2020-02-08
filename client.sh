#!/bin/bash

clientid=$1
service=$2
username=$3

if [ $# -lt 2 ]; then
	echo "Error:parameters problem"
else 
	mkfifo "$clientid".pipe
	case "$service" in
		init)
			if [ $# -ge 2 ]; then
				echo $1 $2 $3 > server.pipe
				cat "$clientid".pipe
			else
				echo "Error: parameters problem"
			fi
			rm "$clientid".pipe
			;;
		insert)
			if [ $# -ge 3 ]; then
				echo "Please write Login:"
				read login
				echo "Please write password:"
				read password
				encrypted=`./encrypt.sh $clientid $password `
				echo "$1" "$2" "$3" "$4" "$login" "$encrypted" > server.pipe
				cat "$clientid".pipe
			else
				echo "Error: parameters problem"
			
			fi
			rm "$clientid".pipe
			;;
		show)
			if [ $# -ge 3 ]; then
				echo $1 $2 $3 $4 > server.pipe
				data="$(cat "$clientid".pipe)"
				login="$(echo $data | cut -d " " -f 1)"
				password="$(echo $data | cut -d " " -f 2)"
				decrypt=`./decrypt.sh $clientid $password `
				echo "$username's login for $4 is: $login"
				echo "$username's password for $4 is: $decrypt"
			else
				echo "Error:parameters problem"
			fi
			rm "$clientid".pipe
			;;
		ls)
			if [ $# -ge 2 ]; then
				echo $1 $2 $3 $4 > server.pipe
				cat "$clientid".pipe
			else
				echo "Error:parameters problem"	
			fi
			rm "$clientid".pipe		 
			;;	
		edit)
			if [ $# -ge 3 ]; then
				echo $1 $2 $3 $4 $5 $6 > server.pipe	
				data="$(cat "$clientid".pipe)"
				tempfile=$(mktemp)
				echo -e "$data" > $tempfile
				greplogin="$(grep -i login $tempfile)"
				greppassword="$(grep -i pass $tempfile)" 
				login="$(echo $greplogin | cut -d ":" -f 2)"
				password="$(echo $greppassword | cut -d ":" -f 2)"
				decrypt=`./decrypt.sh $clientid $password`
				payload="login:$login\npassword:$decrypt"
				echo -e "$payload" > $tempfile
				vi $tempfile	
				newgreplogin="$(grep -i login $tempfile)"
				newgreppassword="$(grep -i pass $tempfile)"
				newlogin="$(echo $newgreplogin | cut -d ":" -f 2)"
				newpassword="$(echo $newgreppassword | cut -d ":" -f 2)"
				encrypt=`./encrypt.sh $clientid $newpassword `
				newpayload="login:$newlogin\npassword:$encrypt"
				echo -e "$newpayload"  > server.pipe
				cat "$clientid".pipe
				rm ${tempfile}
			else
				echo "Error:parameters problem"
			fi
			rm "$clientid".pipe
			;;
		rm)	
			if [ $# -ge 3 ]; then
				echo $1 $2 $3 $4 > server.pipe
				cat "$clientid".pipe
			fi
			rm "$clientid".pipe
			;;
		shutdown)
			if [ $# -ge 2 ]; then
				echo $1 $2 > server.pipe
				cat "$clientid".pipe
			fi
			rm "$clientid".pipe
			;;
	esac
fi
