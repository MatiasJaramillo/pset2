import os
import subprocess

@data_loader
def load_data(*args, **kwargs):
    files = [
        "/home/src/sql/partitioning/01_create_partitioned_dim_zone.sql",
        "/home/src/sql/partitioning/02_create_partitioned_dim_service_type.sql",
        "/home/src/sql/partitioning/03_create_partitioned_dim_payment_type.sql",
        "/home/src/sql/partitioning/04_create_partitioned_dim_vendor.sql",
        "/home/src/sql/partitioning/05_create_partitioned_dim_date.sql",
        "/home/src/sql/partitioning/06_create_partitioned_fct_trips.sql",
    ]

    env = os.environ.copy()
    results = []

    for file_path in files:
        cmd = f'PGPASSWORD="{env["POSTGRES_PASSWORD"]}" psql -h {env["POSTGRES_HOST"]} -p {env["POSTGRES_PORT"]} -U {env["POSTGRES_USER"]} -d {env["POSTGRES_DB"]} -f {file_path}'
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        results.append({
            "file": file_path,
            "returncode": result.returncode,
            "stdout": result.stdout,
            "stderr": result.stderr,
        })

    return results