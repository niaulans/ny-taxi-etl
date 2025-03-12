FROM python:3.9.1

RUN apt-get update
RUN apt-get install wget

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir /app
WORKDIR /app

COPY . .

ENTRYPOINT [ "python", "etl.py" ]