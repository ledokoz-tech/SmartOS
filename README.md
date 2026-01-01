# SmartOS

SmartOS is a **modern, user-friendly smart home operating system** built on top of **Home Assistant**, designed for **non-technical users, businesses, and managed deployments**.

SmartOS focuses on **simplicity, security, and scalability**, while keeping full local control.

> SmartOS is powered by Home Assistant (Apache 2.0 licensed).

---

## ✨ Features

* Clean, branded UI and dashboards
* Simple onboarding for new users
* Pre-configured automations
* Role-based access (owner / guest / service)
* Local-first architecture (privacy focused)
* Docker-based deployment
* Extensible via custom integrations
* Designed for hosting, hardware bundles, and enterprise use

---

## 🎯 Who is SmartOS for?

* Home users who want **plug-and-play smart homes**
* Airbnb / rental property owners
* Small offices and shops
* System integrators & installers
* Managed smart home providers

---

## 🧱 Architecture Overview

SmartOS is structured in **two layers**:

1. **Engine layer**

   * Home Assistant core
   * Handles devices, automations, and integrations

2. **SmartOS layer (this project)**

   * Branding & UI
   * Custom integrations
   * Onboarding & configuration
   * Deployment, updates, and services

SmartOS does **not** fork or rewrite Home Assistant.
It **extends and orchestrates** it.

---

## 📁 Project Structure

```s
SmartOS/
├── engine/     # Home Assistant core (engine)
│
├── core/                   # SmartOS product layer
│   ├── backend/
│   │   ├── integrations/
│   │   ├── services/
│   │   └── api/
│   │
│   ├── frontend/
│   │   ├── themes/
│   │   ├── dashboards/
│   │   └── onboarding/
│   │
│   ├── config/
│   │   └── configuration.yaml
│   │
│   └── branding/
│
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
│
├── scripts/
│   ├── install.sh
│   ├── update.sh
│   └── reset.sh
│
├── docs/
│   ├── architecture.md
│   ├── security.md
│   └── roadmap.md
│
├── legal/
│   ├── LICENSE
│   ├── NOTICE
│   └── THIRD_PARTY.md
│
├── README.md
└── .gitignore
```

---

## 🚀 Getting Started

### 1. Clone SmartOS

```bash
git clone https://github.com/ledokoz-tech/smartos.git
cd smartos
```

### 2. Clone Home Assistant Engine

```bash
# the home Assistant Engine is already clone in /Engine
# you don't need to clone it
```

---

### 3. Start SmartOS (Docker)

```bash
docker compose up -d
```

Once running:

* SmartOS controls configuration and branding
* Home Assistant runs as the core engine

---

## 🧩 Custom Integrations

SmartOS supports custom integrations built on top of Home Assistant.

Location:

```s
smartos/backend/integrations/
```

These are linked into Home Assistant at runtime as `custom_components`.

---

## 🎨 Branding & UI

You can customize:

* Themes
* Dashboards
* Product name
* Onboarding flow

Branding assets live in:

```s
smartos/branding/
```

---

## 🔐 Security & Privacy

* Local-first by default
* No cloud dependency required
* Optional remote access
* Designed for secure deployments

See:

```s
docs/security.md
```

---

## 📦 Deployment Options

SmartOS supports:

* Local installations
* Managed hosting (SaaS)
* Hardware bundles (Mini-PC, NUC, Raspberry Pi)
* Enterprise deployments

---

## 💼 Commercial Use

SmartOS is designed to be:

* Open-source friendly
* Commercially usable
* Rebrandable

You may:

* Sell services
* Offer hosting
* Bundle hardware
* Build paid extensions

---

## ⚖️ Licensing & Attribution

SmartOS is distributed under MIT license.

Home Assistant:

* Licensed under **Apache License 2.0**
* Copyright © Home Assistant

SmartOS:

* Includes proper attribution
* Does not use Home Assistant trademarks
* Respects all upstream licenses
* Licensed under **MIT License**

See:

```s
legal/NOTICE
legal/THIRD_PARTY.md
```

---

## 🛣️ Roadmap

Planned features:

* Visual automation builder
* Advanced role management
* Backup & restore UI
* Installer wizard
* Update manager

See:

```s
docs/roadmap.md
```

---

## 🤝 Contributing

Contributions are welcome.

Please:

* Follow clean commit messages
* Do not modify Home Assistant core unless necessary
* Respect licensing rules

(Contributing guide coming soon)

---

## 🧠 Philosophy

SmartOS believes:

* Smart homes should be simple
* Users should own their data
* Open-source can be profitable and ethical
* UX matters as much as features

---

## 📌 Disclaimer

SmartOS is **not affiliated with or endorsed by Home Assistant**.

“Home Assistant” is a trademark of its respective owners.
