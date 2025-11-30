import os
import psycopg2
from psycopg2 import pool
from dotenv import load_dotenv

load_dotenv()

# Database configuration from environment variables
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432'),
    'database': os.getenv('DB_NAME', 'airline_db'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '')
}

# Secret key for Flask sessions
SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')

# Connection pool
connection_pool = None


def init_db_pool():
    """Initialize database connection pool."""
    global connection_pool
    try:
        database_url = os.getenv('DATABASE_URL')
        if database_url:
            # Use the connection string provided by the host (e.g. Render)
            connection_pool = psycopg2.pool.SimpleConnectionPool(
                1, 20,
                dsn=database_url
            )
        else:
            # Use local configuration
            connection_pool = psycopg2.pool.SimpleConnectionPool(
                1, 20,
                host=DB_CONFIG['host'],
                port=DB_CONFIG['port'],
                database=DB_CONFIG['database'],
                user=DB_CONFIG['user'],
                password=DB_CONFIG['password']
            )
            
        if connection_pool:
            print("Database connection pool created successfully")
    except (Exception, psycopg2.Error) as error:
        print(f"Error while connecting to PostgreSQL: {error}")
        raise


def get_db_connection():
    """Get a database connection from the pool."""
    if connection_pool is None:
        init_db_pool()
    return connection_pool.getconn()


def return_db_connection(conn):
    """Return a database connection to the pool."""
    if connection_pool:
        connection_pool.putconn(conn)


def close_db_pool():
    """Close all database connections in the pool."""
    if connection_pool:
        connection_pool.closeall()

