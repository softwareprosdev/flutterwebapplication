#!/usr/bin/env python3
"""
Health check script for Nginx
Returns 0 if Nginx is serving Flutter web app correctly
"""

import sys
import socket
import os

def check_health():
    # Check if index.html exists
    if not os.path.exists('/usr/share/nginx/html/index.html'):
        print("ERROR: index.html not found")
        return False
    
    # Try to connect to port 8080
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(2)
        result = sock.connect_ex(('127.0.0.1', 8080))
        sock.close()
        
        if result == 0:
            return True
        else:
            print(f"ERROR: Port 8080 not accepting connections (code: {result})")
            return False
    except Exception as e:
        print(f"ERROR: {e}")
        return False

if __name__ == '__main__':
    sys.exit(0 if check_health() else 1)