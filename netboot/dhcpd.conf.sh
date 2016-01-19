#!/bin/bash
source ./vars
function dhcp_conf(){

    NET=$(echo "$ROUTER" | awk -F"." '{print $1"."$2"."$3"."}')"0"
    MASK="255.255.255.0"
    FIRST_ADDR=$(echo "$ROUTER" | awk -F"." '{print $1"."$2"."$3"."}')"100"
    LAST_ADDR=$(echo "$ROUTER" | awk -F"." '{print $1"."$2"."$3"."}')"150"
    BROADCAST=$(echo "$ROUTER" | awk -F"." '{print $1"."$2"."$3"."}')"255"
    cat > "$DHCP" <<EOF
ddns-update-style none;
authoritative;
log-facility local7;
ping-check = 1;
filename = "pxelinux.0";

subnet $NET netmask $MASK {
    range $FIRST_ADDR $LAST_ADDR;
    option domain-name-servers $DNS;
    option domain-name "$DOMAIN";
    option routers $ROUTER;
    option broadcast-address $BROADCAST;
    default-lease-time 604800;
    max-lease-time 604800;
}
EOF
}
dhcp_default_conf(){
    IS_IFACE=$(grep "INTERFACE" "$DEF_DHCP" | grep "$INT_IFACE")
    [ "$IS_IFACE" ] || {
	cp "$DEF_DHCP" "$DEF_DHCP.tmp"
	grep -v "INTERFACES=" "$DEF_DHCP.tmp" > "$DEF_DHCP"
	echo 'INTERFACES="'$INT_IFACE'"' >> "$DEF_DHCP"
	rm "$DEF_DHCP.tmp"
    }
}
backup_conf(){
    IS_ORIG=$(ls "$PTH_DHCP" | grep "$DHCP.orig")
    ORIG=""
    [ "$IS_ORIG" ] || {
	cp "$PTH_DHCP$DHCP" "$PTH_DHCP$DHCP.orig"
	ORIG="done"
    }
    [ "$ORIG" ] || cp "$PTH_DHCP$DHCP" "$PTH_DHCP$DHCP.bak.$FILE_UID"
    
}
install_soft(){
    apt-get update
    for i in $1 ;
    do
	apt-get -y install "$i"
    done
    rcconf --off "$SERV_DHCP"
}
install_soft "$SOFT"
dhcp_conf
dhcp_default_conf
backup_conf
cp "$DHCP" "$PTH_DHCP$DHCP"
rm "$DHCP"
service "$SERV_DHCP" restart