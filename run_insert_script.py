import os
import sys
import psycopg2
from dotenv import load_dotenv
from urllib.parse import urlparse

# Load environment variables
load_dotenv()

def get_connection():
    """
    Establishes a connection to the database.
    Prioritizes a direct DB_URL if provided or found in env,
    otherwise falls back to individual credentials.
    """
    # 1. Check for command line argument
    if len(sys.argv) > 1:
        db_url = sys.argv[1]
        print("Using database URL provided via command line...")
        return psycopg2.connect(db_url, sslmode='require')

    # 2. Check for DB_URL in .env (common for Render/production)
    db_url = os.getenv("DB_URL") or os.getenv("DATABASE_URL")
    if db_url:
        print("Using DATABASE_URL from environment...")
        return psycopg2.connect(db_url, sslmode='require')

    # 3. Fallback to individual credentials (local dev)
    print("Using individual credentials from .env...")
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        dbname=os.getenv("DB_NAME")
    )

def main():
    conn = None
    cur = None
    try:
        conn = get_connection()
        cur = conn.cursor()

        # Read SQL file
        file_path = "Insert 2.sql"
        print(f"Reading {file_path}...")
        with open(file_path, "r") as f:
            sql_content = f.read()

        # Execute
        print("Executing SQL...")
        cur.execute(sql_content)
        conn.commit()
        print(f"Successfully executed {file_path} against the database.")

    except Exception as e:
        if conn:
            conn.rollback()
        print(f"Error: {e}")
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

if __name__ == "__main__":
    main()
