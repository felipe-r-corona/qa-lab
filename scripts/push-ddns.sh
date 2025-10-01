#!/bin/bash
IP=$(hostname -I | awk '{print $1}')
curl "http://192.168.68.10:5000/update?hostname=ugithub.lab.local&ip=$IP"

