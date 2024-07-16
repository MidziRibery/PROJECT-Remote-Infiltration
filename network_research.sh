#!/bin/bash

#~ maybe before this, create a folder for all the items to be inside. strech goals

#~ 1. Installations and Anonymity Check.


function START()
{

	sleep 1
	figlet "Operation"
	sleep 1
	figlet "Remote"
	figlet "Infiltration"
	sleep 1
}

#~ i) Install the needed applications.
#~ ii) If the applications are already installed. If installed, don’t install them again.


function INSTALL()
{
	# check status. how? version?
	echo "--------------------------------------------"
	echo
	echo "Checking to see if required tools are installed:"
	sleep 1
	INSTALL_NIPE
	sleep 1
	INSTALL_GIT
	sleep 1
	INSTALL_GEOIP-BIN
	sleep 1
	INSTALL_NMAP
	sleep 1
	INSTALL_SSHPASS
	sleep 1
	INSTALL_TOR
	sleep 1
	echo
	echo "All required tools good to go!"
	echo
	echo "--------------------------------------------"
	sleep 1
}

#~ NMAP, NIPE, SSHPASS, TOR, GEOIP-BIN, GIT (git --version)

function INSTALL_NIPE()
{
	
	NIPE_DIR=$(sudo find / -type d -name "nipe" 2>/dev/null)	# Search for 'nipe' directory
	if [ -n "$NIPE_DIR" ]; then									#check for NIPE, if installed, echo 'NIPE INSTALLED', EXIT.
		echo "[#] NIPE is already installed."
		sleep 1
	else
		echo "NIPE is not installed. Installing now..."
	
		git clone https://github.com/htrgouvea/nipe 			# clone NIPE from git repo
		cd nipe													# cd in NIPE folder
		cpanm --installdeps .									# install dependencies
		sudo perl nipe.pl install								# install NIPE
		echo "[*] NIPE successfully installed."
		sleep 1
		INSTALL 
	fi
}

function INSTALL_NMAP()
{
	NMAP_V=$(nmap --version)	#check for NMAP version
	if [ -n "$NMAP_V" ]; then
		echo "[#] NMAP is already installed."
		sleep 1
	else
		"NMAP is not installed. Installing now..."
		sudo apt-get update
		sudo apt-get install nmap -y
		echo "[*] NMAP successfully installed."
		INSTALL
	fi
}

function INSTALL_GEOIP-BIN()
{
	GEO_V=$(geoiplookup -V) #check for GEOIP-BIN version
	if [ -n "$GEO_V"  ]; then
		echo "[#] GEOIP-BIN is already installed."
	else
		"GEOIP-BIN is not installed. Installing now..."
		sudo apt-get update
		sudo apt-get install geoip-bin
		echo "[*] GEOIP-BIN successfully installed."
		INSTALL
	fi
}

function INSTALL_GIT()
{
	GIT_V=$(git --version)					#check for GIT version
	if [ -n "$GIT_V" ]; then
		echo "[#] GIT is already installed."
		sleep 1
	else
		"GIT is not installed. Installing now..."
		sudo apt-get update
		sudo apt-get install git
		echo "[*] GIT successfully installed."
		INSTALL
	fi
}

function INSTALL_TOR()
{
	TOR_V=$(tor --version)					#check for TOR version
	if [ -n "$TOR_V" ]; then
		echo "[#] TOR is already installed."
		sleep 1
	else
		"TOR is not installed. Installing now..."
		sudo apt-get update
		sudo apt-get install tor
		echo "[*] TOR successfully installed."
		INSTALL
	fi
}
function INSTALL_SSHPASS()
{
	SSHPASS_V=$(sshpass -V)					#check for SSHPASS version
	if [ -n "$SSHPASS_V" ]; then
		echo "[#] SSHPASS is already installed."
		sleep 1
	else
		"SSHPASS is not installed. Installing now..."
		sudo apt-get update
		sudo apt-get install sshpass
		echo "[*] SSHPASS successfully installed."
		INSTALL
	fi
}


#~ iii) Check if the network connection is anonymous; if not, alert the user and exit.
#~ iv) If the network connection is anonymous, display the spoofed country name.

function ANON()											# here were create a function ANON
{
	echo
	echo "Standby for anonymity check..."
	echo
	sleep 1
	IP_ADD=$(curl -s ifconfig.io)						# we curl to get IP address, adding -s to silent the noise
	if [ "$(geoiplookup $IP_ADD | grep -i SG)" ]		# we geoiplookup the IP address, make sure not from SG
	then
		echo "[*] You are NOT anonymous!"				#if SG, we flag as not anonymous
		sleep 2	
		NIPE
	else
		echo "[*] You are anonymous!"					#else, good to go.
		sleep 1
		echo "[*] Spoofed Country: $(geoiplookup $IP_ADD | awk -F: '{print $2}')"		# display spoofed country
		sleep 1	
		echo "[*] Spoofed IP: $IP_ADD"													# display spoofed IP
		echo
		sleep 2
		figlet "Good to Go!"
	fi
}

#~ Create Nipe function here to turn on Nipe.
function NIPE()
{

	echo "Launching NIPE..."
	sleep 1
	echo "Checking Launch Status, Standby..."
	echo
	cd nipe												# cd into the nipe folder
	sudo perl nipe.pl status							# run this command to check the status of nipe
	sleep 1
	echo "Launch Status False. Starting NIPE." 
	sudo perl nipe.pl start								# start the nipe program
	sudo perl nipe.pl status							# run this command to check the status of nipe
	#check if status is false. while status is false, run command to connect.Need function here.
	sleep 1
	echo "NIPE is Running.Status True.."
	sleep 1
	ANON												# run the ANON function back
}

#~ v) Allow the user to specify the address/URL to whois from remote server; save into a variable
function TARGET()
{
	read -p "[?] Specify a Domain/IP Address to Attack: " target
}

#~ 2. Automatically Scan the Remote Server for open ports.
function SCAN_REMOTE()
{
	#how to scan? using nmap -Pn?
	echo "--------------------------------------------"
	echo
	echo "[*] Scanning Remote Server for Open Ports.."
	sleep 2
	nmap 192.168.254.129					# scan the remote machine for open ports
	echo
	sleep 1
	echo "[*] Scanning Completed."
	sleep 1
	
}

#~ i) Connect to the Remote Server via SSH
	#how to connect? SSHPASS?
	#how to display the details of the remote server?
#~ ii) Display the details of the remote server (country, IP, and Uptime)
	#sshpass -e ssh -q tc@192.168.254.129	#using SSHPASS env instead
	#ok i found out we can inject our script into ssh machine and run it.
	# we can. but then, it will be stuck at nipe. 
	# can i create another bash file and inject it also?
	# but we can't be sending 2 files to Samson
	# using github? 
	# ok just realised this will be harder. so stick to one bash script
	# can i then call the variable outside the function? yes can
		
function CONNECT_REMOTE()
{

	export SSHPASS='tc'	# password to for automatic connection to remote machine, how to store this better?
	echo
	echo "[*] Establishing connection to Remote Server..."
	echo
	sleep 1
	RMT_UPTIME			#get the uptime
	sleep 1
	RMT_IP				#get the IP Address
	sleep 1
	RMT_COUNTRY			#get the Country
	echo
	echo "--------------------------------------------"
	sleep 1
	echo
}

function RMT_UPTIME()
{
	rmt_up=$(sshpass -e ssh -q tc@192.168.254.129 'uptime')
	echo "Uptime: $rmt_up"
}

function RMT_IP()
{
	rmt_ip=$(sshpass -e ssh -q tc@192.168.254.129 'curl -s ifconfig.io')
	echo "IP Address: $rmt_ip"
}

function RMT_COUNTRY()
{
	rmt_country=$(sshpass -e ssh -q tc@192.168.254.129 "geoiplookup $rmt_ip | cut -d ',' -f2 | cut -d ' ' -f2")
	echo "Country: $rmt_country"
	
}

# Commence Attack
function ATTACK() 
{
	sudo touch /var/log/nr.log		#standby and create nr.log
	echo "Commencing attack from Remote Server in 3.."
	sleep 1
	echo "2.."
	sleep 1
	echo "1.."
	sleep 1	
	echo
	WHOIS_TARGET					# WHOIS the given URL by user
	NMAP_TARGET						# NMAP the given URL by user
	sleep 1
	echo
	echo " --------------------------------------------------------------------------------------------"
	echo "|                                                                                            |"
	echo "| Attack Successful. Go to /var/log/nr.log to view log file records of Domain/IP Add scanned |" 
	echo "|                                                                                            |"
	echo " --------------------------------------------------------------------------------------------"
	sleep 3
}

#~ iii) Get the remote server to check the Whois of the given address/URL
	
function WHOIS_TARGET() # FROM REMOTE SERVER, NOT LOCAL
{
	# how? we whois straight IP_OR_DOMAIN
	echo "[*] Whoising target's address: $target"
	# save the data somewhere
	sshpass -e ssh -q tc@192.168.254.129 "whois '$target' > whois_output.txt"	#~ i) Save the Whois data into file on the remote computer
	sleep 1
	wget -q ftp://tc:tc@192.168.254.129/whois_output.txt  						# Download the generated whois_output.txt from remote machine
	echo "[@] WHOIS data of $target was saved into $(pwd)"						# We tell Whois data was saved into directory path
	sudo echo "$(date)- [*] WHOIS data collected for: $target" >> nr.log		# Add log report to nr.log to state what is happening.
	echo
	sleep 5
}

function NMAP_TARGET() # REMOTE SERVER, NOT LOCAL
{
	#export SSHPASS='tc'
	# how? we whois straight IP_OR_DOMAIN
	echo "[*] Scanning target's address: $target"
	sshpass -e ssh -q tc@192.168.254.129 "nmap '$target' > scan_output.txt"		# save the data somewhere
	sleep 1
	wget -q ftp://tc:tc@192.168.254.129/scan_output.txt  						# Download the generated scan_output.txt from remote machine
	echo "[@] NMAP data of $target was saved into $(pwd)"						# we tell NMAP data was saved into directory path
	sudo echo "$(date)- [*] NMAP data collected for: $target" >> nr.log			# add log report to nr.log to state what is happening.
}

#~ 3. Results
#~ iii) Create a log and audit your data collection.
#~ iv) The log needs to be saved on the local machine.

function NR_LOG()	# move logs from current file to /var/log/nr.log  # so work around, we save the nr.log on project folder, then move it to /var/log
{
	sudo cp nr.log /var/log
	echo
	echo "Verifying Accuracy of Data Log in /var/log/nr.log..."
	echo
	sleep 1
	cat /var/log/nr.log
}

function SUCCESS()
{
		sleep 1
		echo
		figlet "Great Success!"
}

############ Function Calls Starts Here ###################

START				# Welcome Message
INSTALL				# Checking all tools good to go
ANON				# Checking Anonymity
TARGET				# Wait for user input of target: Domain/IP Add
SCAN_REMOTE			# Scan remote machine for open ports
CONNECT_REMOTE		# Connect to remote machine
ATTACK				# Commence Attack
NR_LOG				# Move nr.log to /var/log/
SUCCESS				# Success Message





################################################################
################## MAIN SCRIPT ENDS HERE #######################
################################################################





#############################################################
################## TESTING GROUNDS ##########################
#############################################################

######## START FTP REMOTELY #######

function RMT_FTP()
{
	#~ sshpass -e ssh root@192.168.254.129
	#~ sudo systemctl start vsftpd
	export SSHPASS='tc'
	sshpass -e ssh root@192.168.254.129 'sudo systemctl start vsftpd'
}

#RMT_FTP



############### Store Files Remotely ###################

function RMT_STORE()
{
export SSHPASS='tc'

#~ sshpass -e ssh -q tc@192.168.254.129 'nmap '"$target"'' > scan_output.txt

#~ sshpass -e ssh -q tc@192.168.254.129 "sudo mkdir '$pwd'/new_folder"

#~ sshpass -e ssh -q tc@192.168.254.129 'nmap '"$target"' > scan_output.txt' 
sshpass -e ssh -q tc@192.168.254.129 "nmap '$target' > scan_output.txt"
}

#~ RMT_STORE


############# STOP NIPE ###########

#~ function STOP_NIPE()
#~ {
	#~ cd nipe
	#~ sudo perl nipe.pl stop
	#~ sudo perl nipe.pl status
	#~ echo "NIPE Stopped."
	#~ cd ..
#~ }
#~ STOP_NIPE

#########################################
############### OLD CODES ###############
#########################################

### Direct download from server bypassing server storage ###

function WHOIS_TARGET() # REMOTE SERVER, NOT LOCAL
{
	export SSHPASS='tc'
	# how? we whois straight IP_OR_DOMAIN
	echo "[*] Whoising target's address: $target"
	#~ sshpass -e ssh -q tc@192.168.254.129 'whois '"$target"'' > whois_output.txt		#explain why need so many ''' # this code directly downloads the output to my local machine and bypass storing on remote machine.
	sshpass -e ssh -q tc@192.168.254.129 "whois '$target' > whois_output.txt"
	sleep 1
	echo "[@] WHOIS data of $target was saved into $(pwd)"
	sudo echo "$(date)- [*] WHOIS data collected for: $target" >> nr.log		#add log report to nr.log to state what is happening.
	echo
	sleep 5
	# save the data somewhere
	# we tell Whois data was saved into directory path
}

function NMAP_TARGET() # REMOTE SERVER, NOT LOCAL
{
	export SSHPASS='tc'
	# how? we whois straight IP_OR_DOMAIN
	echo
	echo "[*] Scanning target's address: $target"
	#~ sshpass -e ssh -q tc@192.168.254.129 'nmap '"$target"'' > scan_output.txt  #ori, we put on hold
	sshpass -e ssh -q tc@192.168.254.129 "nmap '$target' > scan_output.txt"
	sleep 1
	echo "[@] NMAP data of $target was saved into $(pwd)"
	sudo echo "$(date)- [*] NMAP data collected for: $target" >> nr.log		#add log report to nr.log to state what is happening.
	# save the data somewhere
	# we tell Whois data was saved into directory path
}

## SSH way

function WHOIS_TARGET() # REMOTE SERVER, NOT LOCAL
{
	export SSHPASS='tc'
	# how? we whois straight IP_OR_DOMAIN
	echo "[*] Whoising target's address: $target"
	sshpass -e ssh -q tc@192.168.254.129 "whois '$target' > whois_output.txt"	#~ i) Save the Whois data into file on the remote computer
	sleep 1
	sshpass -e scp tc@192.168.254.129:whois_output.txt .  # Download the generated scan_output.txt from remote machine
	echo "[@] WHOIS data of $target was saved into $(pwd)"
	sudo echo "$(date)- [*] WHOIS data collected for: $target" >> nr.log		#add log report to nr.log to state what is happening.
	echo
	sleep 5
	# save the data somewhere
	# we tell Whois data was saved into directory path
}

function NMAP_TARGET() # REMOTE SERVER, NOT LOCAL
{
	export SSHPASS='tc'
	# how? we whois straight IP_OR_DOMAIN
	echo "[*] Scanning target's address: $target"
	sshpass -e ssh -q tc@192.168.254.129 "nmap '$target' > scan_output.txt"
	sleep 1
	sshpass -e scp tc@192.168.254.129:scan_output.txt .  # Download the generated scan_output.txt from remote machine
	echo "[@] NMAP data of $target was saved into $(pwd)"
	sudo echo "$(date)- [*] NMAP data collected for: $target" >> nr.log		#add log report to nr.log to state what is happening.
	# save the data somewhere
	# we tell Whois data was saved into directory path
}
