#!/bin/bash

# Get today's date in the desired format for folder naming
TODAY_DATE=$(date +'%d-%m-%Y')

# Define the directory to read files from
DIR="container-scanner-reports/bahmni-${TODAY_DATE}"

# Define the output HTML file
OUTPUT_FILE="container-scanner-reports/bahmni-${TODAY_DATE}/index.html"

# Define CSS styles for the table
CSS_STYLES=$(cat <<'EOF'
<style>
    body {
        font-family: Arial, sans-serif;
        font-size: 14px;
        color: #333;
    }
    table {
        width: 100%;
        margin: 20px 0;
        border-spacing: 2px;
    }
    th, td {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: left;
    }
    th {
        background-color: #f2f2f2;
    }
    tr:hover {
        background-color: #f1f1f1;
    }
    h1 {
        font-size: 20px;
        margin: 0;
        display: block;
        margin-block-start: 0.67em;
        margin-block-end: 0.67em;
        margin-inline-start: 0px;
        margin-inline-end: 0px;
        font-weight: bold;
        unicode-bidi: isolate;
    }
</style>
EOF
)

# Start the HTML file and add the CSS styles
echo "<!DOCTYPE html>
<html>
<head>
    <title>Container Scanner Reports</title>
    $CSS_STYLES
</head>
<body>
    <h1>Container Scanner Reports</h1>
    <table>
        <tr>
            <th>File Name</th>
        </tr>" > "$OUTPUT_FILE"

# Iterate through each file in the directory
for file in "$DIR"/*; do
    # Get the base name of the file (without the directory path)
    base_name=$(basename "$file")
    
    # Add a table row with the file name as a clickable link
    echo "        <tr>
            <td><a href=\"$base_name\">$base_name</a></td>
        </tr>" >> "$OUTPUT_FILE"
done

# Close the table and the HTML document
echo "    </table>
</body>
</html>" >> "$OUTPUT_FILE"

# Output the success message
echo "HTML file '$OUTPUT_FILE' created successfully."
