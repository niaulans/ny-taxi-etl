#!/bin/bash

# Ensure the script exits if any command fails
set -e

# Path to the file containing table names and URLs
FILE="table_urls.txt"

# Debug: Display the file contents before looping
echo "Reading table_urls.txt..."
cat "$FILE"
echo "------------------------------------"
echo ""

# Record the start time of the entire process
START_TOTAL=$(date +%s)

# Loop through each line in the file
while IFS=" " read -r TABLE_NAME URL || [[ -n "$TABLE_NAME" ]]
do
    echo "Processing table: $TABLE_NAME"

    # Record the start time for this table's process
    START_TIME=$(date +%s)

    docker run --rm -t \
        --network=project1-network \
        --name "ny-taxi-container-$TABLE_NAME" \
        ny-taxi-etl:v01 \
            --user=admin \
            --password=admin123 \
            --host=postgres_db \
            --port=5432 \
            --db=ny_taxi \
            --table_name="$TABLE_NAME" \
            --url="$URL"

    # Calculate the duration for this table's process
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    echo "Finished processing $TABLE_NAME"
    echo "Total time: $DURATION seconds"
    echo "------------------------------------"

done < "$FILE"

# Calculate the total duration for all tables
END_TOTAL=$(date +%s)
TOTAL_DURATION=$((END_TOTAL - START_TOTAL))

echo "All tables processed!"
echo "Total execution time: $TOTAL_DURATION seconds"
