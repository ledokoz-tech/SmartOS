"""SmartOS integration for Home Assistant."""

import logging
from homeassistant.core import HomeAssistant
from homeassistant.config_entries import ConfigEntry

from ..api import setup_api_routes, setup_websocket_handlers

_LOGGER = logging.getLogger(__name__)

DOMAIN = "smartos"

async def async_setup(hass: HomeAssistant, config: dict) -> bool:
    """Set up SmartOS integration."""
    _LOGGER.info("Setting up SmartOS integration")

    # Store SmartOS config
    hass.data[DOMAIN] = {
        "version": "1.0.0",
        "features": ["api", "websocket", "branding"]
    }

    # Set up API routes if HTTP is available
    if "http" in hass.config.components:
        from homeassistant.components.http import HomeAssistantHTTP
        http = hass.data.get("http", {}).get("server")
        if http:
            await setup_api_routes(hass, http.app)

    # Set up WebSocket handlers
    setup_websocket_handlers(hass)

    return True


async def async_setup_entry(hass: HomeAssistant, entry: ConfigEntry) -> bool:
    """Set up SmartOS from a config entry."""
    _LOGGER.info("Setting up SmartOS from config entry: %s", entry.entry_id)

    # Mark entry as loaded
    await hass.config_entries.async_forward_entry_setups(entry, [])

    return True


async def async_unload_entry(hass: HomeAssistant, entry: ConfigEntry) -> bool:
    """Unload a config entry."""
    _LOGGER.info("Unloading SmartOS config entry: %s", entry.entry_id)

    # Clean up if needed
    return True
