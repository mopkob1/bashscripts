#!/bin/sh -

fil='/etc/samba/access'

echo `date` >> $fil 

echo -n ' User (nicname) - '
read v_nic
res=`grep -c "^$v_nic" $fil`
if [ $res != 0 ]
then
 echo 'nicname '\"$v_nic\"' busy!!!'
 sleep 2
 exit
fi

echo -n ' Fullname user - '
read v_fn

echo -n ' User IP - '
read v_ip
res=`grep -c "$v_ip" $fil`
if [ $res != 0 ]
then
 echo 'IP-'$v_ip' busy!!!'
 sleep 2
 exit
fi

ping -w 1 -c 1 $v_ip >/dev/null

if [ $? != 0 ]; then
 echo 'IP address unavailable :('
 sleep 2
 exit
fi 


echo -n ' Allowable size of files (Mb)- '
read v_sm
let "v_sz=$v_sm * 2048"

v_ipmac=`/usr/local/bin/arp-scan -q --interface=rl1 $v_ip | sed -n '3p' | sed -e 's/[    ]/_/g'`

#  nicname_fullname_ip_mac_limit
echo $v_nic'_'$v_fn'_'$v_ipmac'_'$v_sz >> /etc/samba/access

v_dir='/home/smbusers/'$v_nic
mkdir $v_dir
chmod 755 $v_dir
chown smbfull $v_dir
chgrp smbfull $v_dir

echo ' Ok!'
sleep 1
