#!/bin/bash

# This script
# Ask if you want to be anonymous, verify if nipe installed, and if not, install it.
# Give you the option to scan the local network, or an external address.
# Creates a list of the entire address range of the target IP.
# Randomly scan an IP and a port address, if it's open, the results will be saved with timestamp in .log file.

function SCAN() { #Scans randomly and keeps only ports open with a time stamp
for ip in $(cat MixIP.list)													# Random ip address
do
P="$((1 + $RANDOM % 65535))"												# Random port number
echo "Scanning $ip:$P"
sudo nmap $ip -T2 -p"$P" -Pn -sS > .random.log 2>/dev/null	 				# Scans only 1 at a time

if [[ -z $(cat .random.log | grep -i open) ]] ; then  						# In case an open port is found
echo "a" | grep "b" 
else 																		# Log the results
echo "-----found open port in $ip:$P at $(date +%T)-----"
echo "-----found open port in $ip:$P at $(date +%T)-----" >> scan.log
cat .random.log >> scan.log
echo " " >> scan.log
fi
sleep 0.5 
done

}

function CREATE() { #Creates an area for entering results
cd /home/$(whoami) 	#Note this is a point that could be a problem
if [ ! -d Scans ]; then
sudo mkdir Scans
fi
	cd Scans
if [ ! -d $IP ]; then 
sudo mkdir $IP
fi
	cd $IP							###Clear the files
sudo bash -c 'echo " " > IP.list' 
sudo chmod 777 IP.list 2>/dev/null
sudo bash -c 'echo " " > MixIP.list' 
sudo chmod 777 MixIP.list 2>/dev/null
sudo bash -c 'echo "------------------$(date)------------------" > scan.log' 
sudo chmod 777 scan.log 2>/dev/null
									###
if [ -z $(which prips) ]; then 
echo "prips not installed, start installation..."
sudo apt install prips -y
fi

}
		
function SHUF() { ###Create a list of mixed ip addresses 
shuf IP.list > MixIP.list 
sudo rm -f IP.list

if [[ -z $(cat MixIP.list) ]] ; then 
echo "a" | grep "b" 
else 
echo "MixIP.list created"
fi
SCAN
}

function QUES() { #Scan the local network or an external address
	
read -p "Do you want to scan your network(1), or enter IP address(2)? " onetwo
		
	if [[ $onetwo == 1 ]];then
		echo "Your network is $(ip -o -f inet addr show | awk '/scope global/ {print $4}')"
		IP=LocalNetwork
		CREATE #call the create function
		IP=$(ip -o -f inet addr show | awk '/scope global/ {print $4}')
														##Create a list of ip addresses
		nmap -sL -n $IP | awk '/Nmap scan report/{print $NF}' > IP.list
														##
	elif [[ $onetwo == 2 ]];then
		echo "Enter the IP address"; read IP
		CREATE #call the create function
														#Create a list of ip addresses
		RIP=$(whois $IP | egrep 'inetnum|NetRange' | head -n1 | awk '{print $2}')
		LIP=$(whois $IP | egrep 'inetnum|NetRange' | head -n1 | awk '{print $4}')
		prips $RIP $LIP > IP.list
														##
	else
		echo "The wording is not acceptable, please try again"
		echo "-----------------------------------------------"
		QUES #if the answer isnt in the required  format 
	fi	
	
SHUF
}

function ANONIMOUS() { #all the part relaited to the anonimpus

function YOUR-ANONIMOUS() { #check if I am Anonimous
	
	cd $NipePath
	sudo perl nipe.pl start 
	sudo perl nipe.pl status > NipeStatus
	STATUS=$(cat NipeStatus | grep -o activated)
	echo "$STATUS"
		if [ "activated" == "$STATUS" ] 
		then 
		echo "YOUR computer is [*] Anonimous [*]"
		sleep 1.5
		else	#In the first installation of Nipe / starting Nipe after reboot the server
				#there is a known issue, sometimes you have to run it 2 times and it works..
			echo "There is a problem with the starting Nipe, tring one more time"
			sleep 1.5
			sudo perl nipe.pl stop
			sudo perl nipe.pl start 
			sudo perl nipe.pl status > NipeStatus
			STATUS=$(cat NipeStatus | grep -o activated)
			echo "$STATUS"
			if [ "activated" == "$STATUS" ] 
			then 
			echo "YOUR computer is [*] Anonimous [*]" 
			sleep 1.5
			QUES    ##call the QUES function
			else	
			echo "YOUR computer is [*] NOT [*] Anonimous, Exit..."
			exit
			fi	
		fi
}

function INSTALL() { #check if the apps you want to use are installed
	
		if [ ! -z $(pwd | grep "nipe") ] 
		then 
		echo "[*] nipe is install in your computer. [*] You can initializing the scan"
		sleep 1.5
		else     ####nipe install commends###
		banner "Download nipe.pl"
		sleep 3
		sleep 1.5
		cd $ChoosePath

		sudo git clone https://github.com/htrgouvea/nipe && cd nipe && sudo cpan install Try::Tiny Config::Simple JSON && sudo ./nipe.pl install
			if [ -f $ChoosePath/nipe/nipe.pl ] #check if nipe download properly
			then
			echo "[*]Nipe installed[*]"
			sleep 2
			else 
			echo "problem whith installing Nipe [*****]"
			exit
			fi
		sudo updatedb
		FindNipe
		fi 
		YOUR-ANONIMOUS
}

function FindNipe() { # path to find nipe
	
		cd $ChoosePath
		locate nipe | grep nipe.pl | head -1 > .nipe.path1
		NipePath=$(cat .nipe.path1 | sed 's/nipe.pl//g' | sed 's/.$//') # peth to nipe in any computer
		sudo rm -f .nipe.path1
		cd $NipePath
		INSTALL
}

function Ask-You-Anonimous() { # ask if you want the remote server to be anonimous
echo "Do you want to be Anonumous(y/n)?"
read YesNo
if [ $YesNo = y ]; then # if yes send to anonimous function
FindNipe
else                    # if no send to recon apps function
echo "OK.... Your choice..."

WEB-LIST

fi
}
Ask-You-Anonimous


}
ANONIMOUS