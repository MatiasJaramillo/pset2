FROM mageai/mageai:latest

USER root
RUN pip install --no-cache-dir dbt-postgres==1.8.2 pandas pyarrow requests sqlalchemy psycopg2-binary

WORKDIR /home/src
CMD ["mage", "start", "/home/src"]