import os
import pandas as pd
import requests
from io import BytesIO
from datetime import datetime
from sqlalchemy import create_engine, text

@data_loader
def load_data(*args, **kwargs):
    url = "https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv"

    r = requests.get(url, timeout=60)
    r.raise_for_status()

    df = pd.read_csv(BytesIO(r.content))
    df.columns = [c.strip().lower().replace(" ", "_") for c in df.columns]
    df["ingest_ts"] = datetime.utcnow()

    host = os.environ["POSTGRES_HOST"]
    port = os.environ["POSTGRES_PORT"]
    db   = os.environ["POSTGRES_DB"]
    user = os.environ["POSTGRES_USER"]
    pwd  = os.environ["POSTGRES_PASSWORD"]
    engine = create_engine(f"postgresql+psycopg2://{user}:{pwd}@{host}:{port}/{db}")

    with engine.begin() as conn:
        conn.execute(text("TRUNCATE TABLE bronze.taxi_zone_lookup;"))
        df.to_sql("taxi_zone_lookup", con=conn, schema="bronze", if_exists="append", index=False)

    return {"zone_rows_loaded": int(len(df))}