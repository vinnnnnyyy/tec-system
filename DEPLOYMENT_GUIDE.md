# TEC System Deployment Guide
## PythonAnywhere (Backend) + Netlify (Frontend)

### 🚀 Backend Deployment on PythonAnywhere

#### 1. Upload Your Code
1. Log in to [PythonAnywhere](https://www.pythonanywhere.com/)
2. Go to **Files** tab
3. Upload your `backend` folder to `/home/wmsutec/tec-system/backend`

#### 2. Set Up Virtual Environment
Open a **Bash console** and run:
```bash
cd /home/wmsutec/tec-system/backend
python3.10 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

#### 3. Set Up MySQL Database
1. Go to **Databases** tab in PythonAnywhere
2. Create a new MySQL database: `wmsutec$tecdb`
3. Note the database password
4. Update `.env.production` with your database credentials

#### 4. Configure Environment
1. Copy `.env.production` to `.env` in your backend folder
2. Update the values:
```bash
SECRET_KEY=your-very-secure-secret-key-here
DEBUG=False
DB_PASSWORD=your-database-password-from-pythonanywhere
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password
```

#### 5. Run Migrations
```bash
cd /home/wmsutec/tec-system/backend
source venv/bin/activate
python manage.py migrate
python manage.py collectstatic --noinput
python manage.py createsuperuser
```

#### 6. Configure Web App
1. Go to **Web** tab → **Add a new web app**
2. Choose **Manual configuration** → **Python 3.10**
3. Set **Source code**: `/home/wmsutec/tec-system/backend`
4. Set **Virtualenv**: `/home/wmsutec/tec-system/backend/venv`

#### 7. Configure WSGI File
1. Click on **WSGI configuration file** link
2. Replace content with the provided `wsgi_pythonanywhere.py` content
3. Update the path to your project directory

#### 8. Configure Static Files
1. In **Web** tab, add static files mapping:
   - URL: `/static/`
   - Directory: `/home/wmsutec/tec-system/backend/staticfiles`

#### 9. Reload Web App
Click **Reload** button on Web tab

Your backend will be available at: `https://wmsutec.pythonanywhere.com`

---

### 🎨 Frontend Deployment on Netlify

#### 1. Push to GitHub
Ensure your code is pushed to GitHub repository.

#### 2. Connect Netlify to GitHub
1. Go to [Netlify](https://www.netlify.com/)
2. Sign up/login with GitHub
3. Click **Add new site** → **Import an existing project**
4. Choose GitHub and select your repository

#### 3. Configure Build Settings
- **Base directory**: `frontend`
- **Build command**: `npm run build`
- **Publish directory**: `frontend/dist`

#### 4. Environment Variables
Add in Netlify dashboard:
- Key: `VITE_API_URL`
- Value: `https://wmsutec.pythonanywhere.com`

#### 5. Custom Domain (Optional)
1. Go to **Site settings** → **Domain management**
2. Add custom domain: `wmsutec.netlify.app`

#### 6. Deploy
Click **Deploy site**

Your frontend will be available at: `https://wmsutec.netlify.app`

---

### 🔧 Configuration Files Summary

#### Backend Files:
- `.env.production` - Production environment variables
- `wsgi_pythonanywhere.py` - WSGI configuration for PythonAnywhere
- `settings.py` - Updated with production settings

#### Frontend Files:
- `netlify.toml` - Netlify configuration
- `.env.production` - Production environment variables
- `.env` - Updated with production API URL

#### Updated Settings:
- **CORS origins**: Includes Netlify domain
- **Allowed hosts**: Includes both domains
- **API URL**: Points to PythonAnywhere backend

---

### 🚨 Important Notes

1. **Security**: 
   - Never commit `.env` files with real credentials
   - Use strong, unique secret keys
   - Set DEBUG=False in production

2. **Database**:
   - Use MySQL on PythonAnywhere (included in free plan)
   - Run migrations after uploading code

3. **Static Files**:
   - Run `collectstatic` after any changes
   - Configure static files mapping in PythonAnywhere

4. **CORS**:
   - Frontend domain is whitelisted in Django settings
   - Both domains are in ALLOWED_HOSTS

5. **Environment Variables**:
   - Set all required variables in both platforms
   - Use Netlify's environment variables for frontend
   - Use PythonAnywhere's environment variables for backend

### 🆘 Troubleshooting

#### Common Issues:
- **CORS errors**: Check CORS_ALLOWED_ORIGINS in settings.py
- **Static files not loading**: Run collectstatic and check static files mapping
- **Database connection**: Verify database credentials in .env
- **502 errors**: Check WSGI configuration and virtual environment path

#### Testing:
1. Test backend: Visit `https://wmsutec.pythonanywhere.com/admin/`
2. Test frontend: Visit `https://wmsutec.netlify.app`
3. Test API connection: Check browser network tab for API calls

Your TEC System is now deployed and ready for production! 🎉
