#!/bin/bash
IP=$(hostname -I | awk '{print $1}')
HOSTNAME=$(hostname)
FQDN="${HOSTNAME}.lab.local"
curl "http://192.168.68.10:5000/update?hostname=$FQDN&ip=$IP"

