from datetime import datetime, timedelta
from config import get_db_connection, return_db_connection
from utils import sanitize_input


def search_flights(departure_city=None, departure_airport=None, arrival_city=None, 
                   arrival_airport=None, departure_date=None, return_date=None, 
                   round_trip=False, future_only=True):
    """Search for flights with optional filters."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        # Build WHERE clause dynamically
        conditions = []
        params = []
        
        if future_only:
            conditions.append("f.departure_timestamp > CURRENT_TIMESTAMP")
        
        if departure_airport:
            conditions.append("f.departure_airport = %s")
            params.append(departure_airport.upper())
        elif departure_city:
            conditions.append("dep_airport.city ILIKE %s")
            params.append(f"%{departure_city}%")
        
        if arrival_airport:
            conditions.append("f.arrival_airport = %s")
            params.append(arrival_airport.upper())
        elif arrival_city:
            conditions.append("arr_airport.city ILIKE %s")
            params.append(f"%{arrival_city}%")
        
        if departure_date:
            conditions.append("DATE(f.departure_timestamp) = %s")
            params.append(departure_date)
        
        where_clause = " AND ".join(conditions) if conditions else "1=1"
        
        query = f"""
            SELECT f.airline_name, f.flight_number, f.departure_timestamp, 
                   f.arrival_timestamp, f.departure_airport, f.arrival_airport,
                   dep_airport.city as dep_city, arr_airport.city as arr_city,
                   f.base_price, f.status, a.seat_no,
                   COUNT(t.id) as tickets_sold,
                   (a.seat_no - COUNT(t.id)) as available_seats
            FROM Flight f
            JOIN Airport dep_airport ON f.departure_airport = dep_airport.code
            JOIN Airport arr_airport ON f.arrival_airport = arr_airport.code
            JOIN Airplane a ON f.airline_name = a.airline_name AND f.uid = a.uid
            LEFT JOIN Ticket t ON f.airline_name = t.airline_name 
                AND f.flight_number = t.flight_number 
                AND f.departure_timestamp = t.departure_timestamp
            WHERE {where_clause}
            GROUP BY f.airline_name, f.flight_number, f.departure_timestamp,
                     f.arrival_timestamp, f.departure_airport, f.arrival_airport,
                     dep_airport.city, arr_airport.city, f.base_price, f.status, a.seat_no
            ORDER BY f.departure_timestamp
        """
        
        cur.execute(query, params)
        results = cur.fetchall()
        
        flights = []
        for row in results:
            flights.append({
                'airline_name': row[0],
                'flight_number': row[1],
                'departure_timestamp': row[2],
                'arrival_timestamp': row[3],
                'departure_airport': row[4],
                'arrival_airport': row[5],
                'dep_city': row[6],
                'arr_city': row[7],
                'base_price': float(row[8]),
                'status': row[9],
                'seat_no': row[10],
                'tickets_sold': row[11],
                'available_seats': row[12]
            })
        
        return flights
    finally:
        return_db_connection(conn)


def get_public_flight_status(flight_number, departure_date):
    """Search for flight status by flight number and date."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        query = """
            SELECT f.airline_name, f.flight_number, f.departure_timestamp, 
                   f.arrival_timestamp, f.departure_airport, f.arrival_airport,
                   dep_airport.city as dep_city, arr_airport.city as arr_city,
                   f.base_price, f.status
            FROM Flight f
            JOIN Airport dep_airport ON f.departure_airport = dep_airport.code
            JOIN Airport arr_airport ON f.arrival_airport = arr_airport.code
            WHERE f.flight_number = %s AND DATE(f.departure_timestamp) = %s
            ORDER BY f.departure_timestamp
        """
        
        cur.execute(query, [flight_number, departure_date])
        results = cur.fetchall()
        
        flights = []
        for row in results:
            flights.append({
                'airline_name': row[0],
                'flight_number': row[1],
                'departure_timestamp': row[2],
                'arrival_timestamp': row[3],
                'departure_airport': row[4],
                'arrival_airport': row[5],
                'dep_city': row[6],
                'arr_city': row[7],
                'base_price': float(row[8]),
                'status': row[9]
            })
        
        return flights
    finally:
        return_db_connection(conn)


def get_customer_flights(email, start_date=None, end_date=None, 
                        departure_airport=None, arrival_airport=None, 
                        departure_city=None, arrival_city=None, future_only=True):
    """Get flights purchased by a customer."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        conditions = ["b.email = %s"]
        params = [email]
        
        if future_only:
            conditions.append("f.departure_timestamp > CURRENT_TIMESTAMP")
        
        if start_date:
            conditions.append("DATE(f.departure_timestamp) >= %s")
            params.append(start_date)
        
        if end_date:
            conditions.append("DATE(f.departure_timestamp) <= %s")
            params.append(end_date)
        
        if departure_airport:
            conditions.append("f.departure_airport = %s")
            params.append(departure_airport.upper())
        elif departure_city:
            conditions.append("dep_airport.city ILIKE %s")
            params.append(f"%{departure_city}%")
        
        if arrival_airport:
            conditions.append("f.arrival_airport = %s")
            params.append(arrival_airport.upper())
        elif arrival_city:
            conditions.append("arr_airport.city ILIKE %s")
            params.append(f"%{arrival_city}%")
        
        where_clause = " AND ".join(conditions)
        
        query = f"""
            SELECT f.airline_name, f.flight_number, f.departure_timestamp,
                   f.arrival_timestamp, f.departure_airport, f.arrival_airport,
                   dep_airport.city as dep_city, arr_airport.city as arr_city,
                   f.base_price, f.status, b.id as ticket_id, b.purchase_timestamp
            FROM Buy b
            JOIN Ticket t ON b.id = t.id
            JOIN Flight f ON t.airline_name = f.airline_name 
                AND t.flight_number = f.flight_number 
                AND t.departure_timestamp = f.departure_timestamp
            JOIN Airport dep_airport ON f.departure_airport = dep_airport.code
            JOIN Airport arr_airport ON f.arrival_airport = arr_airport.code
            WHERE {where_clause}
            ORDER BY f.departure_timestamp DESC
        """
        
        cur.execute(query, params)
        results = cur.fetchall()
        
        flights = []
        for row in results:
            flights.append({
                'airline_name': row[0],
                'flight_number': row[1],
                'departure_timestamp': row[2],
                'arrival_timestamp': row[3],
                'departure_airport': row[4],
                'arrival_airport': row[5],
                'dep_city': row[6],
                'arr_city': row[7],
                'base_price': float(row[8]),
                'status': row[9],
                'ticket_id': row[10],
                'purchase_timestamp': row[11]
            })
        
        return flights
    finally:
        return_db_connection(conn)


def check_seat_availability(airline_name, flight_number, departure_timestamp):
    """Check if a flight has available seats."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        query = """
            SELECT a.seat_no, COUNT(t.id) as tickets_sold
            FROM Flight f
            JOIN Airplane a ON f.airline_name = a.airline_name AND f.uid = a.uid
            LEFT JOIN Ticket t ON f.airline_name = t.airline_name 
                AND f.flight_number = t.flight_number 
                AND f.departure_timestamp = t.departure_timestamp
            WHERE f.airline_name = %s 
                AND f.flight_number = %s 
                AND f.departure_timestamp = %s
            GROUP BY a.seat_no
        """
        
        cur.execute(query, [airline_name, flight_number, departure_timestamp])
        result = cur.fetchone()
        
        if result:
            seat_no = result[0]
            tickets_sold = result[1]
            return seat_no - tickets_sold > 0, seat_no - tickets_sold
        return False, 0
    finally:
        return_db_connection(conn)


def purchase_ticket(email, airline_name, flight_number, departure_timestamp,
                   card_number, card_expiration, card_type, card_name):
    """Purchase a ticket for a flight."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        # Check seat availability
        available, seats_left = check_seat_availability(airline_name, flight_number, departure_timestamp)
        if not available:
            return False, "No seats available"
        
        # Insert ticket
        ticket_query = """
            INSERT INTO Ticket (airline_name, flight_number, departure_timestamp)
            VALUES (%s, %s, %s)
            RETURNING id
        """
        cur.execute(ticket_query, [airline_name, flight_number, departure_timestamp])
        ticket_id = cur.fetchone()[0]
        
        # Insert purchase record
        purchase_query = """
            INSERT INTO Buy (id, email, card_number, card_expiration, card_type, card_name, purchase_timestamp)
            VALUES (%s, %s, %s, %s, %s, %s, CURRENT_TIMESTAMP)
        """
        cur.execute(purchase_query, [ticket_id, email, card_number, card_expiration, card_type, card_name])
        
        conn.commit()
        return True, ticket_id
    except Exception as e:
        conn.rollback()
        return False, str(e)
    finally:
        return_db_connection(conn)


def get_staff_flights(airline_name, start_date=None, end_date=None,
                     departure_airport=None, arrival_airport=None,
                     departure_city=None, arrival_city=None, future_only=True):
    """Get flights for an airline staff member."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        conditions = ["f.airline_name = %s"]
        params = [airline_name]
        
        if future_only:
            # Default: next 30 days
            conditions.append("f.departure_timestamp >= CURRENT_TIMESTAMP")
            conditions.append("f.departure_timestamp <= CURRENT_TIMESTAMP + INTERVAL '30 days'")
        else:
            if start_date:
                conditions.append("DATE(f.departure_timestamp) >= %s")
                params.append(start_date)
            
            if end_date:
                conditions.append("DATE(f.departure_timestamp) <= %s")
                params.append(end_date)
        
        if departure_airport:
            conditions.append("f.departure_airport = %s")
            params.append(departure_airport.upper())
        elif departure_city:
            conditions.append("dep_airport.city ILIKE %s")
            params.append(f"%{departure_city}%")
        
        if arrival_airport:
            conditions.append("f.arrival_airport = %s")
            params.append(arrival_airport.upper())
        elif arrival_city:
            conditions.append("arr_airport.city ILIKE %s")
            params.append(f"%{arrival_city}%")
        
        where_clause = " AND ".join(conditions)
        
        query = f"""
            SELECT f.airline_name, f.flight_number, f.departure_timestamp,
                   f.arrival_timestamp, f.departure_airport, f.arrival_airport,
                   dep_airport.city as dep_city, arr_airport.city as arr_city,
                   f.base_price, f.status, a.seat_no,
                   COUNT(t.id) as tickets_sold
            FROM Flight f
            JOIN Airport dep_airport ON f.departure_airport = dep_airport.code
            JOIN Airport arr_airport ON f.arrival_airport = arr_airport.code
            JOIN Airplane a ON f.airline_name = a.airline_name AND f.uid = a.uid
            LEFT JOIN Ticket t ON f.airline_name = t.airline_name 
                AND f.flight_number = t.flight_number 
                AND f.departure_timestamp = t.departure_timestamp
            WHERE {where_clause}
            GROUP BY f.airline_name, f.flight_number, f.departure_timestamp,
                     f.arrival_timestamp, f.departure_airport, f.arrival_airport,
                     dep_airport.city, arr_airport.city, f.base_price, f.status, a.seat_no
            ORDER BY f.departure_timestamp
        """
        
        cur.execute(query, params)
        results = cur.fetchall()
        
        flights = []
        for row in results:
            flights.append({
                'airline_name': row[0],
                'flight_number': row[1],
                'departure_timestamp': row[2],
                'arrival_timestamp': row[3],
                'departure_airport': row[4],
                'arrival_airport': row[5],
                'dep_city': row[6],
                'arr_city': row[7],
                'base_price': float(row[8]),
                'status': row[9],
                'seat_no': row[10],
                'tickets_sold': row[11]
            })
        
        return flights
    finally:
        return_db_connection(conn)


def get_flight_customers(airline_name, flight_number, departure_timestamp):
    """Get all customers who purchased tickets for a flight."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        query = """
            SELECT c.name, c.email, b.id as ticket_id, b.purchase_timestamp
            FROM Buy b
            JOIN Ticket t ON b.id = t.id
            JOIN Customer c ON b.email = c.email
            WHERE t.airline_name = %s 
                AND t.flight_number = %s 
                AND t.departure_timestamp = %s
            ORDER BY b.purchase_timestamp
        """
        
        cur.execute(query, [airline_name, flight_number, departure_timestamp])
        results = cur.fetchall()
        
        customers = []
        for row in results:
            customers.append({
                'name': row[0],
                'email': row[1],
                'ticket_id': row[2],
                'purchase_timestamp': row[3]
            })
        
        return customers
    finally:
        return_db_connection(conn)


def create_flight(airline_name, flight_number, departure_timestamp, arrival_timestamp,
                  departure_airport, arrival_airport, uid, base_price, status='on-time'):
    """Create a new flight."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        query = """
            INSERT INTO Flight (airline_name, flight_number, departure_timestamp, 
                              arrival_timestamp, departure_airport, arrival_airport, 
                              uid, base_price, status)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        
        cur.execute(query, [airline_name, flight_number, departure_timestamp,
                           arrival_timestamp, departure_airport, arrival_airport,
                           uid, base_price, status])
        conn.commit()
        return True, "Flight created successfully"
    except Exception as e:
        conn.rollback()
        return False, str(e)
    finally:
        return_db_connection(conn)


def update_flight_status(airline_name, flight_number, departure_timestamp, status):
    """Update flight status."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        query = """
            UPDATE Flight
            SET status = %s
            WHERE airline_name = %s 
                AND flight_number = %s 
                AND departure_timestamp = %s
        """
        
        cur.execute(query, [status, airline_name, flight_number, departure_timestamp])
        conn.commit()
        return True, "Flight status updated successfully"
    except Exception as e:
        conn.rollback()
        return False, str(e)
    finally:
        return_db_connection(conn)


def add_airplane(airline_name, uid, seat_no, manufacturer, age):
    """Add a new airplane."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        query = """
            INSERT INTO Airplane (airline_name, uid, seat_no, manufacturer, age)
            VALUES (%s, %s, %s, %s, %s)
        """
        
        cur.execute(query, [airline_name, uid, seat_no, manufacturer, age])
        conn.commit()
        return True, "Airplane added successfully"
    except Exception as e:
        conn.rollback()
        return False, str(e)
    finally:
        return_db_connection(conn)


def get_airline_airplanes(airline_name):
    """Get all airplanes owned by an airline."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        query = """
            SELECT airline_name, uid, seat_no, manufacturer, age
            FROM Airplane
            WHERE airline_name = %s
            ORDER BY uid
        """
        
        cur.execute(query, [airline_name])
        results = cur.fetchall()
        
        airplanes = []
        for row in results:
            airplanes.append({
                'airline_name': row[0],
                'uid': row[1],
                'seat_no': row[2],
                'manufacturer': row[3],
                'age': row[4]
            })
        
        return airplanes
    finally:
        return_db_connection(conn)


def get_past_customer_flights(email):
    """Get past flights for a customer (for rating)."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        query = """
            SELECT f.airline_name, f.flight_number, f.departure_timestamp,
                   f.arrival_timestamp, f.departure_airport, f.arrival_airport,
                   dep_airport.city as dep_city, arr_airport.city as arr_city
            FROM Buy b
            JOIN Ticket t ON b.id = t.id
            JOIN Flight f ON t.airline_name = f.airline_name 
                AND t.flight_number = f.flight_number 
                AND t.departure_timestamp = f.departure_timestamp
            JOIN Airport dep_airport ON f.departure_airport = dep_airport.code
            JOIN Airport arr_airport ON f.arrival_airport = arr_airport.code
            WHERE b.email = %s AND f.departure_timestamp < CURRENT_TIMESTAMP
            ORDER BY f.departure_timestamp DESC
        """
        
        cur.execute(query, [email])
        results = cur.fetchall()
        
        flights = []
        for row in results:
            flights.append({
                'airline_name': row[0],
                'flight_number': row[1],
                'departure_timestamp': row[2],
                'arrival_timestamp': row[3],
                'departure_airport': row[4],
                'arrival_airport': row[5],
                'dep_city': row[6],
                'arr_city': row[7]
            })
        
        return flights
    finally:
        return_db_connection(conn)


def submit_review(email, airline_name, flight_number, departure_timestamp, rate, comment):
    """Submit or update a review for a flight."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        # Check if review already exists
        check_query = """
            SELECT 1 FROM Review
            WHERE email = %s 
                AND airline_name = %s 
                AND flight_number = %s 
                AND departure_timestamp = %s
        """
        cur.execute(check_query, [email, airline_name, flight_number, departure_timestamp])
        
        if cur.fetchone():
            # Update existing review
            query = """
                UPDATE Review
                SET rate = %s, comment = %s
                WHERE email = %s 
                    AND airline_name = %s 
                    AND flight_number = %s 
                    AND departure_timestamp = %s
            """
            cur.execute(query, [rate, comment, email, airline_name, flight_number, departure_timestamp])
        else:
            # Insert new review
            query = """
                INSERT INTO Review (email, airline_name, flight_number, departure_timestamp, rate, comment)
                VALUES (%s, %s, %s, %s, %s, %s)
            """
            cur.execute(query, [email, airline_name, flight_number, departure_timestamp, rate, comment])
        
        conn.commit()
        return True, "Review submitted successfully"
    except Exception as e:
        conn.rollback()
        return False, str(e)
    finally:
        return_db_connection(conn)


def get_flight_ratings(airline_name):
    """Get average ratings for all flights of an airline."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        query = """
            SELECT f.airline_name, f.flight_number, f.departure_timestamp,
                   f.departure_airport, f.arrival_airport,
                   dep_airport.city as dep_city, arr_airport.city as arr_city,
                   COALESCE(AVG(r.rate), 0) as avg_rating,
                   COUNT(r.rate) as review_count
            FROM Flight f
            JOIN Airport dep_airport ON f.departure_airport = dep_airport.code
            JOIN Airport arr_airport ON f.arrival_airport = arr_airport.code
            LEFT JOIN Review r ON f.airline_name = r.airline_name 
                AND f.flight_number = r.flight_number 
                AND f.departure_timestamp = r.departure_timestamp
            WHERE f.airline_name = %s
            GROUP BY f.airline_name, f.flight_number, f.departure_timestamp,
                     f.departure_airport, f.arrival_airport,
                     dep_airport.city, arr_airport.city
            ORDER BY f.departure_timestamp DESC
        """
        
        cur.execute(query, [airline_name])
        results = cur.fetchall()
        
        flights = []
        for row in results:
            flights.append({
                'airline_name': row[0],
                'flight_number': row[1],
                'departure_timestamp': row[2],
                'departure_airport': row[3],
                'arrival_airport': row[4],
                'dep_city': row[5],
                'arr_city': row[6],
                'avg_rating': float(row[7]) if row[7] else 0.0,
                'review_count': row[8]
            })
        
        return flights
    finally:
        return_db_connection(conn)


def get_flight_reviews(airline_name, flight_number, departure_timestamp):
    """Get all reviews for a specific flight."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        query = """
            SELECT r.email, c.name, r.rate, r.comment
            FROM Review r
            JOIN Customer c ON r.email = c.email
            WHERE r.airline_name = %s 
                AND r.flight_number = %s 
                AND r.departure_timestamp = %s
            ORDER BY r.rate DESC
        """
        
        cur.execute(query, [airline_name, flight_number, departure_timestamp])
        results = cur.fetchall()
        
        reviews = []
        for row in results:
            reviews.append({
                'email': row[0],
                'name': row[1],
                'rate': row[2],
                'comment': row[3]
            })
        
        return reviews
    finally:
        return_db_connection(conn)


def get_sales_report(airline_name, start_date=None, end_date=None):
    """Get sales report for an airline."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        conditions = ["f.airline_name = %s"]
        params = [airline_name]
        
        if start_date:
            conditions.append("DATE(b.purchase_timestamp) >= %s")
            params.append(start_date)
        
        if end_date:
            conditions.append("DATE(b.purchase_timestamp) <= %s")
            params.append(end_date)
        
        where_clause = " AND ".join(conditions)
        
        # Total sales
        total_query = f"""
            SELECT COUNT(b.id) as ticket_count, SUM(f.base_price) as total_revenue
            FROM Buy b
            JOIN Ticket t ON b.id = t.id
            JOIN Flight f ON t.airline_name = f.airline_name 
                AND t.flight_number = f.flight_number 
                AND t.departure_timestamp = f.departure_timestamp
            WHERE {where_clause}
        """
        
        cur.execute(total_query, params)
        total_result = cur.fetchone()
        
        # Monthly breakdown
        monthly_query = f"""
            SELECT DATE_TRUNC('month', b.purchase_timestamp) as month,
                   COUNT(b.id) as ticket_count,
                   SUM(f.base_price) as revenue
            FROM Buy b
            JOIN Ticket t ON b.id = t.id
            JOIN Flight f ON t.airline_name = f.airline_name 
                AND t.flight_number = f.flight_number 
                AND t.departure_timestamp = f.departure_timestamp
            WHERE {where_clause}
            GROUP BY DATE_TRUNC('month', b.purchase_timestamp)
            ORDER BY month DESC
        """
        
        cur.execute(monthly_query, params)
        monthly_results = cur.fetchall()
        
        monthly_data = []
        for row in monthly_results:
            monthly_data.append({
                'month': row[0].strftime('%Y-%m'),
                'month_display': row[0].strftime('%B %Y'),
                'ticket_count': row[1],
                'revenue': float(row[2]) if row[2] else 0.0
            })
        
        return {
            'total_tickets': total_result[0] if total_result[0] else 0,
            'total_revenue': float(total_result[1]) if total_result[1] else 0.0,
            'monthly_data': monthly_data
        }
    finally:
        return_db_connection(conn)


def get_airports():
    """Get all airports."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        query = "SELECT code, city, country FROM Airport ORDER BY code"
        cur.execute(query)
        results = cur.fetchall()
        
        airports = []
        for row in results:
            airports.append({
                'code': row[0],
                'city': row[1],
                'country': row[2]
            })
        
        return airports
    finally:
        return_db_connection(conn)


def get_airlines():
    """Get all airlines."""
    conn = get_db_connection()
    try:
        cur = conn.cursor()
        
        query = "SELECT name FROM Airline ORDER BY name"
        cur.execute(query)
        results = cur.fetchall()
        
        return [row[0] for row in results]
    finally:
        return_db_connection(conn)
