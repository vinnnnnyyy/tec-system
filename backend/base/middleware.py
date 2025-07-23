from django.utils.deprecation import MiddlewareMixin

class CSPMiddleware(MiddlewareMixin):
    def process_response(self, request, response):
        # For now, let's disable CSP to allow all external resources
        # This is temporary until we properly configure all domains
        if not response.has_header('Content-Security-Policy'):
            # More permissive CSP for development/testing with explicit domains
            csp_policy = (
                "default-src 'self' 'unsafe-inline' 'unsafe-eval' data: https:; "
                "script-src 'self' 'unsafe-inline' 'unsafe-eval' https: data: https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; "
                "style-src 'self' 'unsafe-inline' https: data: https://cdn.jsdelivr.net https://cdnjs.cloudflare.com https://fonts.googleapis.com; "
                "font-src 'self' https: data: https://fonts.gstatic.com https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; "
                "img-src 'self' data: https: blob:; "
                "connect-src 'self' https: wss: data:; "
                "media-src 'self' https: data: blob:; "
                "frame-src 'self' https:; "
                "object-src 'none'; "
                "base-uri 'self';"
            )
            response['Content-Security-Policy'] = csp_policy
        return response
