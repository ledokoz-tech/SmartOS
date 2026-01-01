"""SmartOS API Layer - REST API endpoints and WebSocket handlers."""

from .routes import setup_api_routes
from .websocket import setup_websocket_handlers

__all__ = ['setup_api_routes', 'setup_websocket_handlers']
