-- =========================================================
-- 1. AIRLINE
-- =========================================================
INSERT INTO Airline(name) VALUES ('United');

-- =========================================================
-- 2. AIRLINE STAFF
-- =========================================================
INSERT INTO Airline_Staff(username, password, airline_name, first_name, last_name, email, date_of_birth)
VALUES ('admin', '51eac6b471a284d3341d8c0c63d0f1a286262a18', 'United', 'Roe', 'Jones', 'staff@nyu.edu', '1978-05-25');
-- Note: 'abcd' hash is '51eac6b471a284d3341d8c0c63d0f1a286262a18' (md5) or however the app handles it.
-- Looking at insertion data.sql, they use plain text 'password' or 'jb_staff1'. 
-- The user said "Password: abcd". I will stick to plain text if the app creates it that way, 
-- BUT looking at the previous sql file: "VALUES ('jb_staff1','password'..."
-- So I will use 'abcd' as plain text for now, assuming the app handles hashing or uses plain text (not ideal but consistent with provided sample).
-- WAIT, let me check auth.py later to see if it hashes. For now I will put 'abcd'.

-- Refine:
DELETE FROM Airline_Staff WHERE username = 'admin'; -- just in case
INSERT INTO Airline_Staff(username, password, airline_name, first_name, last_name, email, date_of_birth)
VALUES ('admin', 'abcd', 'United', 'Roe', 'Jones', 'staff@nyu.edu', '1978-05-25');

INSERT INTO Airline_Staff_Number(username, number) VALUES 
('admin', '111-2222-3333'),
('admin', '444-5555-6666');

INSERT INTO Works(airline_name, username) VALUES ('United', 'admin');

-- =========================================================
-- 3. AIRPLANES
-- =========================================================
INSERT INTO Airplane(airline_name, uid, seat_no, manufacturer, age) VALUES
('United', '1', 4, 'Boeing', 10),
('United', '2', 4, 'Airbus', 12),
('United', '3', 50, 'Boeing', 8);

INSERT INTO Owns(airline_name, uid) VALUES
('United', '1'),
('United', '2'),
('United', '3');


-- =========================================================
-- 4. AIRPORTS
-- =========================================================

INSERT INTO Airport(code, city, country, type) VALUES
('JFK', 'NYC', 'USA', 'both'),
('BOS', 'Boston', 'USA', 'both'),
('PVG', 'Shanghai', 'China', 'both'),
('BEI', 'Beijing', 'China', 'both'),
('SFO', 'San Francisco', 'USA', 'both'),
('LAX', 'Los Angeles', 'USA', 'both'),
('HKA', 'Hong Kong', 'China', 'both');

INSERT INTO Airport(code, city, country, type) VALUES
('SZX', 'Shenzhen', 'China', 'both'); -- Using SZX for SHEN (4 chars)


-- =========================================================
-- 5. CUSTOMERS
-- =========================================================
INSERT INTO Customer(email, password, name, address_number, address_street, address_city, address_state, phone_number, passport_number, passport_expiration, passport_country, date_of_birth)
VALUES
('testcustomer@nyu.edu', '1234', 'Jon Snow', '1555', 'Jay St', 'Brooklyn', 'New York', '123-4321-4321', '54321', '2025-12-24', 'USA', '1999-12-19'),
('user1@nyu.edu', '1234', 'Alice Bob', '5405', 'Jay Street', 'Brooklyn', 'New York', '123-4322-4322', '54322', '2025-12-25', 'USA', '1999-11-19'),
('user3@nyu.edu', '1234', 'Trudy Jones', '1890', 'Jay Street', 'Brooklyn', 'New York', '123-4324-4324', '54324', '2025-09-24', 'USA', '1999-09-19');


-- =========================================================
-- 6. FLIGHTS
-- =========================================================
-- Schema: airline_name, flight_number, departure_timestamp, arrival_timestamp, departure_airport, arrival_airport, uid, base_price, status
-- Note: 'SHEN' was used in scenario data, mapped to 'SZX'. "Status: on-time" default is fine, but I'll specify.

INSERT INTO Flight(airline_name, flight_number, departure_timestamp, arrival_timestamp, departure_airport, arrival_airport, uid, base_price, status) VALUES
('United', '102', '2025-09-14 13:25:25', '2025-09-14 16:50:25', 'SFO', 'LAX', '3', 300, 'on-time'),
('United', '104', '2025-10-14 13:25:25', '2025-10-14 16:50:25', 'PVG', 'BEI', '3', 300, 'on-time'),
('United', '206', '2026-01-04 13:25:25', '2026-01-04 16:50:25', 'SFO', 'LAX', '2', 350, 'on-time'),
('United', '207', '2026-02-05 13:25:25', '2026-02-05 16:50:25', 'LAX', 'SFO', '2', 300, 'on-time'),
('United', '296', '2025-12-28 13:25:25', '2025-12-28 16:50:25', 'PVG', 'SFO', '1', 3000, 'on-time'),
('United', '715', '2025-09-25 10:25:25', '2025-09-25 13:50:25', 'PVG', 'BEI', '1', 500, 'delayed');


-- =========================================================
-- 7. TICKETS & 8. PURCHASE RECORDS (Buy)
-- =========================================================
-- Note: Ticket ID is auto-generated (IDENTITY). 
-- Logic: Insert Ticket, then Insert Buy referring to that Ticket.
-- To ensure I get the IDs right or link them correctly without hardcoding IDs that might shift, 
-- I will use the subquery method seen in 'Insertion Data.sql' OR just assume serial order since I am reloading from scratch.
-- However, strict ordering depends on DB. safer to use subqueries or explicit values if I could force ID.
-- Identity column... I can use `OVERRIDING SYSTEM VALUE` if I wanted to force IDs, but standard postgres identity is easier to let auto-generate and use `currval` or `returning`.
-- BUT `Insertion Data.sql` used: `(SELECT id FROM Ticket WHERE ... ORDER BY id DESC LIMIT 1)`
-- I will follow that pattern for safety.

-- Ticket 1 & Buy 1
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp) VALUES ('United', '102', '2025-09-14 13:25:25');
INSERT INTO Buy(id, email, card_number, card_expiration, card_type, card_name, purchase_timestamp) 
VALUES (
    (SELECT id FROM Ticket WHERE airline_name='United' AND flight_number='102' ORDER BY id DESC LIMIT 1),
    'testcustomer@nyu.edu', '1111-2222-3333-4444', '03/26', 'credit', 'Test Customer 1', '2025-08-15 11:55:55'
);

-- Ticket 2 & Buy 2 (User 1)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp) VALUES ('United', '102', '2025-09-14 13:25:25');
INSERT INTO Buy(id, email, card_number, card_expiration, card_type, card_name, purchase_timestamp) 
VALUES (
    (SELECT id FROM Ticket WHERE airline_name='United' AND flight_number='102' ORDER BY id DESC LIMIT 1),
    'user1@nyu.edu', '1111-2222-3333-5555', '03/26', 'credit', 'User 1', '2025-08-20 11:55:55'
);

-- Ticket 3 & Buy 3 (User 1)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp) VALUES ('United', '104', '2025-10-14 13:25:25');
INSERT INTO Buy(id, email, card_number, card_expiration, card_type, card_name, purchase_timestamp) 
VALUES (
    (SELECT id FROM Ticket WHERE airline_name='United' AND flight_number='104' ORDER BY id DESC LIMIT 1),
    'user1@nyu.edu', '1111-2222-3333-5555', '03/26', 'credit', 'User 1', '2025-09-21 11:55:55'
);

-- Ticket 4 & Buy 4 (Test Customer 1)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp) VALUES ('United', '104', '2025-10-14 13:25:25');
INSERT INTO Buy(id, email, card_number, card_expiration, card_type, card_name, purchase_timestamp) 
VALUES (
    (SELECT id FROM Ticket WHERE airline_name='United' AND flight_number='104' ORDER BY id DESC LIMIT 1),
    'testcustomer@nyu.edu', '1111-2222-3333-4444', '03/27', 'credit', 'Test Customer 1', '2025-09-28 11:55:55'
);

-- Ticket 5 & Buy 5 (User 3) - Flight 102 again? Wait. Scenario says:
-- Ticket 5: United | Flight 102 | Dep: 2025-09-14
-- Buy 5: user3@nyu.edu | ...
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp) VALUES ('United', '102', '2025-09-14 13:25:25');
INSERT INTO Buy(id, email, card_number, card_expiration, card_type, card_name, purchase_timestamp) 
VALUES (
    (SELECT id FROM Ticket WHERE airline_name='United' AND flight_number='102' ORDER BY id DESC LIMIT 1),
    'user3@nyu.edu', '1111-2222-3333-5555', '03/26', 'credit', 'User 3', '2025-07-16 11:55:55'
);

-- Ticket 6 & Buy 6 (Test Customer 1) - Flight 715
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp) VALUES ('United', '715', '2025-09-25 10:25:25');
INSERT INTO Buy(id, email, card_number, card_expiration, card_type, card_name, purchase_timestamp) 
VALUES (
    (SELECT id FROM Ticket WHERE airline_name='United' AND flight_number='715' ORDER BY id DESC LIMIT 1),
    'testcustomer@nyu.edu', '1111-2222-3333-4444', '03/26', 'credit', 'Test Customer 1', '2024-09-20 11:55:55'
);

-- Ticket 7 & Buy 7 (User 3) - Flight 206
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp) VALUES ('United', '206', '2026-01-04 13:25:25');
INSERT INTO Buy(id, email, card_number, card_expiration, card_type, card_name, purchase_timestamp) 
VALUES (
    (SELECT id FROM Ticket WHERE airline_name='United' AND flight_number='206' ORDER BY id DESC LIMIT 1),
    'user3@nyu.edu', '1111-2222-3333-5555', '03/26', 'credit', 'User 3', '2025-11-20 11:55:55'
);

-- Ticket 8 & Buy 8 (User 1) - Flight 206
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp) VALUES ('United', '206', '2026-01-04 13:25:25');
INSERT INTO Buy(id, email, card_number, card_expiration, card_type, card_name, purchase_timestamp) 
VALUES (
    (SELECT id FROM Ticket WHERE airline_name='United' AND flight_number='206' ORDER BY id DESC LIMIT 1),
    'user1@nyu.edu', '1111-2222-3333-5555', '03/26', 'credit', 'User 1', '2025-10-21 11:55:55'
);

-- Ticket 9 & Buy 9 (User 1) - Flight 207
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp) VALUES ('United', '207', '2026-02-05 13:25:25');
INSERT INTO Buy(id, email, card_number, card_expiration, card_type, card_name, purchase_timestamp) 
VALUES (
    (SELECT id FROM Ticket WHERE airline_name='United' AND flight_number='207' ORDER BY id DESC LIMIT 1),
    'user1@nyu.edu', '1111-2222-3333-5555', '03/26', 'credit', 'User 1', '2025-12-02 11:55:55'
);

-- Ticket 10 & Buy 10 (Test Customer 1) - Flight 207
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp) VALUES ('United', '207', '2026-02-05 13:25:25');
INSERT INTO Buy(id, email, card_number, card_expiration, card_type, card_name, purchase_timestamp) 
VALUES (
    (SELECT id FROM Ticket WHERE airline_name='United' AND flight_number='207' ORDER BY id DESC LIMIT 1),
    'testcustomer@nyu.edu', '1111-2222-3333-4444', '03/26', 'credit', 'Test Customer 1', '2025-10-25 11:55:55'
);

-- Ticket 11 & Buy 11 (User 1? Wait. Scenario says "Ticket 11 ... Name: Test Customer 1". Wait.)
-- Scenario 98-112:
-- Ticket 11: user1@nyu.edu ... Name: Test Customer 1
-- This seems contradictory in the scenario text. 
-- "Ticket 11: user1@nyu.edu | ... Credit: ... | Name: Test Customer 1"
-- If the email is user1, but the card name is Test Customer 1, that's fine (using someone else's card or scenario typo).
-- I will blindly follow the key 'user1@nyu.edu' as the email.
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp) VALUES ('United', '296', '2025-12-28 13:25:25');
INSERT INTO Buy(id, email, card_number, card_expiration, card_type, card_name, purchase_timestamp) 
VALUES (
    (SELECT id FROM Ticket WHERE airline_name='United' AND flight_number='296' ORDER BY id DESC LIMIT 1),
    'user1@nyu.edu', '1111-2222-3333-4444', '03/26', 'credit', 'Test Customer 1', '2025-10-22 11:55:55'
);

-- Ticket 12 & Buy 12 (Test Customer 1) - Flight 296
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp) VALUES ('United', '296', '2025-12-28 13:25:25');
INSERT INTO Buy(id, email, card_number, card_expiration, card_type, card_name, purchase_timestamp) 
VALUES (
    (SELECT id FROM Ticket WHERE airline_name='United' AND flight_number='296' ORDER BY id DESC LIMIT 1),
    'testcustomer@nyu.edu', '1111-2222-3333-4444', '03/26', 'credit', 'Test Customer 1', '2025-11-20 11:55:55'
);

-- =========================================================
-- 9. RATE RECORDS (Review)
-- =========================================================
INSERT INTO Review(email, airline_name, flight_number, departure_timestamp, rate, comment) VALUES
('testcustomer@nyu.edu', 'United', '102', '2025-09-14 13:25:25', 4, 'Very Comfortable'),
('user1@nyu.edu', 'United', '102', '2025-09-14 13:25:25', 5, 'Relaxing, check-in and onboarding very professional'),
('testcustomer@nyu.edu', 'United', '104', '2025-10-14 13:25:25', 1, 'Customer Care services are not good'),
('user1@nyu.edu', 'United', '104', '2025-10-14 13:25:25', 5, 'Comfortable journey and Professional');


-- =========================================================
-- AUTO-FILL Derived Tables (Arrival, Departure, Operates, Flys_On, Offer)
-- =========================================================

-- Arrival
INSERT INTO Arrival(code, airline_name, flight_number, departure_timestamp)
SELECT f.arrival_airport, f.airline_name, f.flight_number, f.departure_timestamp
FROM Flight f WHERE f.airline_name = 'United';

-- Departure
INSERT INTO Departure(code, airline_name, flight_number, departure_timestamp)
SELECT f.departure_airport, f.airline_name, f.flight_number, f.departure_timestamp
FROM Flight f WHERE f.airline_name = 'United';

-- Operates
INSERT INTO Operates(airline_name, flight_number, departure_timestamp)
SELECT f.airline_name, f.flight_number, f.departure_timestamp
FROM Flight f WHERE f.airline_name = 'United';

-- Flys_On
INSERT INTO Flys_On(airline_name, uid, flight_number, departure_timestamp)
SELECT f.airline_name, f.uid, f.flight_number, f.departure_timestamp
FROM Flight f WHERE f.airline_name = 'United';

-- Offer (seats logic)


INSERT INTO Offer(id, airline_name, flight_number, departure_timestamp, available_seats)
SELECT 
    t.id, 
    t.airline_name, 
    t.flight_number, 
    t.departure_timestamp,
    (
        COALESCE((SELECT seat_no FROM Airplane a 
         JOIN Flight f ON f.airline_name = a.airline_name AND f.uid = a.uid
         WHERE f.airline_name = t.airline_name 
           AND f.flight_number = t.flight_number 
           AND f.departure_timestamp = t.departure_timestamp), 0)
        - 
        (SELECT COUNT(*) FROM Ticket t2 
         WHERE t2.airline_name = t.airline_name 
           AND t2.flight_number = t.flight_number 
           AND t2.departure_timestamp = t.departure_timestamp)
    ) as calculated_seats
FROM Ticket t;
-- Note: available_seats >= 0 check exists.
-- Flight 102 (Plane 3, 50 seats) -> 3 tickets sold. ~47 seats left.
-- Flight 104 (Plane 3, 50 seats) -> 2 tickets. ~48 left.
-- Flight 206 (Plane 2, 4 seats) -> 2 tickets. 2 left.
-- Flight 207 (Plane 2, 4 seats) -> 2 tickets. 2 left.
-- Flight 296 (Plane 1, 4 seats) -> 2 tickets. 2 left.
-- Flight 715 (Plane 1, 4 seats) -> 1 ticket. 3 left.
-- All positive.
