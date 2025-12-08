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

def check_count(cur, table, expected):
    cur.execute(f"SELECT COUNT(*) FROM {table}")
    count = cur.fetchone()[0]
    if count == expected:
        print(f"PASS: {table} count is {count}")
    else:
        print(f"FAIL: {table} count is {count}, expected {expected}")

def main():
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()
        
        print("Verifying Demo Data Counts...")
        check_count(cur, "Airline", 1)
        check_count(cur, "Airline_Staff", 1) 
        check_count(cur, "Airplane", 3)
        check_count(cur, "Airport", 8)
        check_count(cur, "Customer", 3)
        check_count(cur, "Flight", 6)
        check_count(cur, "Ticket", 12)
        check_count(cur, "Buy", 12)
        check_count(cur, "Review", 4)
        
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    main()
