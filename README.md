# Online Air Ticket Reservation System

## Project Overview
This project is an **Online Air Ticket Reservation System** designed for a database course. It provides a comprehensive platform for customers to book flights and for airline staff to manage flight operations.

The system supports two types of users:
1.  **Customers:** Can search for flights, purchase tickets, view their flight history, and rate/review flights.
2.  **Airline Staff:** Can manage flights (create, update status), add airplanes, view flight ratings, and generate sales reports.

## Features

### Public Access
*   **Flight Search:** Search for future flights (one-way or round-trip) based on city, airport, and dates.
*   **Flight Status:** Check the status of a specific flight.
*   **Registration:** Sign up as a new Customer or Airline Staff.
*   **Login:** Secure login for both user types.

### Customer Features
*   **My Flights:** View purchased flight history (past and future).
*   **Purchase Tickets:** Book tickets for available flights using credit/debit cards.
*   **Rate & Review:** specific flights they have taken.

### Airline Staff Features
*   **Flight Management:** Create new flights and update flight status (e.g., on-time, delayed).
*   **Fleet Management:** Add new airplanes to the airline's fleet.
*   **View Ratings:** Monitor average ratings and customer comments for flights.
*   **Reports:** View sales reports and ticket sales data over specific periods (month, year, custom range).

## Technology Stack
*   **Backend:** Python, Flask
*   **Database:** PostgreSQL
*   **Frontend:** HTML, CSS, JavaScript (Jinja2 templates)
*   **Authentication:** Session-based authentication

## Setup Instructions

### Prerequisites
*   Python 3.8+
*   PostgreSQL

### Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    cd <repository_directory>
    ```

2.  **Create and activate a virtual environment:**
    ```bash
    # macOS/Linux
    python3 -m venv venv
    source venv/bin/activate

    # Windows
    python -m venv venv
    .\venv\Scripts\activate
    ```

3.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

4.  **Database Setup:**
    *   Ensure PostgreSQL is running.
    *   Create a database (e.g., `airline_db`).
    *   Run the SQL scripts to set up the schema and initial data:
        ```bash
        psql -U <username> -d airline_db -f "Create Tables.sql"
        psql -U <username> -d airline_db -f "Insertion Data.sql"
        ```

5.  **Environment Configuration:**
    *   Create a `.env` file in the root directory (based on the variables used in `config.py`).
    *   Example `.env`:
        ```
        DB_HOST=localhost
        DB_PORT=5432
        DB_NAME=airline_db
        DB_USER=your_postgres_user
        DB_PASSWORD=your_postgres_password
        SECRET_KEY=your_secret_key
        ```

### Running the Application

1.  **Start the Flask server:**
    ```bash
    python app.py
    ```

2.  **Access the application:**
    *   Open your web browser and navigate to `http://127.0.0.1:5001`.

## Project Structure
*   `app.py`: Main application entry point and route definitions.
*   `auth.py`: Authentication logic (login, register).
*   `models.py`: Database models and query functions.
*   `config.py`: Configuration settings.
*   `templates/`: HTML templates for the UI.
*   `static/`: Static files (CSS, JS).
*   `Create Tables.sql`: SQL script for creating database tables.
*   `Insertion Data.sql`: SQL script for initial data population.

## License
[License Information]
