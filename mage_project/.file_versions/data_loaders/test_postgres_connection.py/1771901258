import os
from sqlalchemy import create_engine, text

@data_loader
def load_data(*args, **kwargs):
    host = os.environ["POSTGRES_HOST"]
    port = os.environ["POSTGRES_PORT"]
    db   = os.environ["POSTGRES_DB"]
    user = os.environ["POSTGRES_USER"]
    pwd  = os.environ["POSTGRES_PASSWORD"]

    url = f"postgresql+psycopg2://{user}:{pwd}@{host}:{port}/{db}"
    engine = create_engine(url)

    with engine.connect() as conn:
        version = conn.execute(text("SELECT version();")).scalar()

    return {"ok": True, "postgres_version": version}