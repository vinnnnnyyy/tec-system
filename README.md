# Django + Vue.js + TailwindCSS Project

This is a full-stack web application using Django for the backend, Vue.js for the frontend, and TailwindCSS for styling.

## Project Structure

```
project/
├── backend/           # Django backend
│   ├── api/           # Django REST API app
│   ├── core/          # Django project settings
│   ├── venv/          # Python virtual environment
│   ├── manage.py      # Django management script
│   └── requirements.txt # Python dependencies
└── frontend/          # Vue.js frontend
    ├── src/           # Vue source files
    ├── public/        # Static assets
    ├── package.json   # Node.js dependencies
    └── vite.config.js # Vite configuration
```

## Backend Setup

1. Navigate to the backend directory:
   ```
   cd backend
   ```

2. Create and activate a virtual environment:
   ```
   python -m venv venv
   venv\Scripts\activate  # Windows
   source venv/bin/activate  # macOS/Linux
   ```

3. Install dependencies:
   ```
   pip install -r requirements.txt
   ```

4. Run migrations:
   ```
   python manage.py migrate
   ```

5. Start the development server:
   ```
   python manage.py runserver
   ```

The Django API will be available at http://localhost:8000/api/

## Frontend Setup

1. Navigate to the frontend directory:
   ```
   cd frontend
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Start the development server:
   ```
   npm run dev
   ```

The Vue.js app will be available at http://localhost:5173/

## Features

- RESTful API with Django REST Framework
- Modern UI with Vue.js and TailwindCSS
- Task management functionality
- Cross-Origin Resource Sharing (CORS) configured

## API Endpoints

- `GET /api/tasks/` - List all tasks
- `POST /api/tasks/` - Create a new task
- `GET /api/tasks/{id}/` - Retrieve a specific task
- `PUT /api/tasks/{id}/` - Update a specific task
- `DELETE /api/tasks/{id}/` - Delete a specific task # tec
"# project-tec" 
