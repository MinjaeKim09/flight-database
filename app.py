from flask import Flask, render_template, request, redirect, url_for, session, flash, jsonify
from datetime import datetime, timedelta
from config import init_db_pool, SECRET_KEY
from auth import (authenticate_customer, authenticate_staff, register_customer, register_staff,
                 login_required, customer_required, staff_required, verify_staff_airline)
from models import *
from utils import sanitize_input

app = Flask(__name__)
app.secret_key = SECRET_KEY

# Initialize database pool on startup
init_db_pool()


@app.route('/')
def index():
    """Public home page with flight search."""
    if 'user_type' in session:
        if session['user_type'] == 'customer':
            return redirect(url_for('customer_home'))
        elif session['user_type'] == 'staff':
            return redirect(url_for('staff_home'))
    
    return render_template('index.html')


@app.route('/search', methods=['GET', 'POST'])
def search():
    """Public flight search."""
    if request.method == 'POST':
        departure_city = sanitize_input(request.form.get('departure_city', ''))
        departure_airport = sanitize_input(request.form.get('departure_airport', ''))
        arrival_city = sanitize_input(request.form.get('arrival_city', ''))
        arrival_airport = sanitize_input(request.form.get('arrival_airport', ''))
        departure_date = request.form.get('departure_date', '')
        return_date = request.form.get('return_date', '')
        round_trip = request.form.get('round_trip') == 'on'
        
        flights = search_flights(
            departure_city=departure_city if departure_city else None,
            departure_airport=departure_airport if departure_airport else None,
            arrival_city=arrival_city if arrival_city else None,
            arrival_airport=arrival_airport if arrival_airport else None,
            departure_date=departure_date if departure_date else None,
            return_date=return_date if return_date and round_trip else None,
            round_trip=round_trip,
            future_only=True
        )
        
        return_flights = []
        if round_trip and return_date:
            return_flights = search_flights(
                departure_city=arrival_city if arrival_city else None,
                departure_airport=arrival_airport if arrival_airport else None,
                arrival_city=departure_city if departure_city else None,
                arrival_airport=departure_airport if departure_airport else None,
                departure_date=return_date,
                future_only=True
            )
        
        return render_template('index.html', flights=flights, return_flights=return_flights,
                             round_trip=round_trip)
    
    return redirect(url_for('index'))


@app.route('/public_search', methods=['POST'])
def public_search():
    """Public flight status search."""
    flight_num = sanitize_input(request.form.get('flight_num', ''))
    dep_date = request.form.get('dep_date', '')
    
    flights = []
    if flight_num and dep_date:
        flights = get_public_flight_status(flight_num, dep_date)
    
    return render_template('index.html', flights=flights)


@app.route('/login', methods=['GET', 'POST'])
def login():
    """Login page for customers and staff."""
    if request.method == 'POST':
        user_type = request.form.get('user_type')
        username = sanitize_input(request.form.get('username', '').strip())
        password = request.form.get('password', '')
        
        if user_type == 'customer':
            user = authenticate_customer(username, password)
            if user:
                session['user_type'] = 'customer'
                session['email'] = user['email']
                session['name'] = user['name']
                return redirect(url_for('customer_home'))
            else:
                flash('Invalid email or password', 'error')
        elif user_type == 'staff':
            user = authenticate_staff(username, password)
            if user:
                session['user_type'] = 'staff'
                session['username'] = user['username']
                session['name'] = f"{user['first_name']} {user['last_name']}"
                session['airline_name'] = user['airline_name']
                return redirect(url_for('staff_home'))
            else:
                flash('Invalid username or password', 'error')
    
    return render_template('login.html')


@app.route('/register', methods=['GET', 'POST'])
def register():
    """Registration page for customers and staff."""
    if request.method == 'POST':
        user_type = request.form.get('user_type')
        
        if user_type == 'customer':
            email = sanitize_input(request.form.get('email', ''))
            password = request.form.get('password', '')
            name = sanitize_input(request.form.get('name', ''))
            address_number = sanitize_input(request.form.get('address_number', ''))
            address_street = sanitize_input(request.form.get('address_street', ''))
            address_city = sanitize_input(request.form.get('address_city', ''))
            address_state = sanitize_input(request.form.get('address_state', ''))
            phone_number = sanitize_input(request.form.get('phone_number', ''))
            passport_number = sanitize_input(request.form.get('passport_number', ''))
            passport_expiration = request.form.get('passport_expiration', '')
            passport_country = sanitize_input(request.form.get('passport_country', ''))
            date_of_birth = request.form.get('date_of_birth', '')
            
            success, message = register_customer(
                email, password, name, address_number, address_street,
                address_city, address_state, phone_number, passport_number,
                passport_expiration, passport_country, date_of_birth
            )
            
            if success:
                flash('Registration successful! Please login.', 'success')
                return redirect(url_for('login'))
            else:
                flash(f'Registration failed: {message}', 'error')
        
        elif user_type == 'staff':
            username = sanitize_input(request.form.get('username', ''))
            password = request.form.get('password', '')
            airline_name = sanitize_input(request.form.get('airline_name', ''))
            first_name = sanitize_input(request.form.get('first_name', ''))
            last_name = sanitize_input(request.form.get('last_name', ''))
            email = sanitize_input(request.form.get('email', ''))
            date_of_birth = request.form.get('date_of_birth', '')
            phone_numbers = request.form.getlist('phone_number')
            
            success, message = register_staff(
                username, password, airline_name, first_name, last_name,
                email, date_of_birth, phone_numbers
            )
            
            if success:
                flash('Registration successful! Please login.', 'success')
                return redirect(url_for('login'))
            else:
                flash(f'Registration failed: {message}', 'error')
    
    airlines = get_airlines()
    return render_template('register.html', airlines=airlines)


@app.route('/logout')
def logout():
    """Logout and clear session."""
    session.clear()
    flash('You have been logged out successfully.', 'success')
    return redirect(url_for('index'))


# ========== CUSTOMER ROUTES ==========

@app.route('/customer/home')
@customer_required
def customer_home():
    """Customer dashboard."""
    return render_template('customer/home.html')


@app.route('/customer/flights', methods=['GET', 'POST'])
@customer_required
def customer_flights():
    """View customer's flights."""
    email = session['email']
    
    if request.method == 'POST':
        start_date = request.form.get('start_date', '')
        end_date = request.form.get('end_date', '')
        departure_airport = sanitize_input(request.form.get('departure_airport', ''))
        arrival_airport = sanitize_input(request.form.get('arrival_airport', ''))
        departure_city = sanitize_input(request.form.get('departure_city', ''))
        arrival_city = sanitize_input(request.form.get('arrival_city', ''))
        future_only = request.form.get('future_only') != 'off'
        
        flights = get_customer_flights(
            email, start_date if start_date else None,
            end_date if end_date else None,
            departure_airport if departure_airport else None,
            arrival_airport if arrival_airport else None,
            departure_city if departure_city else None,
            arrival_city if arrival_city else None,
            future_only
        )
    else:
        flights = get_customer_flights(email, future_only=True)
    
    return render_template('customer/flights.html', flights=flights)


@app.route('/customer/search', methods=['GET', 'POST'])
@customer_required
def customer_search():
    """Customer flight search."""
    if request.method == 'POST':
        departure_city = sanitize_input(request.form.get('departure_city', ''))
        departure_airport = sanitize_input(request.form.get('departure_airport', ''))
        arrival_city = sanitize_input(request.form.get('arrival_city', ''))
        arrival_airport = sanitize_input(request.form.get('arrival_airport', ''))
        departure_date = request.form.get('departure_date', '')
        return_date = request.form.get('return_date', '')
        round_trip = request.form.get('round_trip') == 'on'
        
        flights = search_flights(
            departure_city=departure_city if departure_city else None,
            departure_airport=departure_airport if departure_airport else None,
            arrival_city=arrival_city if arrival_city else None,
            arrival_airport=arrival_airport if arrival_airport else None,
            departure_date=departure_date if departure_date else None,
            return_date=return_date if return_date and round_trip else None,
            round_trip=round_trip,
            future_only=True
        )
        
        return_flights = []
        if round_trip and return_date:
            return_flights = search_flights(
                departure_city=arrival_city if arrival_city else None,
                departure_airport=arrival_airport if arrival_airport else None,
                arrival_city=departure_city if departure_city else None,
                arrival_airport=departure_airport if departure_airport else None,
                departure_date=return_date,
                future_only=True
            )
        
        return render_template('customer/search.html', flights=flights,
                             return_flights=return_flights, round_trip=round_trip)
    
    return render_template('customer/search.html')


@app.route('/customer/purchase', methods=['GET', 'POST'])
@customer_required
def customer_purchase():
    """Purchase a ticket."""
    if request.method == 'GET':
        airline_name = request.args.get('airline_name')
        flight_number = request.args.get('flight_number')
        departure_timestamp = request.args.get('departure_timestamp')
        
        if not all([airline_name, flight_number, departure_timestamp]):
            flash('Invalid flight information', 'error')
            return redirect(url_for('customer_search'))
        
        # Get flight details
        flights = search_flights(future_only=True)
        flight = None
        for f in flights:
            if (f['airline_name'] == airline_name and
                f['flight_number'] == flight_number and
                str(f['departure_timestamp']) == departure_timestamp):
                flight = f
                break
        
        if not flight:
            flash('Flight not found', 'error')
            return redirect(url_for('customer_search'))
        
        available, seats_left = check_seat_availability(airline_name, flight_number, departure_timestamp)
        if not available:
            flash('No seats available for this flight', 'error')
            return redirect(url_for('customer_search'))
        
        return render_template('customer/purchase.html', flight=flight, seats_left=seats_left)
    
    elif request.method == 'POST':
        email = session['email']
        airline_name = sanitize_input(request.form.get('airline_name', ''))
        flight_number = sanitize_input(request.form.get('flight_number', ''))
        departure_timestamp = request.form.get('departure_timestamp', '')
        card_number = sanitize_input(request.form.get('card_number', ''))
        card_expiration = sanitize_input(request.form.get('card_expiration', ''))
        card_type = request.form.get('card_type', '')
        card_name = sanitize_input(request.form.get('card_name', ''))
        
        success, result = purchase_ticket(
            email, airline_name, flight_number, departure_timestamp,
            card_number, card_expiration, card_type, card_name
        )
        
        if success:
            flash(f'Ticket purchased successfully! Ticket ID: {result}', 'success')
            return redirect(url_for('customer_flights'))
        else:
            flash(f'Purchase failed: {result}', 'error')
            return redirect(url_for('customer_purchase',
                                  airline_name=airline_name,
                                  flight_number=flight_number,
                                  departure_timestamp=departure_timestamp))


@app.route('/customer/review', methods=['GET', 'POST'])
@customer_required
def customer_review():
    """Rate and comment on past flights."""
    email = session['email']
    
    if request.method == 'POST':
        airline_name = sanitize_input(request.form.get('airline_name', ''))
        flight_number = sanitize_input(request.form.get('flight_number', ''))
        departure_timestamp = request.form.get('departure_timestamp', '')
        rate = int(request.form.get('rate', 0))
        comment = sanitize_input(request.form.get('comment', ''))
        
        success, message = submit_review(
            email, airline_name, flight_number, departure_timestamp, rate, comment
        )
        
        if success:
            flash('Review submitted successfully!', 'success')
        else:
            flash(f'Failed to submit review: {message}', 'error')
        
        return redirect(url_for('customer_review'))
    
    flights = get_past_customer_flights(email)
    return render_template('customer/review.html', flights=flights)


# ========== STAFF ROUTES ==========

@app.route('/staff/home')
@staff_required
def staff_home():
    """Staff dashboard."""
    return render_template('staff/home.html')


@app.route('/staff/flights', methods=['GET', 'POST'])
@staff_required
def staff_flights():
    """View flights for staff's airline."""
    airline_name = session['airline_name']
    
    if request.method == 'POST':
        start_date = request.form.get('start_date', '')
        end_date = request.form.get('end_date', '')
        departure_airport = sanitize_input(request.form.get('departure_airport', ''))
        arrival_airport = sanitize_input(request.form.get('arrival_airport', ''))
        departure_city = sanitize_input(request.form.get('departure_city', ''))
        arrival_city = sanitize_input(request.form.get('arrival_city', ''))
        future_only = request.form.get('future_only') != 'off'
        
        flights = get_staff_flights(
            airline_name, start_date if start_date else None,
            end_date if end_date else None,
            departure_airport if departure_airport else None,
            arrival_airport if arrival_airport else None,
            departure_city if departure_city else None,
            arrival_city if arrival_city else None,
            future_only
        )
    else:
        flights = get_staff_flights(airline_name, future_only=True)
    
    # Get customers for each flight
    flight_customers = {}
    for flight in flights:
        customers = get_flight_customers(
            flight['airline_name'],
            flight['flight_number'],
            flight['departure_timestamp']
        )
        key = f"{flight['airline_name']}_{flight['flight_number']}_{flight['departure_timestamp']}"
        flight_customers[key] = customers
    
    return render_template('staff/flights.html', flights=flights, flight_customers=flight_customers)


@app.route('/staff/create_flight', methods=['GET', 'POST'])
@staff_required
def staff_create_flight():
    """Create a new flight."""
    airline_name = session['airline_name']
    
    if request.method == 'POST':
        flight_number = sanitize_input(request.form.get('flight_number', ''))
        departure_timestamp = request.form.get('departure_timestamp', '')
        arrival_timestamp = request.form.get('arrival_timestamp', '')
        departure_airport = sanitize_input(request.form.get('departure_airport', ''))
        arrival_airport = sanitize_input(request.form.get('arrival_airport', ''))
        uid = sanitize_input(request.form.get('uid', ''))
        base_price = float(request.form.get('base_price', 0))
        status = request.form.get('status', 'on-time')
        
        success, message = create_flight(
            airline_name, flight_number, departure_timestamp, arrival_timestamp,
            departure_airport, arrival_airport, uid, base_price, status
        )
        
        if success:
            flash('Flight created successfully!', 'success')
            return redirect(url_for('staff_flights'))
        else:
            flash(f'Failed to create flight: {message}', 'error')
    
    airplanes = get_airline_airplanes(airline_name)
    airports = get_airports()
    return render_template('staff/create_flight.html', airplanes=airplanes, airports=airports)


@app.route('/staff/change_status', methods=['GET', 'POST'])
@staff_required
def staff_change_status():
    """Change flight status."""
    airline_name = session['airline_name']
    
    if request.method == 'POST':
        flight_number = sanitize_input(request.form.get('flight_number', ''))
        departure_timestamp = request.form.get('departure_timestamp', '')
        status = request.form.get('status', '')
        
        success, message = update_flight_status(
            airline_name, flight_number, departure_timestamp, status
        )
        
        if success:
            flash('Flight status updated successfully!', 'success')
        else:
            flash(f'Failed to update status: {message}', 'error')
        
        return redirect(url_for('staff_change_status'))
    
    flights = get_staff_flights(airline_name, future_only=False)
    return render_template('staff/change_status.html', flights=flights)


@app.route('/staff/add_airplane', methods=['GET', 'POST'])
@staff_required
def staff_add_airplane():
    """Add a new airplane."""
    airline_name = session['airline_name']
    
    if request.method == 'POST':
        uid = sanitize_input(request.form.get('uid', ''))
        seat_no = int(request.form.get('seat_no', 0))
        manufacturer = sanitize_input(request.form.get('manufacturer', ''))
        age = int(request.form.get('age', 0))
        
        success, message = add_airplane(airline_name, uid, seat_no, manufacturer, age)
        
        if success:
            flash('Airplane added successfully!', 'success')
            return redirect(url_for('staff_add_airplane'))
        else:
            flash(f'Failed to add airplane: {message}', 'error')
    
    airplanes = get_airline_airplanes(airline_name)
    return render_template('staff/add_airplane.html', airplanes=airplanes)


@app.route('/staff/ratings', methods=['GET', 'POST'])
@staff_required
def staff_ratings():
    """View flight ratings."""
    airline_name = session['airline_name']
    
    flight_number = request.args.get('flight_number')
    departure_timestamp = request.args.get('departure_timestamp')
    
    flights = get_flight_ratings(airline_name)
    
    reviews = None
    if flight_number and departure_timestamp:
        reviews = get_flight_reviews(airline_name, flight_number, departure_timestamp)
    
    return render_template('staff/ratings.html', flights=flights, reviews=reviews,
                         selected_flight_number=flight_number,
                         selected_departure_timestamp=departure_timestamp)


@app.route('/staff/reports', methods=['GET', 'POST'])
@staff_required
def staff_reports():
    """View sales reports."""
    airline_name = session['airline_name']
    
    if request.method == 'POST':
        period = request.form.get('period', 'custom')
        start_date = None
        end_date = None
        
        if period == 'last_month':
            end_date = datetime.now().date()
            start_date = (datetime.now() - timedelta(days=30)).date()
        elif period == 'last_year':
            end_date = datetime.now().date()
            start_date = (datetime.now() - timedelta(days=365)).date()
        elif period == 'custom':
            start_date = request.form.get('start_date', '')
            end_date = request.form.get('end_date', '')
            start_date = datetime.strptime(start_date, '%Y-%m-%d').date() if start_date else None
            end_date = datetime.strptime(end_date, '%Y-%m-%d').date() if end_date else None
        
        report = get_sales_report(airline_name, start_date, end_date)
    else:
        # Default: last month
        end_date = datetime.now().date()
        start_date = (datetime.now() - timedelta(days=30)).date()
        report = get_sales_report(airline_name, start_date, end_date)
    
    return render_template('staff/reports.html', report=report)


if __name__ == '__main__':
    app.run(debug=True, port=5001)

