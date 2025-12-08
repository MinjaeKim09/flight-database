# Test Scenario for 12/10/2025 and 12/11/2025 Demo

## Instructions
* [cite_start]**Demo Dates:** The test scenario is for the demo on 12/10/2025 and 12/11/2025[cite: 1]. [cite_start]If you are not presenting on these dates, you may ignore this[cite: 2].
* [cite_start]**Data Requirement:** You must remove all current database data and load only the data described in this test scenario[cite: 3].
* [cite_start]**Backup:** Please backup your existing data before removing it[cite: 4].
* [cite_start]**Timing:** Load this data before arriving at the demo[cite: 5].
* [cite_start]**Schema Modifications:** If you modified table definitions from class, you are responsible for translating this scenario to match your definitions[cite: 6].
* **Capacity Note:** Pay special attention to Tickets and Purchase tables. [cite_start]If you auto-generate tickets based on airplane capacity, ensure the number of tickets sold matches these scenarios[cite: 7].

---

## 1. Airline
[cite_start]Add an airline name as follows[cite: 8]:
* [cite_start]**Airline name:** United [cite: 9]

## 2. Airline Staff
[cite_start]Add an airline staff member as follows[cite: 10]:
* **Username:** admin
* **Password:** abcd
* **Firstname:** Roe
* **Lastname:** Jones
* **Date of birth:** 1978-05-25
* **Airline name:** United
* **Phone numbers:** 111-2222-3333, 444-5555-6666
* [cite_start]**Email:** staff@nyu.edu [cite: 11]

## 3. Airplanes
[cite_start]Add 3 airplanes as follows[cite: 12]:
* **ID:** 1 | **Airline:** United | **Seats:** 4 | **Manufacturer:** Boeing | [cite_start]**Age:** 10 [cite: 13]
* **ID:** 2 | **Airline:** United | **Seats:** 4 | **Manufacturer:** Airbus | [cite_start]**Age:** 12 [cite: 13]
* **ID:** 3 | **Airline:** United | **Seats:** 50 | **Manufacturer:** Boeing | [cite_start]**Age:** 8 [cite: 13]

## 4. Airports
[cite_start]Add 8 airports as follows[cite: 14]:
* **Name:** JFK | **City:** NYC | **Country:** USA | [cite_start]**Type:** Both [cite: 15]
* **Name:** BOS | **City:** Boston | **Country:** USA | [cite_start]**Type:** Both [cite: 15]
* **Name:** PVG | **City:** Shanghai | **Country:** China | [cite_start]**Type:** Both [cite: 15]
* **Name:** BEI | **City:** Beijing | **Country:** China | [cite_start]**Type:** Both [cite: 15]
* **Name:** SFO | **City:** San Francisco | **Country:** USA | [cite_start]**Type:** Both [cite: 15]
* **Name:** LAX | **City:** Los Angeles | **Country:** USA | [cite_start]**Type:** Both [cite: 15]
* **Name:** HKA | **City:** Hong Kong | **Country:** China | [cite_start]**Type:** Both [cite: 15]
* **Name:** SHEN | **City:** Shenzhen | **Country:** China | [cite_start]**Type:** Both [cite: 15]

## 5. Customers
[cite_start]Add 3 customers as follows[cite: 16]:

**Customer 1:**
* **Email:** testcustomer@nyu.edu | **Password:** 1234
* **Name:** Jon Snow
* **Address:** 1555 Jay St, Brooklyn, New York
* **Phone:** 123-4321-4321
* **Passport:** 54321 (Expires: 2025-12-24, Country: USA)
* [cite_start]**DOB:** 1999-12-19 [cite: 17]

**Customer 2:**
* **Email:** user1@nyu.edu | **Password:** 1234
* **Name:** Alice Bob
* **Address:** 5405 Jay Street, Brooklyn, New York
* **Phone:** 123-4322-4322
* **Passport:** 54322 (Expires: 2025-12-25, Country: USA)
* [cite_start]**DOB:** 1999-11-19 [cite: 18]

**Customer 3:**
* **Email:** user3@nyu.edu | **Password:** 1234
* **Name:** Trudy Jones
* **Address:** 1890 Jay Street, Brooklyn, New York
* **Phone:** 123-4324-4324
* **Passport:** 54324 (Expires: 2025-09-24, Country: USA)
* [cite_start]**DOB:** 1999-09-19 [cite: 19]

## 6. Flights
[cite_start]Create/add 6 flights as follows[cite: 20]:

* **Flight 102:** United | SFO to LAX | Dep: 2025-09-14 13:25:25 | Arr: 2025-09-14 16:50:25 | Price: 300 | Status: on-time | [cite_start]Airplane ID: 3 [cite: 21]
* **Flight 104:** United | PVG to BEI | Dep: 2025-10-14 13:25:25 | Arr: 2025-10-14 16:50:25 | Price: 300 | Status: on-time | [cite_start]Airplane ID: 3 [cite: 22]
* **Flight 206:** United | SFO to LAX | Dep: 2026-01-04 13:25:25 | Arr: 2026-01-04 16:50:25 | Price: 350 | Status: on-time | [cite_start]Airplane ID: 2 [cite: 23]
* **Flight 207:** United | LAX to SFO | Dep: 2026-02-05 13:25:25 | Arr: 2026-02-05 16:50:25 | Price: 300 | Status: on-time | [cite_start]Airplane ID: 2 [cite: 24]
* **Flight 296:** United | PVG to SFO | Dep: 2025-12-28 13:25:25 | Arr: 2025-12-28 16:50:25 | Price: 3000 | Status: on-time | [cite_start]Airplane ID: 1 [cite: 25]
* **Flight 715:** United | PVG to BEI | Dep: 2025-09-25 10:25:25 | Arr: 2025-09-25 13:50:25 | Price: 500 | Status: delayed | [cite_start]Airplane ID: 1 [cite: 26]

## 7. Tickets
[cite_start]Add 12 tickets as follows[cite: 27]:

* **Ticket 1:** United | Flight 102 | [cite_start]Dep: 2025-09-14 13:25:25 [cite: 28]
* **Ticket 2:** United | Flight 102 | [cite_start]Dep: 2025-09-14 13:25:25 [cite: 29]
* **Ticket 3:** United | Flight 104 | [cite_start]Dep: 2025-10-14 13:25:25 [cite: 30]
* **Ticket 4:** United | Flight 104 | [cite_start]Dep: 2025-10-14 13:25:25 [cite: 31]
* **Ticket 5:** United | Flight 102 | [cite_start]Dep: 2025-09-14 13:25:25 [cite: 32]
* **Ticket 6:** United | Flight 715 | [cite_start]Dep: 2025-09-25 10:25:25 [cite: 33]
* **Ticket 7:** United | Flight 206 | [cite_start]Dep: 2026-01-04 13:25:25 [cite: 34]
* **Ticket 8:** United | Flight 206 | [cite_start]Dep: 2026-01-04 13:25:25 [cite: 35]
* **Ticket 9:** United | Flight 207 | [cite_start]Dep: 2026-02-05 13:25:25 [cite: 36]
* **Ticket 10:** United | Flight 207 | [cite_start]Dep: 2026-02-05 13:25:25 [cite: 37]
* **Ticket 11:** United | Flight 296 | [cite_start]Dep: 2025-12-28 13:25:25 [cite: 38]
* **Ticket 12:** United | Flight 296 | [cite_start]Dep: 2025-12-28 13:25:25 [cite: 39]

## 8. Purchase Records
[cite_start]Add/Create purchase records as follows[cite: 40]:

* **Ticket 1:** testcustomer@nyu.edu | Date: 2025-08-15 11:55:55 | Credit: 1111-2222-3333-4444 | Name: Test Customer 1 | [cite_start]Exp: 03/2026 [cite: 41]
* **Ticket 2:** user1@nyu.edu | Date: 2025-08-20 11:55:55 | Credit: 1111-2222-3333-5555 | Name: User 1 | [cite_start]Exp: 03/2026 [cite: 42]
* **Ticket 3:** user1@nyu.edu | Date: 2025-09-21 11:55:55 | Credit: 1111-2222-3333-5555 | Name: User 1 | [cite_start]Exp: 03/2026 [cite: 43]
* **Ticket 4:** testcustomer@nyu.edu | Date: 2025-09-28 11:55:55 | Credit: 1111-2222-3333-4444 | Name: Test Customer 1 | [cite_start]Exp: 03/2027 [cite: 44]
* **Ticket 5:** user3@nyu.edu | Date: 2025-07-16 11:55:55 | Credit: 1111-2222-3333-5555 | Name: User 3 | [cite_start]Exp: 03/2026 [cite: 45]
* **Ticket 6:** testcustomer@nyu.edu | Date: 2024-09-20 11:55:55 | Credit: 1111-2222-3333-4444 | Name: Test Customer 1 | [cite_start]Exp: 03/2026 [cite: 46]
* **Ticket 7:** user3@nyu.edu | Date: 2025-11-20 11:55:55 | Credit: 1111-2222-3333-5555 | Name: User 3 | [cite_start]Exp: 03/2026 [cite: 47]
* **Ticket 8:** user1@nyu.edu | Date: 2025-10-21 11:55:55 | Credit: 1111-2222-3333-5555 | Name: User 1 | [cite_start]Exp: 03/2026 [cite: 48]
* **Ticket 9:** user1@nyu.edu | Date: 2025-12-02 11:55:55 | Credit: 1111-2222-3333-5555 | Name: User 1 | [cite_start]Exp: 03/2026 [cite: 49]
* **Ticket 10:** testcustomer@nyu.edu | Date: 2025-10-25 11:55:55 | Credit: 1111-2222-3333-4444 | Name: Test Customer 1 | [cite_start]Exp: 03/2026 [cite: 50]
* **Ticket 11:** user1@nyu.edu | Date: 2025-10-22 11:55:55 | Credit: 1111-2222-3333-4444 | Name: Test Customer 1 | [cite_start]Exp: 03/2026 [cite: 51]
* **Ticket 12:** testcustomer@nyu.edu | Date: 2025-11-20 11:55:55 | Credit: 1111-2222-3333-4444 | Name: Test Customer 1 | [cite_start]Exp: 03/2026 [cite: 52]

## 9. Rate Records
[cite_start]Add/Create rate records as follows[cite: 53]:

* **Record 1:**
    * **Email:** testcustomer@nyu.edu
    * **Flight:** United 102 (2025-09-14 13:25:25)
    * **Rating:** 4
    * [cite_start]**Comment:** "Very Comfortable" [cite: 54]
* **Record 2:**
    * **Email:** user1@nyu.edu
    * **Flight:** United 102 (2025-09-14 13:25:25)
    * **Rating:** 5
    * [cite_start]**Comment:** "Relaxing, check-in and onboarding very professional" [cite: 55]
* **Record 3:**
    * **Email:** testcustomer@nyu.edu
    * **Flight:** United 104 (2025-10-14 13:25:25)
    * **Rating:** 1
    * [cite_start]**Comment:** "Customer Care services are not good" [cite: 56]
* **Record 4:**
    * **Email:** user1@nyu.edu
    * **Flight:** United 104 (2025-10-14 13:25:25)
    * **Rating:** 5
    * [cite_start]**Comment:** "Comfortable journey and Professional" [cite: 57]