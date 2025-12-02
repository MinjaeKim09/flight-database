# File List and Descriptions

This document lists all files in the Air Ticket Reservation System project and describes their purpose.

## Core Application Files

### `app.py`
Main Flask application file containing all routes and request handlers. Implements:
- Public routes (home, search, login, register, logout)
- Customer routes (home, flights, search, purchase, review)
- Staff routes (home, flights, create_flight, change_status, add_airplane, ratings, reports)

### `config.py`
Database configuration and connection pool management. Handles:
- Database connection using environment variables
- Connection pool initialization and management
- Secret key configuration for Flask sessions

### `models.py`
Database query functions using prepared statements. Contains functions for:
- Flight searches and filtering
- Customer flight retrieval
- Ticket purchase operations
- Staff flight management
- Review and rating operations
- Sales report generation
- Airplane management

### `auth.py`
Authentication and authorization module. Implements:
- Customer and staff authentication
- User registration (customer and staff)
- Session management decorators (@login_required, @customer_required, @staff_required)
- Authorization verification functions

### `utils.py`
Utility functions for security and data processing:
- MD5 password hashing
- Input sanitization (XSS prevention)
- SQL injection prevention helpers

## Configuration Files

### `requirements.txt`
Python package dependencies:
- Flask==3.0.0
- psycopg2-binary==2.9.9
- python-dotenv==1.0.0
- Werkzeug==3.0.1

### `.env.example`
Example environment variables file (users should create `.env` with actual values):
- DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD
- SECRET_KEY

## Template Files

### `templates/base.html`
Base template with navigation bar and common layout structure. Includes:
- Bootstrap navigation bar
- Flash message display
- User-specific navigation menus

### `templates/index.html`
Public home page with flight search functionality.

### `templates/login.html`
Login page for customers and airline staff.

### `templates/register.html`
Registration page with tabs for customer and staff registration.

### Customer Templates (`templates/customer/`)

#### `customer/home.html`
Customer dashboard with links to all customer features.

#### `customer/flights.html`
Display customer's purchased flights with filtering options.

#### `customer/search.html`
Flight search interface for customers with purchase links.

#### `customer/purchase.html`
Ticket purchase form with payment information.

#### `customer/review.html`
Form to rate and comment on past flights.

### Staff Templates (`templates/staff/`)

#### `staff/home.html`
Staff dashboard with links to all staff features.

#### `staff/flights.html`
Display all flights for the airline with customer lists.

#### `staff/create_flight.html`
Form to create a new flight.

#### `staff/change_status.html`
Interface to update flight status.

#### `staff/add_airplane.html`
Form to add a new airplane with confirmation list.

#### `staff/ratings.html`
Display flight ratings and reviews.

#### `staff/reports.html`
Sales reports with charts and monthly breakdown.

## Static Files

### `static/css/style.css`
Custom CSS styles for the application.

### `static/js/main.js`
JavaScript utilities for:
- Auto-dismiss alerts
- Form validation helpers
- Card number and expiration date validation

## Documentation Files

### `README.md`
Setup instructions and project overview.

### `USE_CASES.md`
Detailed documentation of all use cases and their SQL queries.

### `FILE_LIST.md`
This file - description of all project files.

## Database Files (Reference)

### `Create Tables.sql`
SQL script to create all database tables (from Part 2).

### `Insertion Data.sql`
SQL script with sample data (from Part 2).

## Project Structure Summary

```
project_part3/
├── app.py                    # Main Flask application
├── config.py                 # Database configuration
├── models.py                 # Database queries
├── auth.py                   # Authentication
├── utils.py                  # Utilities
├── requirements.txt          # Dependencies
├── templates/                # HTML templates
│   ├── base.html
│   ├── index.html
│   ├── login.html
│   ├── register.html
│   ├── customer/             # Customer templates
│   └── staff/                # Staff templates
├── static/                   # Static files
│   ├── css/
│   └── js/
└── Documentation files
```

## Notes

- All database queries use parameterized queries (%s placeholders) for security
- All user inputs are sanitized before use
- Session management is handled by Flask sessions
- Password hashing uses MD5 as specified in requirements
- The application supports both one-way and round-trip flight searches

