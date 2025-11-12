#!/bin/sh
# Date variable
    # cert file names have date suffix
todays_date=$(date +"%Y-%m-%d")

# Password variable
    # Pull password from local file
#pfx_password=$(cat /path/password.txt)
passwordfile=/path/password.txt

# Extract the PFX
    # Needs two files - PEM + KEY
cd /home/admin/tlm_agent_x.x.x_linux64/.secrets/liveaction.ncemcs.com_$todays_date_*
openssl pkcs12 -in liveaction.ncemcs.com.pfx -passin file:$passwordfile -out enterprise.key -nocerts -nodes
openssl pkcs12 -in liveaction.ncemcs.com.pfx -passin file:$passwordfile -out enterprise.pem -nokeys -clcerts

# Move files to /etc/ssl/liveaction/
ssl_dir=/etc/ssl/liveaction/
mv -f enterprise.key $ssl_dir
mv -f enterprise.pem $ssl_dir

# Restart services
systemctl stop livenx-server
systemctl stop livenx-web
systemctl stop livenx-admin 

systemctl start livenx-server
systemctl start livenx-web
systemctl start livenx-admin
