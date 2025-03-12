#!/bin/bash

# Pastikan script error jika ada perintah yang gagal
set -e

# Path ke file daftar tabel dan URL
FILE="table_urls.txt"

# Debug: Tampilkan isi file sebelum loop
echo "Reading table_urls.txt..."
cat "$FILE"
echo "------------------------------------"
echo ""

# Simpan waktu mulai total proses
START_TOTAL=$(date +%s)

# Loop setiap baris dalam file
while IFS=" " read -r TABLE_NAME URL || [[ -n "$TABLE_NAME" ]]
do
    echo "Processing table: $TABLE_NAME"

    # Simpan waktu mulai proses untuk tabel ini
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

    # Hitung durasi waktu untuk tabel ini
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    echo "Finished processing $TABLE_NAME"
    echo "Total time: $DURATION seconds"
    echo "------------------------------------"

done < "$FILE"

# Hitung total durasi untuk semua tabel
END_TOTAL=$(date +%s)
TOTAL_DURATION=$((END_TOTAL - START_TOTAL))

echo "All tables processed!"
echo "Total execution time: $TOTAL_DURATION seconds"
