## NYC Taxi Data ETL Project

### Project Overview
This project demonstrates a complete ETL (Extract, Transform, Load) pipeline using Python, PostgreSQL and Docker to process the New York City Taxi Trip dataset. The main goal is to extract raw data from a public URL, perform necessary transformations to clean the data, load the processed data into a data warehouse and visualize it. I used Github Codespaces as my primary development environment which provided a fast and consistent setup, especially for working with Docker and PostgreSQL in cloud-based workspace.

The diagram below shows the workflow of this project.

![Workflow](/assets/nyc_taxi_trip.png)

### Dataset
For this project, I worked with the Yellow and Green taxi trip datasets of January 2025 and Taxi Zone dataset, available as public parquet and CSV files from [The New York City Taxi and Limousine Commission (TLC)](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page) website. The datasets contain millions of rows of real-world taxi data trip data. The datasets schema can also be viewed these pages [Yellow](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf) and [Green](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf)

### Tech stack and Tools
1. Github Codespaces (for cloud-based development)
2. Python
3. Docker
4. PostgreSQL & PgAdmin 4
5. Power BI

### Setup and Installation
1. Clone this repository
```bash
git clone https://github.com/niaulans/ny-taxi-etl
```

2. Change directory
```bash
cd app
```

3. Start the docker containers
```bash
docker-compose up -d
```

4. Build image
```
docker build -t ny-taxi-etl:v01 .
```

5. Run the ETL pipeline
```bash
bash run_etl.sh
```

6. Connect Power BI to PosgreSQL

The full step-by-step documentation can be found on my blog [here](https://niaulans.tech/posts/ETL-Pipeline-Project-NYC-Taxi-Data/)

### Visualization
_Overall Taxi Data_
![Overall data](/assets/all.jpg)

_Yellow Taxi_
![Yellow Taxi](/assets/yellow.jpg)

_Green Taxi_
![Green Taxi](/assets/green.jpg)


You can check the interactive version [here](https://app.powerbi.com/reportEmbed?reportId=f5c26d72-c8ec-4b39-aa5b-52bcb624d25b&autoAuth=true&ctid=1241de96-4dbf-4231-aa90-4d48af86085c)