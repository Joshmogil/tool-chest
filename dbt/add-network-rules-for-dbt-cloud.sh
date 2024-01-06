#!/bin/bash


echo 'See https://cloud.getdbt.com/233425/projects/333806/setup'
echo 'This script must be run as root'
dbt_ips='52.45.144.63 54.81.134.249 52.22.161.231 52.3.77.232 3.214.191.130 34.233.79.135'

for ip in $dbt_ips; do
	`iptables -L -n -v | grep -q $ip` 
	if [ "$?" == "0" ]
	then
		echo "$ip already in ip tables"
	else
		echo "Adding ingress for $ip"
		iptables -I INPUT -p tcp -s $ip -j ACCEPT
	fi
done
