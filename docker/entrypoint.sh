#!/bin/bash

# SIGTERM-handler
term_handler() {
  echo "Get SIGTERM"
  iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
  /etc/init.d/dnsmasq stop
  /etc/init.d/hostapd stop
  /etc/init.d/dbus stop
  kill -TERM "$child" 2> /dev/null
}

ifconfig wlan0 10.0.0.1/24

if [ -z "$SSID" -a -z "$PASSWORD" ]; then
  SSID="Pi3-AP"
  PASSWORD="raspberry"
fi
sed -i "s/ssid={{SSID}}/ssid=$SSID/g" /etc/hostapd/hostapd.conf
sed -i "s/wpa_passphrase={{PASSWORD}}/wpa_passphrase=$PASSWORD/g" /etc/hostapd/hostapd.conf

/etc/init.d/dbus start
/etc/init.d/hostapd start
/etc/init.d/dnsmasq start

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE
if [ ! $? -eq 0 ]
then
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
fi

# setup handlers
trap term_handler SIGTERM
trap term_handler SIGKILL

sleep infinity &
child=$!
wait "$child"