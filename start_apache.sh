#!/bin/bash

which crond
# Define folder name
folder_name="/home/web-ui"

# Create .htpasswd file with username and password
htpasswd_file=".htpasswd"
htpasswd_username="xmltv"

# Check if HTPASSWD_PASSWORD variable is already set
if [ -z "$htpasswd_password" ]; then
    # Generate a random password
    htpasswd_password=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 16)
fi

# Execute tv_grab_pt_vodafone --configure
printf "all\n" | "$tv_grab_command" --configure

# Execute tv_grab_pt_vodafone --days 4 with output to /home/xmltv.xml once
"$tv_grab_command" --days $days --output $folder_name/xmltv.xml

# Add cron job to run tv_grab_pt_vodafone --days 4 with output to /home/xmltv.xml every 3 days at midnight
(crontab -l ; echo "45 23 */2 * * $tv_grab_command --days $days --output $folder_name/xmltv.xml") | crontab -

# Check if .htpasswd file already exists
if [ ! -f "$htpasswd_file" ]; then
    # Create .htpasswd file if it doesn't exist
    printf "%s:%s\n" "$htpasswd_username" "$(openssl passwd -apr1 $htpasswd_password)" > "$htpasswd_file"
fi

# Create .htaccess file
htaccess_file=".htaccess"
echo "AuthType Basic" > "$htaccess_file"
echo "AuthName 'Restricted Access'" >> "$htaccess_file"
echo "AuthUserFile $folder_name/$htpasswd_file" >> "$htaccess_file"
echo "Require valid-user" >> "$htaccess_file"

# Move .htaccess and .htpasswd to the restricted folder
mv "$htaccess_file" "$folder_name/"
mv "$htpasswd_file" "$folder_name/"

# Inform user about successful setup
echo "Configuration completed. Access to $folder_name is now restricted."
echo "Username is: $htpasswd_username"
echo "Password is: $htpasswd_password"
echo "web .xml file: http://$htpasswd_username:$htpasswd_password@localhost/xmltv.xml"

# Start Apache2 in the foreground
crond -f &
httpd -DFOREGROUND

