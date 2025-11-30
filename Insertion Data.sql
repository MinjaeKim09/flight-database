INSERT INTO Airline(name) VALUES ('Jet Blue');

INSERT INTO Airport(code, city, country, type) VALUES
  ('JFK','New York City','USA','international'),
  ('PVG','Shanghai','China','international');

INSERT INTO Customer(email, password, name, address_number, address_street, address_city, address_state,
                     phone_number, passport_number, passport_expiration, passport_country, date_of_birth)
VALUES
('edward@example.com','6676e7d0995ebd8dbd136869a9358d14','Edward Chen','5','Wall St.','New York','NY','+1-212-555-1000','PUSA10001','2032-06-30','USA','1995-04-12'),
('aderline@example.com','fa6a6bd136dec26a1dd5e326b7e43254','Aderline Smith','88','Broadway','New York','NY','+1-917-555-2200','PUSA20002','2031-10-31','USA','1992-09-05'),
('cass@example.com','15698ae039abb8092677ea9c9f9a3d73','Cassandra Diaz','5','Ocean Blvd','Miami','FL','+1-305-555-3300','PMEX30003','2033-01-15','Mexico','1990-02-20'),
('mk8400@nyu.edu', '098f6bcd4621d373cade4e832627b4f6', 'Minjae Kim', '606', '170 Tillary St', 'Brooklyn', 'NY', '9714708881', '696942067', '2030-09-01', 'US', '2003-09-01');

INSERT INTO Airline_Staff(username, password, airline_name, first_name, last_name, email, date_of_birth)
VALUES ('jb_staff1','5f4dcc3b5aa765d61d8327deb882cf99','Jet Blue','Jamie','Baker','staff1@jetblue.com','1988-07-07');

INSERT INTO Works(airline_name, username) VALUES ('Jet Blue','jb_staff1');
INSERT INTO Airline_Staff_Number(username, number) VALUES ('jb_staff1','+1-718-555-0100');

INSERT INTO Airplane(airline_name, uid, seat_no, manufacturer, age) VALUES
('Jet Blue','JB-A320-01',162,'Airbus',3),
('Jet Blue','JB-A320-02',162,'Airbus',5),
('Jet Blue','JB-E190-03',100,'Boing',7);

INSERT INTO Flight(airline_name, flight_number, departure_timestamp, arrival_timestamp,
                   departure_airport, arrival_airport, uid, base_price, status)
VALUES
('Jet Blue','B612','2025-11-15 10:00','2025-11-16 14:00','JFK','PVG','JB-A320-01',799.00,'on-time');

INSERT INTO Flight(airline_name, flight_number, departure_timestamp, arrival_timestamp,
                   departure_airport, arrival_airport, uid, base_price, status)
VALUES
('Jet Blue','B613','2025-11-20 16:00','2025-11-21 19:30','PVG','JFK','JB-A320-02',789.00,'delayed');

INSERT INTO Flight(airline_name, flight_number, departure_timestamp, arrival_timestamp,
                   departure_airport, arrival_airport, uid, base_price, status)
VALUES
('Jet Blue','B700','2025-12-05 08:00','2025-12-06 11:20','JFK','PVG','JB-A320-01',699.00,'on-time');

INSERT INTO Flight(airline_name, flight_number, departure_timestamp, arrival_timestamp,
                   departure_airport, arrival_airport, uid, base_price, status)
VALUES
('Jet Blue','B500','2025-10-01 09:00','2025-10-02 12:10','JFK','PVG','JB-E190-03',650.00,'on-time');

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
  VALUES ('Jet Blue','B612','2025-11-15 10:00');

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
  VALUES ('Jet Blue','B612','2025-11-15 10:00');

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
  VALUES ('Jet Blue','B613','2025-11-20 16:00');

INSERT INTO Ticket(airline_name, flight_number, departure_timestamp)
  VALUES ('Jet Blue','B500','2025-10-01 09:00');


INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Jet Blue','B612','2025-11-15 10:00')
   ORDER BY id LIMIT 1),
  'edward@example.com','4111111111111111','12/27','credit','EDWARD CHEN','2025-10-20 12:00'
);

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Jet Blue','B612','2025-11-15 10:00')
   ORDER BY id OFFSET 1 LIMIT 1),
  'aderline@example.com','5555555555554444','11/27','credit','ADERLINE SMITH','2025-10-21 09:30'
);

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Jet Blue','B613','2025-11-20 16:00')),
  'cass@example.com','4000000000000002','10/27','debit','CASSANDRA DIAZ','2025-10-25 15:45'
);

INSERT INTO Buy (id,email,card_number,card_expiration,card_type,card_name,purchase_timestamp)
VALUES (
  (SELECT id FROM Ticket
   WHERE (airline_name,flight_number,departure_timestamp)=('Jet Blue','B500','2025-10-01 09:00')),
  'edward@example.com','4111111111111111','12/27','credit','EDWARD CHEN','2025-09-28 08:10'
);