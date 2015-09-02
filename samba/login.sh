#!/bin/sh -

fses='/home/smbses/'$1
rm $fses

v_ipmac=`/usr/local/bin/arp-scan -q --interface=rl1 $1 | sed -n '3p' | sed 's/[    ]/_/g'`
res=''
res=`grep $v_ipmac /etc/samba/access`
if [ "$res" == "" ]
then
 echo 'mudak!!! - '$v_ipmac >> /home/smbusers/log
 exit
fi

v_nic=`echo $res | cut -d_ -f1`

v_sz=`echo $res | cut -d_ -f5`

v_dir='/home/smbusers/'$v_nic
ln -s $v_dir $fses

siz=`du -sL $fses | sed -e 's/[    ].*//g'`

if [ $siz -gt $v_sz ]
then
 echo 'limit exceeded! - '$v_nic' '$v_ipmac >> /home/smbusers/log
 echo 'smblim'
else
 echo 'smbfull'
fi
