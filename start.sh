#!/bin/bash
# Compatible with Ubuntu 16.04 Xenial and Debian 9.x Stretch
#
	# This program is free software; you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation; either version 2 of the License, or
    # (at your option) any later version.

    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.

    # You should have received a copy of the GNU General Public License along
    # with this program; if not, write to the Free Software Foundation, Inc.,
    # 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#-------------------------------------------------------------------------------------------------------------

clear
echo "NeXt Server"
echo "Preparing menu..."

#-------------dialog
apt-get -qq install dialog >/dev/null 2>&1

SCRIPT_PATH="/root/NeXt-Server"

source ${SCRIPT_PATH}/configs/versions.cfg
source ${SCRIPT_PATH}/script/functions.sh

HEIGHT=30
WIDTH=60
CHOICE_HEIGHT=10
BACKTITLE="NeXt Server"
TITLE="NeXt Server"
MENU="Choose one of the following options:"

		OPTIONS=(1 "Install NeXt Server ${NEXT_VERSION}"
						 2 "Update all services"
				 		 3 "Openssh Options"
						 4 "Openssl Options"
						 5 "Fail2ban Options"
						 6 "Nginx vHost Options"
						 7 "Lets Encrypt Options"
						 8 "Firewall Settings"
						 9 "Update NeXt Server Script"
			     	 10 "Exit")

		CHOICE=$(dialog --clear \
						--nocancel \
						--no-cancel \
						--backtitle "$BACKTITLE" \
						--title "$TITLE" \
						--menu "$MENU" \
						$HEIGHT $WIDTH $CHOICE_HEIGHT \
						"${OPTIONS[@]}" \
						2>&1 >/dev/tty)

		clear
		case $CHOICE in
				1)
					INSTALLATION="1"
					bash install.sh
					;;
				2)
					#check if installed, otherwise skip single services
					dialog --backtitle "NeXt Server Installation" --infobox "Updating all services" $HEIGHT $WIDTH
					source ${SCRIPT_PATH}/script/logs.sh; set_logs
					source ${SCRIPT_PATH}/script/prerequisites.sh; prerequisites

					source script/openssh.sh; update_openssh
					source script/openssl.sh; update_openssl
					dialog --backtitle "NeXt Server Installation" --msgbox "Finished updating all services" $HEIGHT $WIDTH
					;;
				3)
					source script/openssh.sh; menu_options_openssh
					;;
				4)
					source script/openssl.sh; menu_options_openssl
					;;
				5)
					source script/fail2ban.sh; menu_options_fail2ban
					;;
				6)
					source script/nginx_vhost.sh; menu_options_nginx_vhost
					;;
				7)
					source script/lets_encrypt.sh; menu_options_lets_encrypt
					;;
				8)
					#firewall settings
					#source script/lets_encrypt.sh; menu_options_lets_encrypt
					apt-get update
					;;
				9)
					dialog --backtitle "NeXt Server Installation" --infobox "Updating NeXt Server Script" $HEIGHT $WIDTH
					source ${SCRIPT_PATH}/update_script.sh; update_script
					dialog --backtitle "NeXt Server Installation" --msgbox "Finished updating NeXt Server Script" $HEIGHT $WIDTH
					;;
				10)
					echo "Exit"
					exit 1
					;;
		esac
