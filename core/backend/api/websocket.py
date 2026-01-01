"""SmartOS WebSocket handlers for real-time communication."""

from typing import Any, Dict
from homeassistant.core import HomeAssistant
from homeassistant.components.websocket_api import (
    async_register_command,
    websocket_command,
)


@websocket_command({
    "type": "smartos/status"
})
def handle_smartos_status(
    hass: HomeAssistant, connection, msg: Dict[str, Any]
) -> None:
    """Handle SmartOS status request."""
    connection.send_message({
        "id": msg["id"],
        "type": "result",
        "success": True,
        "result": {
            "status": "online",
            "version": "1.0.0",
            "uptime": "active"
        }
    })


@websocket_command({
    "type": "smartos/devices"
})
def handle_smartos_devices(
    hass: HomeAssistant, connection, msg: Dict[str, Any]
) -> None:
    """Handle SmartOS devices request."""
    devices = []
    for entry in hass.config_entries.async_entries():
        devices.append({
            "id": entry.entry_id,
            "domain": entry.domain,
            "title": entry.title,
            "state": entry.state.value,
        })

    connection.send_message({
        "id": msg["id"],
        "type": "result",
        "success": True,
        "result": {"devices": devices}
    })


def setup_websocket_handlers(hass: HomeAssistant) -> None:
    """Set up SmartOS WebSocket command handlers."""
    async_register_command(hass, handle_smartos_status)
    async_register_command(hass, handle_smartos_devices)
