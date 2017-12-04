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

install_system() {

cat > /etc/hosts <<END
127.0.0.1 localhost
::1 localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
END

echo -e "${IPADR} ${MYDOMAIN} $(echo ${MYDOMAIN} | cut -f 1 -d '.')" >> /etc/hosts
hostnamectl set-hostname mail.${MYDOMAIN}
echo "${MYDOMAIN}" > /etc/mailname

timedatectl set-timezone ${TIMEZONE}

#we use another DNS to prevent resolving errors later (the OVH DNS for exmaple has sometimes problems, with resolving gnu.org and so on).
echo 'options rotate' >> /etc/resolv.conf
echo 'options timeout:1' >> /etc/resolv.conf
echo 'nameserver 9.9.9.9' >> /etc/resolv.conf

#disabled ipv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

rm /etc/apt/sources.list

cat > /etc/apt/sources.list <<END
#Debian
deb http://ftp.de.debian.org/debian/ stretch main contrib non-free
deb-src http://ftp.de.debian.org/debian/ stretch main contrib non-free

deb http://security.debian.org/debian-security stretch/updates main
deb-src http://security.debian.org/debian-security stretch/updates main
END

apt-get update -y >>"${main_log}" 2>>"${err_log}"
apt-get -y upgrade >>"${main_log}" 2>>"${err_log}"

}
