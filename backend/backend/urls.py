from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.http import JsonResponse

# Simple view to handle the root URL
def api_root(request):
    return JsonResponse({
        'status': 'ok',
        'message': 'TEC System API is running',
        'endpoints': {
            'api': '/api/',
            'admin': '/admin/'
        }
    })

urlpatterns = [
    path('', api_root, name='api_root'),  # Add this line for root URL
    path('admin/', admin.site.urls),
    path('api/', include('base.urls')),
    path('apiapi/', include('base.urls')),  # Support for apiapi prefix
    path('api/api/', include('base.urls')),  # Support for double api prefix
]

# Serve media files during development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
