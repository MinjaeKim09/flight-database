-- =========================================================
-- 1) MORE AIRLINES
-- =========================================================
INSERT INTO Airline(name) VALUES
  ('Delta Air Lines'),
  ('United Airlines'),
  ('American Airlines'),
  ('Air France');

-- =========================================================
-- 2) MORE AIRPORTS
-- =========================================================
INSERT INTO Airport(code, city, country, type) VALUES
  ('LAX','Los Angeles','USA','both'),
  ('SFO','San Francisco','USA','both'),
  ('BOS','Boston','USA','domestic'),
  ('MIA','Miami','USA','both'),
  ('ATL','Atlanta','USA','both'),
  ('ORD','Chicago','USA','both'),
  ('LHR','London','UK','international'),
  ('CDG','Paris','France','international');

-- =========================================================
-- 3) MORE CUSTOMERS
-- =========================================================
INSERT INTO Customer(
  email, password, name,
  address_number, address_street, address_city, address_state,
  phone_number, passport_number, passport_expiration, passport_country,
  date_of_birth
) VALUES
('john.doe@example.com','john123','John Doe',
 '10','Main St.','Boston','MA',
 '+1-617-555-0101','PUSA40004','2030-05-20','USA','1988-03-10'),

('emily.wong@example.com','emily123','Emily Wong',
 '200','Market St.','San Francisco','CA',
 '+1-415-555-0202','PUSA50005','2031-08-15','USA','1990-11-22'),

('raj.patel@example.com','raj123','Raj Patel',
 '15','King Rd.','Atlanta','GA',
 '+1-404-555-0303','PIND60006','2032-12-31','India','1985-07-04'),

('maria.garcia@example.com','maria123','Maria Garcia',
 '50','Sunset Blvd.','Miami','FL',
 '+1-305-555-0404','PESP70007','2033-09-09','Spain','1992-01-19'),

('li.wei@example.com','liwei123','Li Wei',
 '99','Nanjing Rd.','Shanghai','Shanghai',
 '+86-21-5555-0505','PCHN80008','2034-04-30','China','1995-06-01'),

('fatima.ali@example.com','fatima123','Fatima Ali',
 '12','Baker St.','London','UK',
 '+44-20-5555-0606','PPAK90009','2033-03-31','Pakistan','1989-09-09'),

('oliver.smith@example.com','oliver123','Oliver Smith',
 '700','Lake Shore Dr.','Chicago','IL',
 '+1-312-555-0707','PUSA100010','2035-12-01','USA','1998-02-02');

-- =========================================================
-- 4) MORE AIRLINE STAFF / PHONE NUMBERS / WORKS
-- =========================================================
INSERT INTO Airline_Staff(username, password, airline_name,
                          first_name, last_name, email, date_of_birth)
VALUES
('jb_staff2','password','Jet Blue','Alex','Rivera','staff2@jetblue.com','1990-05-14'),
('delta_staff1','password','Delta Air Lines','Derek','Lee','derek.lee@delta.com','1985-02-02'),
('delta_staff2','password','Delta Air Lines','Sara','Kim','sara.kim@delta.com','1992-11-11'),
('ua_staff1','password','United Airlines','Taylor','Nguyen','taylor.nguyen@united.com','1987-03-03'),
('aa_staff1','password','American Airlines','Chris','Johnson','chris.johnson@aa.com','1983-08-08'),
('af_staff1','password','Air France','Claire','Dubois','claire.dubois@airfrance.com','1986-12-12');

INSERT INTO Works(airline_name, username) VALUES
  ('Jet Blue','jb_staff2'),
  ('Delta Air Lines','delta_staff1'),
  ('Delta Air Lines','delta_staff2'),
  ('United Airlines','ua_staff1'),
  ('American Airlines','aa_staff1'),
  ('Air France','af_staff1');

INSERT INTO Airline_Staff_Number(username, number) VALUES
  ('jb_staff2','+1-718-555-0101'),
  ('delta_staff1','+1-404-555-1111'),
  ('delta_staff2','+1-404-555-2222'),
  ('ua_staff1','+1-312-555-3333'),
  ('aa_staff1','+1-817-555-4444'),
  ('af_staff1','+33-1-55-55-55-55');

-- =========================================================
-- 5) MORE AIRPLANES
-- =========================================================
INSERT INTO Airplane(airline_name, uid, seat_no, manufacturer, age) VALUES
('Jet Blue','JB-A321-04',190,'Airbus',1),
('Delta Air Lines','DL-B737-01',180,'Boeing',4),
('Delta Air Lines','DL-A330-01',260,'Airbus',6),
('United Airlines','UA-A320-01',160,'Airbus',5),
('United Airlines','UA-B777-01',300,'Boeing',8),
('American Airlines','AA-A321-01',190,'Airbus',3),
('Air France','AF-A350-01',320,'Airbus',2),
('Air France','AF-A320-01',170,'Airbus',7);

-- Make every airplane owned by its airline (including your original ones)
INSERT INTO Owns(airline_name, uid)
SELECT airline_name, uid
FROM Airplane
ON CONFLICT DO NOTHING;

-- =========================================================
-- 6) MORE FLIGHTS
--   (Your original Jet Blue flights already exist; these are new.)
-- =========================================================
INSERT INTO Flight(airline_name, flight_number, departure_timestamp, arrival_timestamp,
                   departure_airport, arrival_airport, uid, base_price, status)
VALUES
('Jet Blue','B410','2025-09-01 07:00','2025-09-01 10:00','JFK','MIA','JB-A320-02',199.00,'on-time'),
('Jet Blue','B420','2025-09-05 18:00','2025-09-05 21:10','MIA','JFK','JB-A320-02',205.00,'delayed'),
('Jet Blue','B430','2025-12-10 09:30','2025-12-10 12:45','JFK','BOS','JB-E190-03',120.00,'on-time'),
('Jet Blue','B440','2025-12-10 14:30','2025-12-10 17:45','BOS','JFK','JB-E190-03',115.00,'cancelled'),

('Delta Air Lines','DL100','2025-11-01 08:00','2025-11-01 11:00','ATL','JFK','DL-B737-01',180.00,'on-time'),
('Delta Air Lines','DL101','2025-11-01 13:00','2025-11-01 16:00','JFK','ATL','DL-B737-01',175.00,'on-time'),
('Delta Air Lines','DL200','2025-11-10 16:30','2025-11-11 06:30','JFK','LHR','DL-A330-01',650.00,'delayed'),

('United Airlines','UA900','2025-10-01 12:00','2025-10-01 15:00','SFO','LAX','UA-A320-01',150.00,'on-time'),
('United Airlines','UA901','2025-10-01 16:00','2025-10-02 08:30','SFO','PVG','UA-B777-01',780.00,'on-time'),

('American Airlines','AA50','2025-09-20 09:00','2025-09-20 12:15','JFK','SFO','AA-A321-01',320.00,'on-time'),
('American Airlines','AA51','2025-09-21 13:00','2025-09-21 21:00','SFO','JFK','AA-A321-01',310.00,'delayed'),

('Air France','AF007','2025-12-01 18:00','2025-12-02 06:45','JFK','CDG','AF-A350-01',730.00,'on-time'),
('Air France','AF008','2025-12-10 14:00','2025-12-10 16:00','CDG','LHR','AF-A320-01',220.00,'on-time');

-- =========================================================
-- 7) MORE TICKETS + BUYS (1 ticket per passenger)
--     Pattern: insert ticket, then Buy selects the latest ticket for that flight
-- =========================================================

-- Jet Blue B700 (3 passengers)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Jet Blue','B700','2025-12-05 08:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Jet Blue','B700','2025-12-05 08:00')
   ORDER BY id DESC
   LIMIT 1),
  'edward@example.com','4111111111111111','12/27','credit','EDWARD CHEN','2025-07-01 10:00'
);

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Jet Blue','B700','2025-12-05 08:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Jet Blue','B700','2025-12-05 08:00')
   ORDER BY id DESC
   LIMIT 1),
  'cass@example.com','4000000000000002','10/27','debit','CASSANDRA DIAZ','2025-07-01 10:00'
);

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Jet Blue','B700','2025-12-05 08:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Jet Blue','B700','2025-12-05 08:00')
   ORDER BY id DESC
   LIMIT 1),
  'john.doe@example.com','6011000000000004','09/27','credit','JOHN DOE','2025-07-01 10:00'
);

-- Jet Blue B410 (2 passengers)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Jet Blue','B410','2025-09-01 07:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Jet Blue','B410','2025-09-01 07:00')
   ORDER BY id DESC
   LIMIT 1),
  'john.doe@example.com','6011000000000004','09/27','credit','JOHN DOE','2025-07-02 09:00'
);

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Jet Blue','B410','2025-09-01 07:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Jet Blue','B410','2025-09-01 07:00')
   ORDER BY id DESC
   LIMIT 1),
  'maria.garcia@example.com','5200000000000007','06/26','credit','MARIA GARCIA','2025-07-02 09:00'
);

-- Jet Blue B420 (2 passengers)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Jet Blue','B420','2025-09-05 18:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Jet Blue','B420','2025-09-05 18:00')
   ORDER BY id DESC
   LIMIT 1),
  'john.doe@example.com','6011000000000004','09/27','credit','JOHN DOE','2025-07-03 09:00'
);

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Jet Blue','B420','2025-09-05 18:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Jet Blue','B420','2025-09-05 18:00')
   ORDER BY id DESC
   LIMIT 1),
  'emily.wong@example.com','378282246310005','08/26','credit','EMILY WONG','2025-07-03 09:00'
);

-- Jet Blue B430 (1 passenger)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Jet Blue','B430','2025-12-10 09:30');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Jet Blue','B430','2025-12-10 09:30')
   ORDER BY id DESC
   LIMIT 1),
  'oliver.smith@example.com','6011111111111117','03/28','credit','OLIVER SMITH','2025-07-04 09:00'
);

-- Jet Blue B440 (cancelled flight, 1 unsold ticket for demo)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Jet Blue','B440','2025-12-10 14:30');
-- (no Buy row -> unsold ticket)

-- Delta DL100 (2 passengers)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Delta Air Lines','DL100','2025-11-01 08:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Delta Air Lines','DL100','2025-11-01 08:00')
   ORDER BY id DESC
   LIMIT 1),
  'raj.patel@example.com','4007000000027','07/26','debit','RAJ PATEL','2025-07-05 09:00'
);

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Delta Air Lines','DL100','2025-11-01 08:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Delta Air Lines','DL100','2025-11-01 08:00')
   ORDER BY id DESC
   LIMIT 1),
  'maria.garcia@example.com','5200000000000007','06/26','credit','MARIA GARCIA','2025-07-05 09:00'
);

-- Delta DL101 (2 passengers)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Delta Air Lines','DL101','2025-11-01 13:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Delta Air Lines','DL101','2025-11-01 13:00')
   ORDER BY id DESC
   LIMIT 1),
  'raj.patel@example.com','4007000000027','07/26','debit','RAJ PATEL','2025-07-06 09:00'
);

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Delta Air Lines','DL101','2025-11-01 13:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Delta Air Lines','DL101','2025-11-01 13:00')
   ORDER BY id DESC
   LIMIT 1),
  'maria.garcia@example.com','5200000000000007','06/26','credit','MARIA GARCIA','2025-07-06 09:00'
);

-- Delta DL200 (2 passengers)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Delta Air Lines','DL200','2025-11-10 16:30');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Delta Air Lines','DL200','2025-11-10 16:30')
   ORDER BY id DESC
   LIMIT 1),
  'fatima.ali@example.com','6304000000000000','04/26','debit','FATIMA ALI','2025-07-07 09:00'
);

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Delta Air Lines','DL200','2025-11-10 16:30');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Delta Air Lines','DL200','2025-11-10 16:30')
   ORDER BY id DESC
   LIMIT 1),
  'li.wei@example.com','3530111333300000','05/27','credit','LI WEI','2025-07-07 09:00'
);

-- United UA900 (2 passengers)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('United Airlines','UA900','2025-10-01 12:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('United Airlines','UA900','2025-10-01 12:00')
   ORDER BY id DESC
   LIMIT 1),
  'emily.wong@example.com','378282246310005','08/26','credit','EMILY WONG','2025-07-08 09:00'
);

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('United Airlines','UA900','2025-10-01 12:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('United Airlines','UA900','2025-10-01 12:00')
   ORDER BY id DESC
   LIMIT 1),
  'oliver.smith@example.com','6011111111111117','03/28','credit','OLIVER SMITH','2025-07-08 09:00'
);

-- United UA901 (2 passengers)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('United Airlines','UA901','2025-10-01 16:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('United Airlines','UA901','2025-10-01 16:00')
   ORDER BY id DESC
   LIMIT 1),
  'li.wei@example.com','3530111333300000','05/27','credit','LI WEI','2025-07-09 09:00'
);

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('United Airlines','UA901','2025-10-01 16:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('United Airlines','UA901','2025-10-01 16:00')
   ORDER BY id DESC
   LIMIT 1),
  'emily.wong@example.com','378282246310005','08/26','credit','EMILY WONG','2025-07-09 09:00'
);

-- American AA50 (2 passengers)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('American Airlines','AA50','2025-09-20 09:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('American Airlines','AA50','2025-09-20 09:00')
   ORDER BY id DESC
   LIMIT 1),
  'edward@example.com','4111111111111111','12/27','credit','EDWARD CHEN','2025-07-10 09:00'
);

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('American Airlines','AA50','2025-09-20 09:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('American Airlines','AA50','2025-09-20 09:00')
   ORDER BY id DESC
   LIMIT 1),
  'john.doe@example.com','6011000000000004','09/27','credit','JOHN DOE','2025-07-10 09:00'
);

-- American AA51 (2 passengers)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('American Airlines','AA51','2025-09-21 13:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('American Airlines','AA51','2025-09-21 13:00')
   ORDER BY id DESC
   LIMIT 1),
  'edward@example.com','4111111111111111','12/27','credit','EDWARD CHEN','2025-07-11 09:00'
);

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('American Airlines','AA51','2025-09-21 13:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('American Airlines','AA51','2025-09-21 13:00')
   ORDER BY id DESC
   LIMIT 1),
  'john.doe@example.com','6011000000000004','09/27','credit','JOHN DOE','2025-07-11 09:00'
);

-- Air France AF007 (2 passengers)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Air France','AF007','2025-12-01 18:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Air France','AF007','2025-12-01 18:00')
   ORDER BY id DESC
   LIMIT 1),
  'maria.garcia@example.com','5200000000000007','06/26','credit','MARIA GARCIA','2025-07-12 09:00'
);

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Air France','AF007','2025-12-01 18:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Air France','AF007','2025-12-01 18:00')
   ORDER BY id DESC
   LIMIT 1),
  'fatima.ali@example.com','6304000000000000','04/26','debit','FATIMA ALI','2025-07-12 09:00'
);

-- Air France AF008 (1 passenger)
INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
VALUES ('Air France','AF008','2025-12-10 14:00');

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Air France','AF008','2025-12-10 14:00')
   ORDER BY id DESC
   LIMIT 1),
  'fatima.ali@example.com','6304000000000000','04/26','debit','FATIMA ALI','2025-07-13 09:00'
);

-- =========================================================
-- 8) OFFERS: one Offer row per Ticket (all remaining tickets)
-- =========================================================
INSERT INTO Offer(id, airline_name, flight_number, departure_timestamp, available_seats)
SELECT t.id, t.airline_name, t.flight_number, t.departure_timestamp,
       80
FROM Ticket t
LEFT JOIN Offer o ON o.id = t.id
WHERE o.id IS NULL;

-- =========================================================
-- 9) AUTO-FILL ARRIVAL / DEPARTURE / OPERATES / FLYS_ON
--     (for ALL flights, including your original ones)
-- =========================================================
INSERT INTO Arrival(code, airline_name, flight_number, departure_timestamp)
SELECT f.arrival_airport, f.airline_name, f.flight_number, f.departure_timestamp
FROM Flight f
ON CONFLICT DO NOTHING;

INSERT INTO Departure(code, airline_name, flight_number, departure_timestamp)
SELECT f.departure_airport, f.airline_name, f.flight_number, f.departure_timestamp
FROM Flight f
ON CONFLICT DO NOTHING;

INSERT INTO Operates(airline_name, flight_number, departure_timestamp)
SELECT f.airline_name, f.flight_number, f.departure_timestamp
FROM Flight f
ON CONFLICT DO NOTHING;

INSERT INTO Flys_On(airline_name, uid, flight_number, departure_timestamp)
SELECT f.airline_name, f.uid, f.flight_number, f.departure_timestamp
FROM Flight f
ON CONFLICT DO NOTHING;

-- =========================================================
-- 10) REVIEWS
-- =========================================================
INSERT INTO Review(email, airline_name, flight_number, departure_timestamp, rate, comment)
VALUES
('edward@example.com','Jet Blue','B612','2025-11-15 10:00',5,'Great service and smooth flight.'),
('aderline@example.com','Jet Blue','B612','2025-11-15 10:00',4,'On time, but legroom was tight.'),
('cass@example.com','Jet Blue','B613','2025-11-20 16:00',3,'Long delay departing Shanghai.'),
('edward@example.com','Jet Blue','B500','2025-10-01 09:00',4,'Comfortable seats for the long haul.'),
('john.doe@example.com','Jet Blue','B410','2025-09-01 07:00',4,'Nice crew and quick boarding.'),
('maria.garcia@example.com','Jet Blue','B410','2025-09-01 07:00',5,'Loved flying down to Miami with Jet Blue.'),
('raj.patel@example.com','Delta Air Lines','DL100','2025-11-01 08:00',4,'Smooth connection into JFK.'),
('maria.garcia@example.com','Delta Air Lines','DL200','2025-11-10 16:30',3,'OK flight, but food could be better.'),
('emily.wong@example.com','United Airlines','UA900','2025-10-01 12:00',4,'Short and easy hop within California.'),
('li.wei@example.com','United Airlines','UA901','2025-10-01 16:00',2,'Cabin felt crowded and noisy.'),
('maria.garcia@example.com','Air France','AF007','2025-12-01 18:00',5,'Fantastic French food and wine.'),
('fatima.ali@example.com','Air France','AF007','2025-12-01 18:00',4,'Very friendly Air France crew.');
