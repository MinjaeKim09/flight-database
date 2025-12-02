# Use Cases and SQL Queries Documentation

This document describes all use cases implemented in the Air Ticket Reservation System and the SQL queries executed for each.

## Public Use Cases (Not Logged In)

### 1. View Public Info - Search Flights

**Description**: All users can search for future flights based on source/destination city/airport and dates.

**Route**: `GET/POST /search`

**SQL Query**:
```sql
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
WHERE f.departure_timestamp > CURRENT_TIMESTAMP
    AND (departure conditions)
    AND (arrival conditions)
    AND (date conditions)
GROUP BY f.airline_name, f.flight_number, f.departure_timestamp,
         f.arrival_timestamp, f.departure_airport, f.arrival_airport,
         dep_airport.city, arr_airport.city, f.base_price, f.status, a.seat_no
ORDER BY f.departure_timestamp
```

**Function**: `search_flights()` in `models.py`

### 2. Register

**Description**: Register as Customer or Airline Staff.

**Route**: `GET/POST /register`

**SQL Queries**:

**Customer Registration**:
```sql
INSERT INTO Customer (email, password, name, address_number, address_street,
                    address_city, address_state, phone_number, passport_number,
                    passport_expiration, passport_country, date_of_birth)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
```

**Staff Registration**:
```sql
INSERT INTO Airline_Staff (username, password, airline_name, first_name,
                          last_name, email, date_of_birth)
VALUES (%s, %s, %s, %s, %s, %s, %s);

INSERT INTO Works (airline_name, username)
VALUES (%s, %s);

INSERT INTO Airline_Staff_Number (username, number)
VALUES (%s, %s)  -- For each phone number
```

**Function**: `register_customer()`, `register_staff()` in `auth.py`

### 3. Login

**Description**: Login as Customer (using email) or Airline Staff (using username).

**Route**: `GET/POST /login`

**SQL Queries**:

**Customer Login**:
```sql
SELECT email, name
FROM Customer
WHERE email = %s AND password = %s
```

**Staff Login**:
```sql
SELECT s.username, s.first_name, s.last_name, s.airline_name
FROM Airline_Staff s
WHERE s.username = %s AND s.password = %s
```

**Function**: `authenticate_customer()`, `authenticate_staff()` in `auth.py`

## Customer Use Cases

### 1. View My Flights

**Description**: View flights purchased by the customer. Default shows future flights only.

**Route**: `GET/POST /customer/flights`

**SQL Query**:
```sql
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
WHERE b.email = %s
    AND (optional filters)
ORDER BY f.departure_timestamp DESC
```

**Function**: `get_customer_flights()` in `models.py`

### 2. Search for Flights

**Description**: Search for future flights (one-way or round-trip).

**Route**: `GET/POST /customer/search`

**SQL Query**: Same as public search flights query (see above)

**Function**: `search_flights()` in `models.py`

### 3. Purchase Tickets

**Description**: Purchase a ticket for a flight. Checks seat availability before purchase.

**Route**: `GET/POST /customer/purchase`

**SQL Queries**:

**Check Seat Availability**:
```sql
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
```

**Insert Ticket**:
```sql
INSERT INTO Ticket (airline_name, flight_number, departure_timestamp)
VALUES (%s, %s, %s)
RETURNING id
```

**Insert Purchase Record**:
```sql
INSERT INTO Buy (id, email, card_number, card_expiration, card_type, card_name, purchase_timestamp)
VALUES (%s, %s, %s, %s, %s, %s, CURRENT_TIMESTAMP)
```

**Function**: `purchase_ticket()` in `models.py`

### 4. Give Ratings and Comments

**Description**: Rate and comment on past flights (flights already taken).

**Route**: `GET/POST /customer/review`

**SQL Queries**:

**Get Past Flights**:
```sql
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
```

**Submit Review** (Insert or Update):
```sql
-- Check if exists
SELECT 1 FROM Review
WHERE email = %s 
    AND airline_name = %s 
    AND flight_number = %s 
    AND departure_timestamp = %s

-- Insert new
INSERT INTO Review (email, airline_name, flight_number, departure_timestamp, rate, comment)
VALUES (%s, %s, %s, %s, %s, %s)

-- Or update existing
UPDATE Review
SET rate = %s, comment = %s
WHERE email = %s 
    AND airline_name = %s 
    AND flight_number = %s 
    AND departure_timestamp = %s
```

**Function**: `get_past_customer_flights()`, `submit_review()` in `models.py`

### 5. Logout

**Description**: Destroy session and logout.

**Route**: `GET /logout`

**Function**: Clears Flask session

## Airline Staff Use Cases

### 1. View Flights

**Description**: View flights for the airline. Default shows future flights for next 30 days.

**Route**: `GET/POST /staff/flights`

**SQL Queries**:

**Get Flights**:
```sql
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
WHERE f.airline_name = %s
    AND (optional filters)
GROUP BY f.airline_name, f.flight_number, f.departure_timestamp,
         f.arrival_timestamp, f.departure_airport, f.arrival_airport,
         dep_airport.city, arr_airport.city, f.base_price, f.status, a.seat_no
ORDER BY f.departure_timestamp
```

**Get Customers for Flight**:
```sql
SELECT c.name, c.email, b.id as ticket_id, b.purchase_timestamp
FROM Buy b
JOIN Ticket t ON b.id = t.id
JOIN Customer c ON b.email = c.email
WHERE t.airline_name = %s 
    AND t.flight_number = %s 
    AND t.departure_timestamp = %s
ORDER BY b.purchase_timestamp
```

**Function**: `get_staff_flights()`, `get_flight_customers()` in `models.py`

### 2. Create New Flights

**Description**: Create a new flight for the airline.

**Route**: `GET/POST /staff/create_flight`

**SQL Query**:
```sql
INSERT INTO Flight (airline_name, flight_number, departure_timestamp, 
                  arrival_timestamp, departure_airport, arrival_airport, 
                  uid, base_price, status)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
```

**Function**: `create_flight()` in `models.py`

### 3. Change Status of Flights

**Description**: Update flight status (on-time/delayed/cancelled).

**Route**: `GET/POST /staff/change_status`

**SQL Query**:
```sql
UPDATE Flight
SET status = %s
WHERE airline_name = %s 
    AND flight_number = %s 
    AND departure_timestamp = %s
```

**Function**: `update_flight_status()` in `models.py`

### 4. Add Airplane

**Description**: Add a new airplane to the airline.

**Route**: `GET/POST /staff/add_airplane`

**SQL Queries**:

**Insert Airplane**:
```sql
INSERT INTO Airplane (airline_name, uid, seat_no, manufacturer, age)
VALUES (%s, %s, %s, %s, %s)
```

**Get All Airplanes** (for confirmation):
```sql
SELECT airline_name, uid, seat_no, manufacturer, age
FROM Airplane
WHERE airline_name = %s
ORDER BY uid
```

**Function**: `add_airplane()`, `get_airline_airplanes()` in `models.py`

### 5. View Flight Ratings

**Description**: View average ratings and all reviews for flights.

**Route**: `GET /staff/ratings`

**SQL Queries**:

**Get Average Ratings**:
```sql
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
```

**Get Reviews for Specific Flight**:
```sql
SELECT r.email, c.name, r.rate, r.comment
FROM Review r
JOIN Customer c ON r.email = c.email
WHERE r.airline_name = %s 
    AND r.flight_number = %s 
    AND r.departure_timestamp = %s
ORDER BY r.rate DESC
```

**Function**: `get_flight_ratings()`, `get_flight_reviews()` in `models.py`

### 6. View Reports

**Description**: View sales reports with total tickets sold and revenue by date range.

**Route**: `GET/POST /staff/reports`

**SQL Queries**:

**Total Sales**:
```sql
SELECT COUNT(b.id) as ticket_count, SUM(f.base_price) as total_revenue
FROM Buy b
JOIN Ticket t ON b.id = t.id
JOIN Flight f ON t.airline_name = f.airline_name 
    AND t.flight_number = f.flight_number 
    AND t.departure_timestamp = f.departure_timestamp
WHERE f.airline_name = %s
    AND (date conditions)
```

**Monthly Breakdown**:
```sql
SELECT DATE_TRUNC('month', b.purchase_timestamp) as month,
       COUNT(b.id) as ticket_count,
       SUM(f.base_price) as revenue
FROM Buy b
JOIN Ticket t ON b.id = t.id
JOIN Flight f ON t.airline_name = f.airline_name 
    AND t.flight_number = f.flight_number 
    AND t.departure_timestamp = f.departure_timestamp
WHERE f.airline_name = %s
    AND (date conditions)
GROUP BY DATE_TRUNC('month', b.purchase_timestamp)
ORDER BY month DESC
```

**Function**: `get_sales_report()` in `models.py`

### 7. Logout

**Description**: Destroy session and logout.

**Route**: `GET /logout`

**Function**: Clears Flask session

## Security Implementation

All queries use parameterized queries (%s placeholders) to prevent SQL injection. All user inputs are sanitized using `sanitize_input()` function to prevent XSS attacks. Session validation is performed on all protected routes using decorators (`@customer_required`, `@staff_required`).

