#!/var/www/wmsutec_pythonanywhere_com_wsgi.py

import os
import sys

# Add your project directory to the sys.path
path = '/home/wmsutec/tec-system/backend'
if path not in sys.path:
    sys.path.insert(0, path)

# Set environment variables
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')

# Load environment variables from .env file
from dotenv import load_dotenv
load_dotenv(os.path.join(path, '.env.production'))

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
