import pymysql
import io
import reportlab.lib.utils

# Set up PyMySQL to work with Django
pymysql.version_info = (1, 4, 6, 'final', 0)  # Change version to match required version
pymysql.install_as_MySQLdb()

def getStringIO():
    return io.BytesIO()

reportlab.lib.utils.getStringIO = getStringIO