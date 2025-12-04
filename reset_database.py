import os
import sys
import psycopg2
from dotenv import load_dotenv

load_dotenv()

def get_connection():
    if len(sys.argv) > 1:
        return psycopg2.connect(sys.argv[1], sslmode='require')
    db_url = os.getenv("DB_URL") or os.getenv("DATABASE_URL")
    if db_url:
        return psycopg2.connect(db_url, sslmode='require')
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        dbname=os.getenv("DB_NAME")
    )

def drop_all(cur):
    tables = [
        "Offer", "Flys_On", "Works", "Owns", "Operates", "Departure", "Arrival", 
        "Review", "Buy", "Ticket", "Flight", "Airplane", "Airline_Staff_Number", 
        "Airline_Staff", "Customer", "Airport", "Airline"
    ]
    for table in tables:
        print(f"Dropping table {table}...")
        cur.execute(f"DROP TABLE IF EXISTS {table} CASCADE;")
    
    types = ["flight_status", "card_type", "airport_type"]
    for type_name in types:
        print(f"Dropping type {type_name}...")
        cur.execute(f"DROP TYPE IF EXISTS {type_name} CASCADE;")

def run_sql_file(cur, filename):
    print(f"Running {filename}...")
    with open(filename, 'r') as f:
        cur.execute(f.read())

def main():
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()
        
        print("Starting database reset...")
        drop_all(cur)
        
        run_sql_file(cur, "Create Tables.sql")
        run_sql_file(cur, "Insertion Data.sql")
        
        conn.commit()
        print("Database reset and populated successfully!")
        
    except Exception as e:
        if conn:
            conn.rollback()
        print(f"Error: {e}")
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    main()
