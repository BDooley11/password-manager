#!/bin/bash

mkfifo server.pipe
while true; do
	read -r -a myArray < server.pipe
	clientid=${myArray[0]}
	input=${myArray[1]}
	if [ $input == "edit" ]; then
		input="update"
	fi
	case "$input" in
		init)
			output=`./init.sh ${myArray[2]} & `
			echo -e "$output" > "$clientid".pipe
			 ;;
		insert)
			decrypt=`./decrypt.sh $clientid ${myArray[5]} `
			payload="login:${myArray[4]}\npassword:$decrypt"
			output=`./insert.sh ${myArray[@]:2:2} "" $payload ${myArray[@]:6} & `
			echo -e "$output" > "$clientid".pipe
			;;
		show)
			output=`./show.sh ${myArray[@]:2} & `
			tempfile=$(mktemp)
			echo -e "$output" > $tempfile	
			greplogin="$(grep -i login $tempfile)"
			greppassword="$(grep -i pass $tempfile)"
			login="$(echo $greplogin | cut -d ":" -f 2)"
			password="$(echo $greppassword | cut -d ":" -f 2)"
			rm ${tempfile}
			encrypt=`./encrypt.sh $clientid $password `
			echo -e "$login" "$encrypt" > "$clientid".pipe
			;;
		update)
			payload=`./show.sh ${myArray[@]:2:2} & `
			tempfile=$(mktemp)
			echo -e "$payload" > $tempfile
			greplogin="$(grep -i login $tempfile)"
			greppassword="$(grep -i pass $tempfile)"
			login="$(echo $greplogin | cut -d ":" -f 2)"
			password="$(echo $greppassword | cut -d ":" -f 2)" 	
			rm ${tempfile}
			encrypt=`./encrypt.sh $clientid $password `			
			opayload="login:$login\npassword:$encrypt"
			echo -e "$opayload" > "$clientid".pipe	
			newpayload="$(cat server.pipe)"
			tempfile=$(mktemp)
			echo -e "$newpayload" > $tempfile 
			newgreplogin="$(grep -i login $tempfile)"
			newgreppassword="$(grep -i pass $tempfile)"
			newlogin="$(echo $newgreplogin | cut -d ":" -f 2)"
			newpassword="$(echo $newgreppassword | cut -d ":" -f 2)"
			decrypt=`./decrypt.sh $clientid $newpassword `
			newpayload="login:$login\npassword:$decrypt"
			output=`./insert.sh ${myArray[@]:2:2} f $newpayload & `
			echo -e "$output" > "$clientid".pipe
			rm ${tempfile}
			;;
		rm)	
			output=`./rm.sh ${myArray[@]:2} & `
			echo -e "$output" > "$clientid".pipe
			;;
		ls)
			output=`./ls.sh ${myArray[@]:2} & `
			echo -e "$output" > "$clientid".pipe
			;;
		shutdown)
			echo -e "Server has shutdown " > "$clientid".pipe
			rm server.pipe
			exit 0
			;;
		*)
			echo -e "Error: bad request" > "$clientid".pipe
			exit 1
	esac
done
