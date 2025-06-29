FROM astrocrpublic.azurecr.io/runtime:3.0-4-base

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

COPY include/data /usr/local/airflow/include/data
