#!/bin/bash

# Backup script with 5-day rotation

displayUsage() {
    echo "Usage: $0 <source directory> <backup directory>"
}

if [ $# -ne 2 ]; then
    displayUsage
    exit 1
fi

sourceDir="$1"
backupDir="$2"

# Validate source directory
if [ ! -d "$sourceDir" ]; then
    echo "Error: Source directory '$sourceDir' does not exist."
    exit 1
fi

# Create backup directory if it doesn't exist
mkdir -p "$backupDir"

timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
backup_file="${backupDir}/backup_${timestamp}.zip"

createBackup() {
    if zip -r "$backup_file" "$sourceDir" > /dev/null 2>&1; then
        echo "Backup generated successfully: $backup_file"
    else
        echo "Error: Failed to create backup."
        exit 1
    fi
}

performRotation() {
    mapfile -t backups < <(ls -t "${backupDir}/backup_"*.zip 2>/dev/null)

    # If more than 5 backups exist, delete the oldest ones
    if [ "${#backups[@]}" -gt 5 ]; then
        echo "Performing rotation: keeping 5 most recent backups"
        
        # Keep first 5 (newest), delete the rest
        for ((i=5; i<${#backups[@]}; i++)); do
            rm -f "${backups[i]}"
            echo "Deleted old backup: ${backups[i]}"
        done
    fi
}

createBackup
performRotation
