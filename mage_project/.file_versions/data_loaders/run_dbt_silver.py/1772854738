import os
import subprocess

@data_loader
def load_data(*args, **kwargs):
    env = os.environ.copy()

    result = subprocess.run(
        ["dbt", "run", "--select", "silver", "--profiles-dir", "."],
        cwd="/home/src/dbt",
        env=env,
        capture_output=True,
        text=True
    )

    return {
        "returncode": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr
    }