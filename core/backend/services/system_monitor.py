"""SmartOS System Monitor Service."""

import asyncio
import logging
import psutil
from datetime import datetime
from typing import Dict, Any
from homeassistant.core import HomeAssistant

_LOGGER = logging.getLogger(__name__)

class SystemMonitorService:
    """Monitor system resources and SmartOS health."""

    def __init__(self, hass: HomeAssistant):
        """Initialize the system monitor."""
        self.hass = hass
        self._monitoring = False
        self._last_stats: Dict[str, Any] = {}

    async def start_monitoring(self) -> None:
        """Start system monitoring."""
        if self._monitoring:
            return

        self._monitoring = True
        _LOGGER.info("Starting SmartOS system monitoring")

        # Start monitoring task
        self.hass.async_create_task(self._monitor_loop())

    async def stop_monitoring(self) -> None:
        """Stop system monitoring."""
        self._monitoring = False
        _LOGGER.info("Stopped SmartOS system monitoring")

    async def _monitor_loop(self) -> None:
        """Main monitoring loop."""
        while self._monitoring:
            try:
                # Collect system stats
                stats = await self._collect_system_stats()

                # Store stats
                self._last_stats = stats

                # Fire event with system stats
                self.hass.bus.async_fire("smartos_system_stats", stats)

                # Wait before next collection
                await asyncio.sleep(30)  # 30 seconds

            except Exception as err:
                _LOGGER.error("Error in system monitoring loop: %s", err)
                await asyncio.sleep(60)  # Wait longer on error

    async def _collect_system_stats(self) -> Dict[str, Any]:
        """Collect current system statistics."""
        # CPU usage
        cpu_percent = psutil.cpu_percent(interval=1)

        # Memory usage
        memory = psutil.virtual_memory()
        memory_percent = memory.percent
        memory_used = memory.used / (1024**3)  # GB
        memory_total = memory.total / (1024**3)  # GB

        # Disk usage
        disk = psutil.disk_usage('/')
        disk_percent = disk.percent
        disk_used = disk.used / (1024**3)  # GB
        disk_total = disk.total / (1024**3)  # GB

        # Network (basic)
        network = psutil.net_io_counters()
        bytes_sent = network.bytes_sent / (1024**2)  # MB
        bytes_recv = network.bytes_recv / (1024**2)  # MB

        # Home Assistant stats
        ha_stats = {
            "config_entries": len(self.hass.config_entries.async_entries()),
            "states": len(self.hass.states.async_all()),
            "services": len(self.hass.services.async_services()),
        }

        return {
            "timestamp": datetime.utcnow().isoformat(),
            "cpu_percent": cpu_percent,
            "memory": {
                "percent": memory_percent,
                "used_gb": round(memory_used, 2),
                "total_gb": round(memory_total, 2),
            },
            "disk": {
                "percent": disk_percent,
                "used_gb": round(disk_used, 2),
                "total_gb": round(disk_total, 2),
            },
            "network": {
                "bytes_sent_mb": round(bytes_sent, 2),
                "bytes_recv_mb": round(bytes_recv, 2),
            },
            "homeassistant": ha_stats,
        }

    def get_last_stats(self) -> Dict[str, Any]:
        """Get the last collected system statistics."""
        return self._last_stats.copy()
