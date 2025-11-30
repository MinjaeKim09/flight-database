import hashlib
import html
import re


def hash_password(password):
    """Hash password using MD5 as specified in requirements."""
    return hashlib.md5(password.encode()).hexdigest()


def sanitize_input(text):
    """Sanitize user input to prevent XSS attacks."""
    if text is None:
        return None
    # Convert to string and escape HTML
    text = str(text)
    # Escape HTML special characters
    text = html.escape(text)
    # Remove any remaining script tags
    text = re.sub(r'<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>', '', text, flags=re.IGNORECASE)
    return text


def sanitize_sql_input(text):
    """Basic SQL injection prevention - ensure input is safe for SQL."""
    if text is None:
        return None
    text = str(text)
    # Remove SQL comment markers
    text = text.replace('--', '')
    text = text.replace('/*', '')
    text = text.replace('*/', '')
    # Remove semicolons that could end statements
    text = text.replace(';', '')
    return text

