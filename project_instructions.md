# New York University
**Tandon School of Engineering**
**Project for Intro. To Databases (CS-UY 3083)**
**Fall 2025**
[cite_start]**Professor Ratan Dey** [cite: 1-5]

### Objective:
[cite_start]The objective of this course project is to provide a realistic experience in the design process of a relational database and corresponding applications[cite: 7]. [cite_start]We will focus on conceptual design, logical design, implementation, operation, maintenance of a relational database[cite: 8]. [cite_start]We will also implement an associated web-based application to communicate with the database (retrieve information, store information etc.)[cite: 9].

### Project Overview:
[cite_start]The course project for this semester is an **online Air Ticket Reservation System**[cite: 11]. [cite_start]There will be two types of users of this system - **Customers**, and **Airline Staff (Administrator)**[cite: 12]. [cite_start]Using this system, customers can search for flights (one way or round trip), purchase flights ticket, view their future flight status or see their past flights etc. Airline Staff will add new airplanes, create new flights, and update flight status[cite: 13]. [cite_start]In general, this will be a simple air ticket reservation system[cite: 14].

[cite_start]**Instructions for working with partners:** You may work alone or with one teammate or with two teammates[cite: 15].
* **Deadline for adding teammates:** Thursday October 16, 2025. THIS IS A HARD DEADLINE. [cite_start]NO EXCEPTIONS[cite: 16].
* [cite_start]Maximum size of the group can be 3 and you can't change group[cite: 17].
* [cite_start]If you want to work in a group, you must send me (ratan@nyu.edu) an email mentioning group members name and NetID within Thursday October 16, 2025[cite: 18]. [cite_start]Only one of the group members need to send the email (Subject should be "Group members for Databases (CS-UY 3083) Class Project" and in the Body of the email should contains all group members name and NetID)[cite: 18].

### 3 Parts of the Project:

[cite_start]**Part 1.** Create an ER diagram based on the Project description below[cite: 20].
* [cite_start]You may work with up to 2 partners or individually for this part[cite: 21].
* [cite_start]**Deadline: 10/21/2025 11:59 pm**[cite: 22].

[cite_start]**Part 2.** Create a relational database design (relational Schema, write table definitions in SQL, write some queries etc.) based on ER diagram[cite: 23].
* [cite_start]You may work with up to 2 partners or individually for this part[cite: 24].
* [cite_start]**Deadline: 10/30/2025 11:59 pm**[cite: 25].

[cite_start]**Part 3.** Develop a web application for the system[cite: 26].
* [cite_start]You may work with up to 2 partners or individually for this part[cite: 26].
* [cite_start]**Deadline: 12/04/2025 11:59 pm**[cite: 28].

**Grading:**
* [cite_start]The total project grade will be 20% of your course grade[cite: 29].
* [cite_start]Part 1 counts for about 25% of the project grade[cite: 30].
* [cite_start]Part 2 counts for about 25% of the project grade[cite: 30].
* [cite_start]Part 3 counts for about 50% of the project grade[cite: 31].
* [cite_start]There may also be exam question(s) based on the project[cite: 31].

**Requirements:**
[cite_start]Teams will be required to submit a work plan for project part 3, indicating who will do what, and will be required to submit a **progress report (due on 11/20/2025 11:59 pm)** for project part 3, all source codes (front end, back end), databases backup file (including table structures and inserted data), detailed report on use cases implementation, and an evaluation at the end[cite: 32]. [cite_start]Note that each teammate is expected to contribute roughly equally to each aspect of the project and each teammate is responsible for understanding the entire system[cite: 33]. [cite_start]Normally all team members will receive the same grade, but I may deduct points from individuals who are not pulling their weight on a team[cite: 34].

---

### Project Description

* [cite_start]There are several airports (**Airport**), each consisting of a unique code, a city, a country, and an airport type (domestic/international/both)[cite: 36].
* There are several airlines (**Airline**), each with a unique name. [cite_start]Each airline owns several airplanes[cite: 37].
* [cite_start]An airplane (**Airplane**) consists of the airline that owns it, a unique identification number within that airline, and the number of seats on the airplane, a manufacturing company of that airplane, age of the airplane[cite: 38].
* [cite_start]Each airline operates flights (**Flight**), which consist of the airline operating the flight, a flight number, departure airport, departure date and time, arrival airport, arrival date and time, a base price, and the identification number of the airplane for the flight[cite: 39].
* [cite_start]Each flight is identifiable using flight number and departure date and time together within that airline[cite: 40].
* [cite_start]All the flights are non-stop flights (direct flight from departure airport to arrival airport)[cite: 41].
* [cite_start]A ticket (**Ticket**) can be purchased for a flight by a customer, and will consist of the customer's email address, the airline name, the flight number, payment information (including card type - credit/debit, card number, name on card, expiration date), purchase date and time[cite: 42]. [cite_start]Each ticket will have a ticket ID number which is unique in this System[cite: 43].

[cite_start]There are two types of users for this system: **Customer**, and **Airline Staff**[cite: 44].

**Customer:**
* [cite_start]Each Customer has a name, email, password, address (composite attribute consisting of building_number, street, city, state), phone_number, passport_number, passport_expiration, passport_country, and date_of_birth[cite: 46].
* [cite_start]Each Customer's email is unique, and they will sign into the system using their email address and password[cite: 47].
* [cite_start]Customers must be logged in to purchase a flight ticket[cite: 48].
* [cite_start]Customers can purchase a ticket for a flight as long as there is still room on the plane[cite: 49]. [cite_start]This is based on the number of tickets already booked for the flight and the seating capacity of the airplane assigned to the flight and customer needs to pay the associated price for that flight[cite: 50].
* [cite_start]Customer can buy tickets using either credit card or debit card[cite: 51]. [cite_start]We want to store card information (card number and expiration date and name on the card but not the security code) along with purchased date, time[cite: 52].
* [cite_start]Customer will be able to rate and comment on their previous flights taken for the airline they logged in[cite: 53].

**Airline Staff:**
* [cite_start]Each Airline Staff has a unique username, a password, a first name, a last name, a date of birth, may have more than one phone number, must have one email address, and the airline name that they work for[cite: 55].
* [cite_start]One Airline Staff only works for one airline[cite: 56].

---

### What You Should Do for Part 1:

Design an **ER diagram** for online Air Ticket Reservation System described above. [cite_start]Draw the ER diagram neatly[cite: 58]. You may draw it by hand or using a design tool. [cite_start]Design tool preferred[cite: 59]. [cite_start]Please create a PDF file and submit on Gradescope as the solution of "Part 1 of Course Project" Assignment (will be available later)[cite: 60].
* [cite_start]**Deadline for Part 1: 10/21/2025 11:59 pm**[cite: 61].

**When you do this, think about:**
* [cite_start]Which information should be represented as attributes, which as entity sets or relationship sets? [cite: 62]
* Are any of the entity sets weak entity sets? [cite_start]If so, what is the identifying strong entity set? [cite: 63]
* What is the primary keys (or discriminant) of each entity set? [cite_start]What are the cardinality constraints on the relationship sets? [cite: 64]
* [cite_start]Do you need to use ternary relationship sets or aggregation? [cite: 65]
* [cite_start]You may find it useful to read the Project Part 3 descriptions but not required[cite: 66].

---

### What You Should Do for Part 2

1.  [cite_start]Following the techniques we studied, derive a **relational schema diagram** from the Part 1's ER diagram[cite: 68]. [cite_start]Remember to underline primary keys and use arrows from the referencing schema to the referenced schema to indicate foreign key constraints[cite: 69].
2.  Write and execute **SQL CREATE TABLE statements** to create the tables. [cite_start]Choose reasonable types for the attributes[cite: 70].
3.  [cite_start]Write and execute **INSERT statements** to insert data representing one airline's air ticket reservation system[cite: 71]. [cite_start]As for example, you can insert data in the appropriate tables as follows or you can insert data for another airline or your own make up airline[cite: 72]:
    * a. [cite_start]One Airline name "Jet Blue"[cite: 73].
    * b. [cite_start]At least Two airports named "JFK" in NYC and "PVG" in Shanghai[cite: 74].
    * c. [cite_start]Insert at least three customers with appropriate names and other attributes[cite: 75].
    * d. [cite_start]Insert at least three airplanes[cite: 76].
    * e. [cite_start]Insert At least One airline Staff working for Jet Blue[cite: 77].
    * f. [cite_start]Insert several flights with on-time, and delayed statuses[cite: 78].
    * g. [cite_start]Insert some tickets for corresponding flights and insert some purchase records (customers bought some tickets)[cite: 79].
4.  [cite_start]Write **SQL queries** for executing following queries and show the results in your file (SQL query and corresponding answers)[cite: 80]:
    * a. [cite_start]Show all the future flights in the system[cite: 81].
    * b. [cite_start]Show all of the delayed flights in the system[cite: 82].
    * c. [cite_start]Show the customer names who bought the tickets[cite: 83].
    * d. [cite_start]Show all the airplanes owned by the airline Jet Blue[cite: 84].

[cite_start]You may find it useful to read the Project Part 3 descriptions but not required[cite: 85].

[cite_start]**Submission:** Submit a PDF file for Relational Schema diagram and one .SQL file for #2 (all the create table statements), one .SQL file for #3 (inserting all data in the database), one .SQL file for #4 (all SQL queries and corresponding results) on Gradescope as the solution of "Part 2 of Course Project" Assignment (will be available later)[cite: 86].
* [cite_start]**Deadline for Part 2: 10/30/2025 11:59 pm**[cite: 87].

---

### What You Should Do for Part 3

[cite_start]In Part 3, you'll implement Air Ticket Reservation System as a web-based application[cite: 89]. [cite_start]You must use the table definitions that you created for part 2 (derived from the E-R diagram) unless you need to make some small additions/modifications to support your additional features[cite: 90]. [cite_start]If you do modify the table definitions, you will be responsible for translating the test data/test scenarios (in case we provide) so that it matches your table definitions[cite: 91].

#### REQUIRED Application Use Cases (aka features):

**Home page when not logged-in:**
[cite_start]When the user is not logged-in, the following cases should be available in the home page[cite: 94]:
1.  [cite_start]**View Public Info:** All users, whether logged in or not, can search for future flights based on source city/airport name, destination city/airport name, departure date for one way (departure and return dates for round trip)[cite: 95].
2.  [cite_start]**Register:** 2 types of user registrations (Customer, and Airline Staff) option via forms as mentioned in the part 1 of the project[cite: 96].
3.  [cite_start]**Login:** 2 types of user login (Customer, and Airline Staff)[cite: 97]. [cite_start]Users enters their username (email address will be used as username for customer) - x, and password - y, via forms on login page[cite: 98]. [cite_start]This data is sent as POST parameters to the login-authentication component, which checks whether there is a tuple in the corresponding user's table with username=x and the password = md5(y)[cite: 99]:
    * A. If so, login is successful. [cite_start]A session is initiated with the member's username stored as a session variable[cite: 100]. Optionally, you can store other session variables. [cite_start]Control is redirected to a component that displays the user's home page[cite: 101].
    * B. If not, login is unsuccessful. [cite_start]A message is displayed indicating this to the user[cite: 102].

[cite_start]Once a user has logged in, reservation system should display their home page according to user's role[cite: 103]. [cite_start]Also, after other actions or sequences of related actions, are executed, control will return to component that displays the home page[cite: 104]. [cite_start]The home page should display an error message if the previous action was not successful[cite: 105].

**Customer use cases:**
[cite_start]After logging in successfully a user(customer) may do any of the following use cases[cite: 111]:
1.  [cite_start]**View My flights:** Provide various ways for the user to see flights information which they purchased[cite: 112]. The default should be showing for the future flights. [cite_start]Optionally you may include a way for the user to specify a range of dates, specify destination and/or source airport name or city name etc.[cite: 113].
2.  [cite_start]**Search for flights:** Search for future flights (one way or round trip) based on source city/airport name, destination city/airport name, dates (departure or return)[cite: 114].
3.  [cite_start]**Purchase tickets:** Customer chooses a flight and purchase ticket for this flight, providing all the needed data, via forms[cite: 115]. [cite_start]You may find it easier to implement this along with a use case to search for flights[cite: 116].
4.  [cite_start]**Give Ratings and Comment on previous flights:** Customer will be able to rate and comment on their previous flights (for which they purchased tickets and already took that flight) for the airline they logged in[cite: 117].
5.  [cite_start]**Logout:** The session is destroyed and a "goodbye" page or the login page is displayed[cite: 118].

**Airline Staff use cases:**
[cite_start]After logging in successfully an airline staff may do any of the following use cases[cite: 120]:
1.  [cite_start]**View flights:** Defaults will be showing all the future flights operated by the airline they work for the next 30 days[cite: 121]. [cite_start]Airline Staff will be able to see all the current/future/past flights operated by the airline they work for based range of dates, source/destination airports/city etc. They will be able to see all the customers of a particular flight[cite: 122].
2.  [cite_start]**Create new flights:** Airline Staff creates a new flight, providing all the needed data, via forms[cite: 123]. [cite_start]The application should prevent unauthorized users from doing this action[cite: 124]. [cite_start]Defaults will be showing all the future flights operated by the airline they works for the next 30 days[cite: 125].
3.  [cite_start]**Change Status of flights:** Airline Staff changes a flight status (from on-time to delayed or vice versa) via forms[cite: 126].
4.  [cite_start]**Add airplane in the system:** Airline Staff adds a new airplane, providing all the needed data, via forms[cite: 127]. [cite_start]The application should prevent unauthorized users from doing this action[cite: 128]. [cite_start]In the confirmation page, they will be able to see all the airplanes owned by the airline they work for[cite: 129].
5.  [cite_start]**View flight ratings:** Airline Staff will be able to see each flight's average ratings and all the comments and ratings of that flight given by the customers[cite: 130].
6.  [cite_start]**View reports:** Total amounts of ticket sold based on range of dates/last year/last month etc. Month wise tickets sold in a bar chart/table[cite: 131].
7.  [cite_start]**Logout:** The session is destroyed and a "goodbye" page or the login page is displayed[cite: 132].

#### Additional Requirements:
* [cite_start]You should implement Air ticket reservation system as a web-based application[cite: 134]. [cite_start]If you want to use a DBMS other than MySQL, SQLserver, Oracle, MongoDB or to use a programming language other than Python/Flask, Java/JDBC/Servlets, PHP, C#, node.js, or JavaScript please check with me first[cite: 135].
* [cite_start]**Enforcing complex constraints:** Your air ticket reservation system implementation should prevent users from doing actions they are not allowed to do[cite: 137]. [cite_start]This should be done by querying the database to check whether the user is an airline staff or not before allowing him to create the flight[cite: 139]. [cite_start]You should not rely solely on client-side interactions to enforce the constraint[cite: 141].
* [cite_start]**Session Management:** When a user logs in, a session should be initiated; relevant session variables should be stored[cite: 142]. [cite_start]When the member logs out, the session should be terminated[cite: 143]. [cite_start]Each component executed after the login component should authenticate the session and retrieve the user's pid from a stored session variable[cite: 144].
* [cite_start]**Security:** You must use **prepared statements** if your programming language supports them[cite: 146]. [cite_start]If your programming language does not support prepared statements, Free form inputs should be validated or cleaned to prevent **SQL injection**[cite: 147]. [cite_start]You should take measures to prevent **cross-site scripting vulnerabilities** (sanitize inputs)[cite: 148].
* [cite_start]**UI:** The user interface should be usable, but it does not need to be fancy[cite: 149]. [cite_start]For each type of users, you need to implement different home pages where you only show relevant use cases for that type of users[cite: 150].

**Tips and suggestions for Part 3:**
1.  [cite_start]Use the tables you defined/created in Part 2[cite: 152].
2.  Before you start coding, think about what each component will do. [cite_start]If there are commonalities among many of the use cases, think about how you will modularize your code[cite: 153, 154].
3.  [cite_start]Implement and test the components one at a time[cite: 159].
4.  [cite_start]For testing/debugging you will probably find it useful to execute your SQL queries directly through PHPmyAdmin (if you use MySQL) or using your database provided client program[cite: 161].

[cite_start]**PROGRESS REPORT for Part 3:** A progress report for part 3 will be due on **November 20, 2025 11:59 pm**[cite: 162]. [cite_start]For team projects, you must demonstrate that each team member has written some of the code[cite: 163]. [cite_start]THIS IS A MANDATORY PART OF THE PROJECT AND WILL AFFECT YOUR GRADE[cite: 166].

**Complete Final Project Hand in instructions:** You will hand in:
* [cite_start]Your source codes[cite: 169].
* [cite_start]A list of the files in your application and what's in each file[cite: 170].
* [cite_start]A separate file that lists all of the use cases and the queries executed by them (with brief explanation)[cite: 171].
* [cite_start]For team projects: A summary of who did what[cite: 173].
* [cite_start]Shortly before the project is due, I'll ask you to sign up for a time slot to demonstrate your project to me[cite: 174].

[cite_start]**Deadline for Part 3: 12/04/2025 11:59 pm**[cite: 178].