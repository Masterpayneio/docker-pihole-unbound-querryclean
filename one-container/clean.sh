#!/bin/bash

# Function to remove queries to protect against injection
rmQuery () {
    # Validate the domain before constructing the query
    if [[ "$1" =~ ^[a-zA-Z0-9.%-]+$ ]]; then
        result=$(sqlite3 /etc/pihole/pihole-FTL.db "delete from query_storage where domain in (select id from domain_by_id where domain like '$1');")
        if [ $? -ne 0 ]; then
            echo "Error removing queries for domain $1: $result"
        fi
    else
        echo "Invalid domain: $1"
    fi
}

# Main script
echo "Query Purge Started at $(date)"

# Stops FTL; So that we are not writing to a live database
service pihole-FTL stop

# Change to the directory
cd /etc/pihole_assist

# Check if querry_purg.conf exists
if [ -e "querry_purg.conf" ]; then
    # Read the file line by line, ignoring comments
    while IFS= read -r line; do
        # Ignore lines starting with a hash (#)
        if [[ "$line" != "#"* ]]; then
            # Extract the domain from the line
            domain=$(echo "$line" | awk '{print $1}')
            echo "Removing queries for domain: $domain"
            rmQuery $domain
        fi
    done < "querry_purg.conf"
else
    echo "Error: querry_purg.conf not found."
fi

#Restart FTL and Log completion
service pihole-FTL restart
echo "Query Purge Completed at $(date)"