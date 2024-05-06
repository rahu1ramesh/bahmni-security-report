#!/bin/bash

# Root folder
ROOT_FOLDER="container-scanner-reports"
# Subdirectory to be checked and potentially renamed
SUB_DIR="bahmni-latest"

# Check if the root folder exists
if [ -d "$ROOT_FOLDER" ]; then
    # Path to the subdirectory
    SUB_DIR_PATH="$ROOT_FOLDER/$SUB_DIR"
    
    # Check if the subdirectory exists
    if [ -d "$SUB_DIR_PATH" ]; then
        # Calculate yesterday's date in the format DD-MM-YYYY
        YESTERDAY_DATE=$(date --date yesterday "+%d-%m-%Y")
        
        # New folder name with yesterday's date
        NEW_DIR_NAME="bahmni-$YESTERDAY_DATE"
        NEW_DIR_PATH="$ROOT_FOLDER/$NEW_DIR_NAME"
        
        # Rename the "bahmni-latest" directory to "bahmni-<yesterday's date>"
        mv "$SUB_DIR_PATH" "$NEW_DIR_PATH"
        echo "Renamed '$SUB_DIR' to '$NEW_DIR_NAME'"
        
        # Iterate through each file in the new directory
        for file in "$NEW_DIR_PATH"/*; do
            echo "28 Renaming file ("$file")"
            # Check if the file contains the word "latest"
            if [[ "$file" == *"latest"* ]];then
                echo "Renaming file ("$file")"
                # Get the file name
                file_name=$(basename "$file")
                # Replace the word "latest" in the file name with yesterday's date
                new_file_name=$(echo "$file_name" | sed "s/latest/$YESTERDAY_DATE/")
                # Rename the file
                mv "$file" "$NEW_DIR_PATH/$new_file_name"
                echo "Renamed file '$file_name' to '$new_file_name'"
            fi
        done
    else
        echo "Subdirectory '$SUB_DIR' does not exist in the root folder."
    fi
else
    echo "Root folder '$ROOT_FOLDER' does not exist."
fi
