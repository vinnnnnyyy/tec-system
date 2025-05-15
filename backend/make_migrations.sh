#!/bin/bash
# Script to generate migrations for model changes

echo "Creating migrations for model changes..."
python manage.py makemigrations

echo "Applying migrations to database..."
python manage.py migrate

echo "Migration complete!" 