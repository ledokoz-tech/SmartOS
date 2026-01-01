# SmartOS - Custom Home Assistant by Ledokoz

This is the **Ledokoz custom version** of Home Assistant, a modern smart home operating system designed for simplicity, security, and scalability.

Built on top of the Home Assistant core (Apache 2.0 licensed), SmartOS provides a streamlined experience for non-technical users, businesses, and managed deployments while maintaining full local control.

## 🚀 Quick Start

```bash
# The Home Assistant engine is already included in the /engine directory
cd /engine
pip install -r requirements.txt
hass
```

## 📁 Project Structure

```
SmartOS/
├── engine/          # Home Assistant core (essential files only)
│   ├── homeassistant/    # Core Home Assistant package
│   ├── requirements.txt  # Dependencies
│   ├── pyproject.toml    # Build configuration
│   ├── setup.py         # Installation script
│   └── LICENSE.md       # License
├── LICENSE           # Project license
└── README.md         # This file
```

## 🛠️ Development

This custom version maintains the core Home Assistant functionality while optimizing for the SmartOS deployment model.

## ⚖️ Licensing

- **Home Assistant Core**: Apache License 2.0
- **SmartOS Customizations**: MIT License
- **Not affiliated with or endorsed by Home Assistant**

## 📞 Support

For support and documentation, visit the Ledokoz project repository.
