from functools import wraps
from flask import session, redirect, url_for, request
from config import get_db_connection, return_db_connection
from utils import hash_password


def authenticate_customer(email, password):
    """Authenticate a customer using email and password."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        password_hash = hash_password(password)
        
        query = """
            SELECT email, name
            FROM Customer
            WHERE LOWER(email) = LOWER(%s) AND password = %s
        """
        
        cur.execute(query, [email, password_hash])
        result = cur.fetchone()
        
        if result:
            return {
                'email': result[0],
                'name': result[1],
                'user_type': 'customer'
            }
        return None
    finally:
        return_db_connection(conn)


def authenticate_staff(username, password):
    """Authenticate airline staff using username and password."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        password_hash = hash_password(password)
        
        query = """
            SELECT s.username, s.first_name, s.last_name, s.airline_name
            FROM Airline_Staff s
            WHERE s.username = %s AND s.password = %s
        """
        
        cur.execute(query, [username, password_hash])
        result = cur.fetchone()
        
        if result:
            return {
                'username': result[0],
                'first_name': result[1],
                'last_name': result[2],
                'airline_name': result[3],
                'user_type': 'staff'
            }
        return None
    finally:
        return_db_connection(conn)


def register_customer(email, password, name, address_number, address_street,
                      address_city, address_state, phone_number, passport_number,
                      passport_expiration, passport_country, date_of_birth):
    """Register a new customer."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        password_hash = hash_password(password)
        
        query = """
            INSERT INTO Customer (email, password, name, address_number, address_street,
                                address_city, address_state, phone_number, passport_number,
                                passport_expiration, passport_country, date_of_birth)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        
        cur.execute(query, [email, password_hash, name, address_number, address_street,
                           address_city, address_state, phone_number, passport_number,
                           passport_expiration, passport_country, date_of_birth])
        conn.commit()
        return True, "Customer registered successfully"
    except Exception as e:
        conn.rollback()
        return False, str(e)
    finally:
        return_db_connection(conn)


def register_staff(username, password, airline_name, first_name, last_name,
                  email, date_of_birth, phone_numbers=None):
    """Register a new airline staff member."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        password_hash = hash_password(password)
        
        # Insert staff
        staff_query = """
            INSERT INTO Airline_Staff (username, password, airline_name, first_name,
                                      last_name, email, date_of_birth)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        
        cur.execute(staff_query, [username, password_hash, airline_name, first_name,
                                 last_name, email, date_of_birth])
        
        # Insert into Works table
        works_query = """
            INSERT INTO Works (airline_name, username)
            VALUES (%s, %s)
        """
        cur.execute(works_query, [airline_name, username])
        
        # Insert phone numbers if provided
        if phone_numbers:
            phone_query = """
                INSERT INTO Airline_Staff_Number (username, number)
                VALUES (%s, %s)
            """
            for phone in phone_numbers:
                if phone.strip():
                    cur.execute(phone_query, [username, phone.strip()])
        
        conn.commit()
        return True, "Staff registered successfully"
    except Exception as e:
        conn.rollback()
        return False, str(e)
    finally:
        return_db_connection(conn)


def login_required(f):
    """Decorator to require login for a route."""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_type' not in session:
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function


def customer_required(f):
    """Decorator to require customer login for a route."""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_type' not in session or session['user_type'] != 'customer':
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function


def staff_required(f):
    """Decorator to require staff login for a route."""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_type' not in session or session['user_type'] != 'staff':
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function


def verify_staff_airline(airline_name):
    """Verify that the logged-in staff member works for the specified airline."""
    if 'user_type' not in session or session['user_type'] != 'staff':
        return False
    return session.get('airline_name') == airline_name

