// Main JavaScript file for Air Ticket Reservation System

// Auto-dismiss alerts after 5 seconds
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
});

// Form validation helpers
function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

function validateCardNumber(cardNumber) {
    // Remove spaces and dashes
    const cleaned = cardNumber.replace(/[\s-]/g, '');
    // Check if it's all digits and between 13-19 digits
    return /^\d{13,19}$/.test(cleaned);
}

function validateExpirationDate(expDate) {
    // Format: MM/YY
    const re = /^(0[1-9]|1[0-2])\/\d{2}$/;
    return re.test(expDate);
}

// Add form validation for purchase form
document.addEventListener('DOMContentLoaded', function() {
    const purchaseForm = document.querySelector('form[action*="customer_purchase"]');
    if (purchaseForm) {
        purchaseForm.addEventListener('submit', function(e) {
            const cardNumber = purchaseForm.querySelector('input[name="card_number"]').value;
            const cardExpiration = purchaseForm.querySelector('input[name="card_expiration"]').value;
            
            if (!validateCardNumber(cardNumber)) {
                e.preventDefault();
                alert('Please enter a valid card number (13-19 digits)');
                return false;
            }
            
            if (!validateExpirationDate(cardExpiration)) {
                e.preventDefault();
                alert('Please enter expiration date in MM/YY format');
                return false;
            }
        });
    }
});

// Persist background animations across page loads (Clouds, Planes, Sun)
document.addEventListener('DOMContentLoaded', function() {
    const ANIMATION_START_KEY = 'skyHighAnimationStart';
    let startTime = sessionStorage.getItem(ANIMATION_START_KEY);

    if (!startTime) {
        startTime = Date.now();
        sessionStorage.setItem(ANIMATION_START_KEY, startTime);
    } else {
        startTime = parseInt(startTime, 10);
    }

    // Calculate how many seconds have passed since the first page load
    const elapsedSeconds = (Date.now() - startTime) / 1000;

    // Select all animated background elements
    const animatedElements = document.querySelectorAll('.sun, .cloud, .plane');

    animatedElements.forEach(el => {
        // Get the current computed animation delay (from CSS)
        const computedStyle = window.getComputedStyle(el);
        const originalDelayStr = computedStyle.animationDelay;
        let originalDelay = 0;

        // Parse the delay (handles 's' and 'ms')
        if (originalDelayStr) {
            if (originalDelayStr.includes('ms')) {
                originalDelay = parseFloat(originalDelayStr) / 1000;
            } else if (originalDelayStr.includes('s')) {
                originalDelay = parseFloat(originalDelayStr);
            }
        }

        // Adjust the delay: subtract elapsed time to "fast forward" the animation
        // New Delay = Original CSS Delay - Elapsed Time
        el.style.animationDelay = `${originalDelay - elapsedSeconds}s`;
    });
});

