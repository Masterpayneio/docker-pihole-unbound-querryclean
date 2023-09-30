#!/bin/bash

# Set the path to your script
SCRIPT_PATH="/etc/pihole_assist/clean.sh"

# Check if the crontab entry already exists
if ! crontab -l | grep -q "$SCRIPT_PATH"; then
    # Add the cron job to run the script every hour
    (crontab -l ; echo "0 * * * * $SCRIPT_PATH") | crontab -
    echo "Cron job added successfully."
else
    echo "Cron job already exists. No changes made."
fi
