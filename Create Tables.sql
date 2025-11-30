CREATE TYPE airport_type  AS ENUM ('domestic','international','both');
CREATE TYPE card_type     AS ENUM ('credit','debit');
CREATE TYPE flight_status AS ENUM ('on-time','delayed','cancelled');

CREATE TABLE Airline (
  name              VARCHAR(100) PRIMARY KEY
);

CREATE TABLE Airport (
  code              CHAR(3) PRIMARY KEY,          
  city              VARCHAR(100) NOT NULL,
  country           VARCHAR(100) NOT NULL,
  type              airport_type NOT NULL
);

CREATE TABLE Customer (
  email                 VARCHAR(255) PRIMARY KEY,
  password              VARCHAR(255) NOT NULL,     
  name                  VARCHAR(100) NOT NULL,
  address_number        VARCHAR(20)  NOT NULL,
  address_street        VARCHAR(100) NOT NULL,
  address_city          VARCHAR(100) NOT NULL,
  address_state         VARCHAR(100) NOT NULL,
  phone_number          VARCHAR(20)  NOT NULL,
  passport_number       VARCHAR(50)  NOT NULL,
  passport_expiration   DATE         NOT NULL,
  passport_country      VARCHAR(100) NOT NULL,
  date_of_birth         DATE         NOT NULL,
  CONSTRAINT uq_customer_passport UNIQUE (passport_number),
  CONSTRAINT ck_customer_passport_exp CHECK (passport_expiration > date_of_birth)
);

CREATE TABLE Airline_Staff (
  username          VARCHAR(100) PRIMARY KEY,
  password          VARCHAR(255) NOT NULL,         
  airline_name      VARCHAR(100) NOT NULL,
  first_name        VARCHAR(50)  NOT NULL,
  last_name         VARCHAR(50)  NOT NULL,
  email             VARCHAR(255) NOT NULL,
  date_of_birth     DATE,
  CONSTRAINT uq_staff_email UNIQUE (email),
  CONSTRAINT fk_staff_airline
    FOREIGN KEY (airline_name) REFERENCES Airline(name)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Airline_Staff_Number (
  username          VARCHAR(100) NOT NULL,
  number            VARCHAR(20)  NOT NULL,
  PRIMARY KEY (username, number),
  CONSTRAINT fk_staffnum_staff
    FOREIGN KEY (username) REFERENCES Airline_Staff(username)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Airplane (
  airline_name      VARCHAR(100) NOT NULL,
  uid               VARCHAR(50)  NOT NULL,
  seat_no           INTEGER      NOT NULL,
  manufacturer      VARCHAR(100) NOT NULL,
  age               INTEGER      NOT NULL,
  PRIMARY KEY (airline_name, uid),
  CONSTRAINT ck_airplane_seats CHECK (seat_no > 0),
  CONSTRAINT ck_airplane_age   CHECK (age >= 0),
  CONSTRAINT fk_airplane_airline
    FOREIGN KEY (airline_name) REFERENCES Airline(name)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Flight (
  airline_name          VARCHAR(100) NOT NULL,
  flight_number         VARCHAR(20)  NOT NULL,
  departure_timestamp   TIMESTAMP    NOT NULL,
  arrival_timestamp     TIMESTAMP    NOT NULL,
  departure_airport     CHAR(3)      NOT NULL,
  arrival_airport       CHAR(3)      NOT NULL,
  uid                   VARCHAR(50)  NOT NULL,     -- airplane uid within airline
  base_price            NUMERIC(10,2) NOT NULL,
  status                flight_status NOT NULL DEFAULT 'on-time',
  PRIMARY KEY (airline_name, flight_number, departure_timestamp),
  CONSTRAINT ck_time_order  CHECK (arrival_timestamp > departure_timestamp),
  CONSTRAINT ck_base_price  CHECK (base_price >= 0),
  CONSTRAINT fk_flight_airline
    FOREIGN KEY (airline_name) REFERENCES Airline(name)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_flight_plane
    FOREIGN KEY (airline_name, uid) REFERENCES Airplane(airline_name, uid)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_flight_dep_airport
    FOREIGN KEY (departure_airport) REFERENCES Airport(code)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_flight_arr_airport
    FOREIGN KEY (arrival_airport) REFERENCES Airport(code)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX idx_flight_number ON Flight(flight_number);

CREATE TABLE Ticket (
  id                   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  airline_name         VARCHAR(100) NOT NULL,
  flight_number        VARCHAR(20)  NOT NULL,
  departure_timestamp  TIMESTAMP    NOT NULL,
  CONSTRAINT fk_ticket_flight
    FOREIGN KEY (airline_name, flight_number, departure_timestamp)
    REFERENCES Flight(airline_name, flight_number, departure_timestamp)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX idx_ticket_flight
  ON Ticket(airline_name, flight_number, departure_timestamp);

CREATE TABLE Buy (
  id                  BIGINT       NOT NULL,       -- Ticket(id)
  email               VARCHAR(255) NOT NULL,       -- Customer(email)
  card_number         VARCHAR(25)  NOT NULL,
  card_expiration     CHAR(5)      NOT NULL,       -- MM/YY (per spec)
  card_type           card_type    NOT NULL,
  card_name           VARCHAR(100) NOT NULL,
  purchase_timestamp  TIMESTAMP    NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_buy_ticket
    FOREIGN KEY (id) REFERENCES Ticket(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_buy_customer
    FOREIGN KEY (email) REFERENCES Customer(email)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Review (
  email                VARCHAR(255) NOT NULL,
  airline_name         VARCHAR(100) NOT NULL,
  flight_number        VARCHAR(20)  NOT NULL,
  departure_timestamp  TIMESTAMP    NOT NULL,
  rate                 SMALLINT     NOT NULL,
  comment              VARCHAR(2000),
  PRIMARY KEY (email, airline_name, flight_number, departure_timestamp),
  CONSTRAINT ck_rate CHECK (rate BETWEEN 1 AND 5),
  CONSTRAINT fk_review_customer
    FOREIGN KEY (email) REFERENCES Customer(email)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_review_flight
    FOREIGN KEY (airline_name, flight_number, departure_timestamp)
    REFERENCES Flight(airline_name, flight_number, departure_timestamp)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Arrival (
  code                 CHAR(3)      NOT NULL,
  airline_name         VARCHAR(100) NOT NULL,
  flight_number        VARCHAR(20)  NOT NULL,
  departure_timestamp  TIMESTAMP    NOT NULL,
  PRIMARY KEY (code, airline_name, flight_number, departure_timestamp),
  CONSTRAINT fk_arrival_airport
    FOREIGN KEY (code) REFERENCES Airport(code)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_arrival_flight
    FOREIGN KEY (airline_name, flight_number, departure_timestamp)
    REFERENCES Flight(airline_name, flight_number, departure_timestamp)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Departure (
  code                 CHAR(3)      NOT NULL,
  airline_name         VARCHAR(100) NOT NULL,
  flight_number        VARCHAR(20)  NOT NULL,
  departure_timestamp  TIMESTAMP    NOT NULL,
  PRIMARY KEY (code, airline_name, flight_number, departure_timestamp),
  CONSTRAINT fk_depart_airport
    FOREIGN KEY (code) REFERENCES Airport(code)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_depart_flight
    FOREIGN KEY (airline_name, flight_number, departure_timestamp)
    REFERENCES Flight(airline_name, flight_number, departure_timestamp)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Operates (
  airline_name         VARCHAR(100) NOT NULL,
  flight_number        VARCHAR(20)  NOT NULL,
  departure_timestamp  TIMESTAMP    NOT NULL,
  PRIMARY KEY (airline_name, flight_number, departure_timestamp),
  CONSTRAINT fk_operates_flight
    FOREIGN KEY (airline_name, flight_number, departure_timestamp)
    REFERENCES Flight(airline_name, flight_number, departure_timestamp)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_operates_airline
    FOREIGN KEY (airline_name) REFERENCES Airline(name)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Owns (
  airline_name   VARCHAR(100) NOT NULL,
  uid            VARCHAR(50)  NOT NULL,
  PRIMARY KEY (airline_name, uid),
  CONSTRAINT fk_owns_plane
    FOREIGN KEY (airline_name, uid) REFERENCES Airplane(airline_name, uid)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_owns_airline
    FOREIGN KEY (airline_name) REFERENCES Airline(name)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Works (
  airline_name   VARCHAR(100) NOT NULL,
  username       VARCHAR(100) NOT NULL,
  PRIMARY KEY (airline_name, username),
  CONSTRAINT fk_works_airline
    FOREIGN KEY (airline_name) REFERENCES Airline(name)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_works_staff
    FOREIGN KEY (username) REFERENCES Airline_Staff(username)
    ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE Flys_On (
  airline_name         VARCHAR(100) NOT NULL,
  uid                  VARCHAR(50)  NOT NULL,
  flight_number        VARCHAR(20)  NOT NULL,
  departure_timestamp  TIMESTAMP    NOT NULL,
  PRIMARY KEY (airline_name, uid, flight_number, departure_timestamp),
  CONSTRAINT fk_flyson_plane
    FOREIGN KEY (airline_name, uid) REFERENCES Airplane(airline_name, uid)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_flyson_flight
    FOREIGN KEY (airline_name, flight_number, departure_timestamp)
    REFERENCES Flight(airline_name, flight_number, departure_timestamp)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Offer (
  id                   BIGINT       NOT NULL,  -- Ticket(id)
  airline_name         VARCHAR(100) NOT NULL,
  flight_number        VARCHAR(20)  NOT NULL,
  departure_timestamp  TIMESTAMP    NOT NULL,
  available_seats      INTEGER      NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT ck_offer_seats CHECK (available_seats >= 0),
  CONSTRAINT fk_offer_ticket
    FOREIGN KEY (id) REFERENCES Ticket(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_offer_flight
    FOREIGN KEY (airline_name, flight_number, departure_timestamp)
    REFERENCES Flight(airline_name, flight_number, departure_timestamp)
    ON UPDATE CASCADE ON DELETE CASCADE
);