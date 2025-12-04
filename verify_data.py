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

def main():
    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()
        
        print("Verifying data...")
        
        # Check for new Airline
        cur.execute("SELECT name FROM Airline WHERE name = 'Air France';")
        airline = cur.fetchone()
        if airline:
            print(f"Found Airline: {airline[0]}")
        else:
            print("Error: Airline 'Air France' not found.")
            
        # Check for new Flight
        cur.execute("SELECT flight_number FROM Flight WHERE flight_number = 'AF007';")
        flight = cur.fetchone()
        if flight:
            print(f"Found Flight: {flight[0]}")
        else:
            print("Error: Flight 'AF007' not found.")
            
        # Count total flights
        cur.execute("SELECT COUNT(*) FROM Flight;")
        count = cur.fetchone()[0]
        print(f"Total Flights: {count}")
        
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    main()
