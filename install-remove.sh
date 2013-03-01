#!/bin/bash

# Install/Remove script for OMV-df-alltogether script
# Use it with OMV

# Author: Solo0815
# feel free to edit this file, but please share it in
# the OMV-Forum: http://forums.openmediavault.org/viewtopic.php?f=13&t=79#p244

# Version 0.1

##### Shell-Colors
GREEN="\033[0;32m"
RED='\e[0;31m'
NC='\033[0m'        # No Color

######################################################
# Functions

#checks, if the command was successfull
f_checksuccess() {
	if [ $? -ne 0 ] ; then # Last Action returns an error $1=1
		echo -e "${RED}failed!$NC" ; sleep 1
	else # if successfull $1=0
		echo -e "${GREEN}successfull!$NC" ; sleep 1
	fi
}

# Install all the files to OMV
f_install() {
# 	echo -n "Do you have lm-sensors already installed and configured? (y/n) "
# 	read -n 1 LM_SENSORS
# 
# 	case $LM_SENSORS in
# 		y|Y)
# 			;;
# 		n|N)
# 			echo -e "\n\nYou have to install and configure lm-sensors first"
# 			echo "Then you can rerun this script"
# 			echo "Exiting ..."
# 			exit 0
# 			;;
# 		*)
# 			echo "\n\nPlease use y/n! Exiting ..."
# 			exit 0
# 			;;
# 	esac
# 
# 	sleep 1
	echo -e "\n\nInstalling files ..."

# 	if [ -f /etc/omv-sensor.conf ]; then
# 		echo -e "\nomv-sensor.conf exists - What to do?\n"
# 		echo "1 - install the default version - then all your changes in this file are gone"
# 		echo "2 - keep the current version"
# 		echo -n "-> "
# 		read -n 1 OMV_SENSOROVERWRITE
# 		case $OMV_SENSOROVERWRITE in
# 			1)
# 				echo -ne "\n\nmaking backup of omv-sensor.conf ... "
# 				cp /etc/omv-sensor.conf /etc/omv-sensor.conf_bak  > /dev/null 2>&1
# 				f_checksuccess
# 				echo -ne "omv-sensor.conf >>> /etc ... "
# 				cp omv-sensor.conf /etc > /dev/null 2>&1
# 				f_checksuccess
# 				;;
# 			2)
# 				echo -e "\n\nomv-sensor.conf is not updated"
# 				;;
# 			*)
# 				echo "\n\nPlease use 1 or 2! Exiting ..."
# 				exit 0
# 				;;
# 		esac
# 	else
# 		echo -ne "\n\nomv-sensor.conf >>> /etc ... "
# 		cp omv-sensor.conf /etc > /dev/null 2>&1
# 		f_checksuccess
# 	fi

	echo -ne "\ndf-alltogether >>> /usr/share/openmediavault/scripts/collectd.d/ ... "
	cp df-alltogether /usr/share/openmediavault/scripts/collectd.d/ > /dev/null 2>&1
	f_checksuccess


	if [ -f /var/www/openmediavault/js/omv/module/admin/Systeminfo.js -a ! -f /var/www/openmediavault/js/omv/module/admin/Systeminfo.js.backup ]; then
		echo -ne "Systeminfo.js found! Making backup to /var/www/openmediavault/js/omv/module/admin/Systeminfo.js.backup ... "
		mv /var/www/openmediavault/js/omv/module/admin/Systeminfo.js /var/www/openmediavault/js/omv/module/admin/Systeminfo.js.backup > /dev/null 2>&1
		f_checksuccess
	else
		echo -ne "Systeminfo.js.backup found! No backup is needed ... "
	fi
		
	echo -ne "Systeminfo.js >>> /var/www/openmediavault/js/omv/module/admin ... "
	cp Systeminfo.js /var/www/openmediavault/js/omv/module/admin > /dev/null 2>&1
	f_checksuccess

# 	echo -ne "Fanspeed.default /var/www/openmediavault/js/omv/module/admin ... "
# 	cp Fanspeed.default /var/www/openmediavault/js/omv/module/admin > /dev/null 2>&1
# 	f_checksuccess

	# new:
	echo -ne "\nShould this install-script make the changes for the first-time-setup? (y/n) "
	read -n 1 CONFIRM

	case $CONFIRM in
		y|Y)
			echo -e "\n\nMaking changes ..."
			sleep 1
			echo -e "\nrunning '/usr/share/openmediavault/scripts/collectd.d/df-alltogether' ... "
			echo
			/usr/share/openmediavault/scripts/collectd.d/df-alltogether
			f_checksuccess

# 			echo -e "\nIf you have errors here, it's due to missing rrd-files."
# 			echo -e "\nrestarting collectd ..."
# 			/etc/init.d/collectd restart
# 			f_checksuccess

			echo "creating graphs ..."
			/usr/sbin/omv-mkgraph
			f_checksuccess

			echo -e "Installation completed!"
# 			echo -e "\nEdit /etc/omv-sensor.conf to fit your needs and run"
# 			echo "'/usr/share/openmediavault/scripts/collectd.d/sensors'"
# 			echo -e "to create the rrd-scripts for OMV.\n"
			echo -e "After install, you can delete the omvdf-alltogether-master folder\n"
			echo "Have fun!"
			;;
		n|N)
			echo -e "\n\nYou have to make the changes by yourself"
			cat <<EOF
and run '/usr/share/openmediavault/scripts/collectd.d/df-alltogether'
to create the rrd-scripts for OMV.

Run 'omv-mkgraph' to create the graphs.

After install, you can delete this folder

Have fun!

EOF
			exit 0
			;;
		*)
			echo "Please use y/n! Exiting ..."
			exit 0
			;;
	esac
}

# Remove all the files from OMV - omv-sensors.conf can be chosen to remove or keep
f_remove() {
	echo -n "Do you want to remove all files from the df-alltogether-script? (y/n) "
	read -n 1 LM_DF_ALLTOGETHER_REMOVE

	case $LM_DF_ALLTOGETHER_REMOVE in
		y|Y)
			;;
		n|N)
			echo "Nothing to do"
			echo "Exiting ..."
			exit 0
			;;
		*)
			echo "\n\nPlease use y/n! Exiting ..."
			exit 0
			;;
	esac

	echo -e "\n\nRemoving files ..."

# 	if [ -f /etc/omv-sensor.conf ]; then
# 		echo -ne "\nRemove omv-sensor.conf? (y/n)"
# 		read -n 1 OMV_SENSOR_REMOVE
# 		case $OMV_SENSOR_REMOVE in
# 			y|Y)
# 				echo -ne "\n\nremoving omv-sensor.conf ... "
# 				rm /etc/omv-sensor.conf > /dev/null 2>&1
# 				f_checksuccess
# 				;;
# 			n|N)
# 				echo -e "\n\nomv-sensor.conf is not removed"
# 				;;
# 			*)
# 				echo "\n\nPlease use y/n!"
# 				echo -e "\n\nomv-sensor.conf is not removed"
# 				;;
# 		esac
# 	else
# 		echo -ne "\n\nomv-sensor.conf not found"
# 	fi

	if [ -f /usr/share/openmediavault/scripts/collectd.d/df-alltogether ]; then
		echo -ne "Systeminfo.js found! Making backup to /var/www/openmediavault/js/omv/module/admin/Systeminfo.js.bak ... "
		rm /usr/share/openmediavault/scripts/collectd.d/df-alltogether > /dev/null 2>&1
		f_checksuccess
	else
		echo -ne "\n/usr/share/openmediavault/scripts/collectd.d/df-alltogether not found!"
	fi

	if [ -f /var/www/openmediavault/js/omv/module/admin/Systeminfo.js -a -f /var/www/openmediavault/js/omv/module/admin/Systeminfo.js.backup ]; then
		echo -ne "restoring Backup of /var/www/openmediavault/js/omv/module/admin/Systeminfo.js ... "
		sleep 1
		echo -ne "- removing /var/www/openmediavault/js/omv/module/admin/Systeminfo.js ... "
		rm  /var/www/openmediavault/js/omv/module/admin/Systeminfo.js > /dev/null 2>&1
		f_checksuccess
		echo -ne "- renaming /var/www/openmediavault/js/omv/module/admin/Systeminfo.js.backup to /var/www/openmediavault/js/omv/module/admin/Systeminfo.js ... "
		mv  /var/www/openmediavault/js/omv/module/admin/Systeminfo.js.backup /var/www/openmediavault/js/omv/module/admin/Systeminfo.js > /dev/null 2>&1
		f_checksuccess
	else
		echo -ne "\n/var/www/openmediavault/js/omv/module/admin/Sensors.js.backup not found!"
		echo -ne "\nscript is not installed!"
	fi

# 	if [ -f /var/www/openmediavault/js/omv/module/admin/Fanspeed.default ]; then
# 		echo -ne "removing /var/www/openmediavault/js/omv/module/admin/Fanspeed.default ... "
# 		rm  /var/www/openmediavault/js/omv/module/admin/Fanspeed.default > /dev/null 2>&1
# 		f_checksuccess
# 	else
# 		echo -ne "\n/var/www/openmediavault/js/omv/module/admin/Fanspeed.default not found!"
# 	fi
# 	
# 	if [ -f /var/www/openmediavault/js/omv/module/admin/Fanspeed.js ]; then
# 		echo -ne "removing /var/www/openmediavault/js/omv/module/admin/Fanspeed.js ... "
# 		rm  /var/www/openmediavault/js/omv/module/admin/Fanspeed.js > /dev/null 2>&1
# 		f_checksuccess
# 	fi
# 
# 	if [ -f /var/www/openmediavault/js/omv/module/admin/Sensors.js ]; then
# 		echo -ne "removing /var/www/openmediavault/js/omv/module/admin/Sensors.js ... "
# 		rm  /var/www/openmediavault/js/omv/module/admin/Sensors.js > /dev/null 2>&1
# 		f_checksuccess
# 	fi

	echo -e "Removing completed!"
	echo "Have fun!"
}

######################################################
# Main Body of script

cat <<EOF


#############################################################
###                                                       ###
###      OMV-df-alltogether Install / Remove script       ###
###                                                       ###
#############################################################


EOF

echo -e "\ndf-alltogether-script Installation / Remove in OMV?\n"
echo "1 - install"
echo "2 - remove"
echo -n "-> "
read -n 1 OMV_DF_ALLTOGETHER_INST_REM
case $OMV_DF_ALLTOGETHER_INST_REM in
	1)
		echo
		echo
		f_install
		;;
	2)
		echo
		echo
		f_remove
		;;
	*)
		echo "\n\nPlease use 1 or 2 only! Exiting ..."
		exit 0
		;;
esac

exit 0