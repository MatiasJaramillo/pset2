import os
from sqlalchemy import create_engine, text

@data_loader
def load_data(*args, **kwargs):
    host = os.environ["POSTGRES_HOST"]
    port = os.environ["POSTGRES_PORT"]
    db   = os.environ["POSTGRES_DB"]
    user = os.environ["POSTGRES_USER"]
    pwd  = os.environ["POSTGRES_PASSWORD"]

    engine = create_engine(f"postgresql+psycopg2://{user}:{pwd}@{host}:{port}/{db}")

    ddl_trips = """
    CREATE TABLE IF NOT EXISTS bronze.trips_raw (
      vendorid              INTEGER NULL,
      pickup_datetime       TIMESTAMP NULL,
      dropoff_datetime      TIMESTAMP NULL,
      passenger_count       NUMERIC NULL,
      trip_distance         NUMERIC NULL,
      ratecodeid            NUMERIC NULL,
      store_and_fwd_flag    TEXT NULL,
      pulocationid          INTEGER NULL,
      dolocationid          INTEGER NULL,
      payment_type          NUMERIC NULL,
      fare_amount           NUMERIC NULL,
      extra                 NUMERIC NULL,
      mta_tax               NUMERIC NULL,
      tip_amount            NUMERIC NULL,
      tolls_amount          NUMERIC NULL,
      improvement_surcharge NUMERIC NULL,
      total_amount          NUMERIC NULL,
      congestion_surcharge  NUMERIC NULL,
      airport_fee           NUMERIC NULL,

      ingest_ts    TIMESTAMP NOT NULL,
      source_month TEXT NOT NULL,
      service_type TEXT NOT NULL,
      source_file  TEXT NULL
    );
    """

    ddl_zone = """
    CREATE TABLE IF NOT EXISTS bronze.taxi_zone_lookup (
      locationid   INTEGER PRIMARY KEY,
      borough      TEXT,
      zone         TEXT,
      service_zone TEXT,
      ingest_ts    TIMESTAMP NOT NULL
    );
    """

    ddl_idx = """
    CREATE INDEX IF NOT EXISTS idx_bronze_trips_raw_month_service
      ON bronze.trips_raw (source_month, service_type);
    """

    with engine.begin() as conn:
        conn.execute(text(ddl_trips))
        conn.execute(text(ddl_zone))
        conn.execute(text(ddl_idx))

    return {"tables_ready": True}