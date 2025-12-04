# GEMINI.md - Context & Instructions

## Project Overview

This project is Part 3 of a database course assignment, implementing an **Online Air Ticket Reservation System**. It is a full-stack web application built with Python (Flask) and PostgreSQL.

**Key Functionality:**
- **Public:** Search for future flights, check flight status, register, login.
- **Customer:** View purchased flights (history/future), purchase tickets, rate/review past flights.
- **Airline Staff:** Manage flights (create, change status), manage fleet (add airplanes), view flight ratings, generate revenue reports.

## Architecture & Technology

*   **Backend:** Python 3.13+ with Flask 3.0.0
*   **Database:** PostgreSQL (accessed via `psycopg2-binary`)
*   **Frontend:** Server-side rendered HTML using Jinja2 templates, styled with CSS.
*   **Authentication:** Session-based (Flask `session`). Passwords hashed (likely MD5 per requirements, though modern standards prefer Argon2/Bcrypt - check `auth.py` logic).
*   **Configuration:** Environment variables via `.env`.

## Key Files & Directories

*   `app.py`: The main entry point. Contains route definitions and controller logic.
*   `models.py`: Database abstraction layer. Contains functions to execute SQL queries.
*   `auth.py`: Handles user authentication (login/registration) for both Customers and Staff.
*   `config.py`: Configuration setup (DB connection pool, secret keys).
*   `utils.py`: Helper functions (e.g., input sanitization).
*   `templates/`: HTML templates organized by user role (`customer/`, `staff/`) and shared files (`base.html`).
*   `static/`: CSS and JavaScript files.
*   `Create Tables.sql`: Schema definition.
*   `Insertion Data.sql`: Initial seed data.
*   `project_instructions.md`: The detailed requirements for the project.
*   `README.md`: General project info and setup steps.

## Development Conventions

*   **Database Interaction:** Raw SQL queries are used (likely via `psycopg2`) rather than an ORM, as per typical database course requirements to demonstrate SQL proficiency.
*   **Security:** 
    *   SQL Injection prevention via parameterized queries/prepared statements.
    *   Input sanitization is expected.
    *   Access control decorators (`@login_required`, `@staff_required`) are used in `app.py`.
*   **Formatting:** Standard Python PEP 8.
*   **Virtual Environment:** A virtual environment (`venv` or `.venv`) is used for dependency management.

## Setup & Running

1.  **Environment:** Ensure `.env` is configured with DB credentials (`DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `SECRET_KEY`).
2.  **Dependencies:** `pip install -r requirements.txt`
3.  **Database:**
    *   Run `Create Tables.sql` to build schema.
    *   Run `Insertion Data.sql` to seed data.
4.  **Start Server:** `python app.py` (Runs on `http://127.0.0.1:5001` by default).

## Notes for AI Assistant

*   **Context:** This is a student project. Adhere strictly to the requirements in `project_instructions.md` (e.g., specific use cases, SQL usage).
*   **Modifications:** When modifying SQL, ensure schema compatibility with `Create Tables.sql`.
*   **Testing:** No automated test suite is currently visible. Verification is manual via the browser or direct SQL queries.
