"""SmartOS API Routes - REST API endpoints."""

import json
from typing import Dict, Any
from aiohttp import web
from homeassistant.core import HomeAssistant


async def setup_api_routes(hass: HomeAssistant, app: web.Application) -> None:
    """Set up SmartOS API routes."""

    # SmartOS status endpoint
    async def get_smartos_status(request: web.Request) -> web.Response:
        """Get SmartOS system status."""
        return web.json_response({
            "status": "online",
            "version": "1.0.0",
            "homeassistant_version": hass.version,
            "integrations_count": len(hass.config_entries.async_entries()),
        })

    # SmartOS configuration endpoint
    async def get_smartos_config(request: web.Request) -> web.Response:
        """Get SmartOS configuration."""
        return web.json_response({
            "branding": {
                "name": "SmartOS",
                "theme": "smartos"
            },
            "features": [
                "user_management",
                "device_discovery",
                "automations",
                "dashboards"
            ]
        })

    # Device management endpoints
    async def get_devices(request: web.Request) -> web.Response:
        """Get all devices."""
        devices = []
        for entry in hass.config_entries.async_entries():
            devices.append({
                "id": entry.entry_id,
                "domain": entry.domain,
                "title": entry.title,
                "state": entry.state.value,
            })
        return web.json_response({"devices": devices})

    # User management endpoints
    async def get_users(request: web.Request) -> web.Response:
        """Get SmartOS users."""
        # This would integrate with SmartOS user management
        return web.json_response({
            "users": [
                {
                    "id": "admin",
                    "username": "admin",
                    "role": "owner",
                    "active": True
                }
            ]
        })

    # Register routes
    app.router.add_get('/api/smartos/status', get_smartos_status)
    app.router.add_get('/api/smartos/config', get_smartos_config)
    app.router.add_get('/api/smartos/devices', get_devices)
    app.router.add_get('/api/smartos/users', get_users)
