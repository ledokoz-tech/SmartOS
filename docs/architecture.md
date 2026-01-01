# SmartOS Architecture

## Overview

SmartOS is a modern, user-friendly smart home operating system built on top of Home Assistant. It provides a simplified, branded experience for non-technical users while maintaining the full power and flexibility of Home Assistant.

## Architecture Layers

SmartOS is structured in two main layers:

### 1. Engine Layer (Home Assistant Core)

The foundation layer that handles all the core smart home functionality:

- **Device Integration**: Manages communication with smart devices
- **Automation Engine**: Processes rules and triggers
- **State Management**: Tracks device states and system status
- **API Services**: Provides REST and WebSocket APIs
- **Database**: Stores configuration and historical data

**Location**: `/engine/` directory
**Technology**: Python 3.13+, asyncio, SQLAlchemy

### 2. SmartOS Layer (Product Layer)

The user-facing layer that provides the SmartOS experience:

- **Branding & UI**: Custom themes, logos, and user interface
- **Onboarding**: Simplified setup and configuration
- **User Management**: Role-based access control
- **Custom Integrations**: SmartOS-specific device integrations
- **Deployment Tools**: Docker, installation scripts, updates

**Location**: `/core/` directory
**Technology**: Python, HTML/CSS/JavaScript, Docker

## Component Architecture

### Backend Components

```
core/backend/
├── api/              # REST API and WebSocket handlers
├── services/         # Background services (monitoring, device management)
├── integrations/     # Custom SmartOS integrations
└── __init__.py       # Backend initialization
```

### Frontend Components

```
core/frontend/
├── themes/           # SmartOS UI themes
├── dashboards/       # Custom dashboard layouts
└── onboarding/       # Setup and configuration flows
```

### Configuration

```
core/config/
└── configuration.yaml  # Main SmartOS configuration
```

## Data Flow

### Device Communication

```
Device → Integration → Home Assistant Core → SmartOS API → Frontend
    ↑           ↑              ↑              ↑          ↑
   Raw        Normalized     Processed     REST/WS    UI Updates
  Protocol   State Data     Events       Endpoints   Display
```

### User Interaction

```
User → Frontend → SmartOS API → Home Assistant Core → Device
    ↓      ↓          ↓              ↓             ↓
   Action  Request   Processing    Command       Execution
```

## Security Architecture

### Authentication & Authorization

- **Local Authentication**: Username/password with bcrypt hashing
- **Role-Based Access**: Owner, Guest, Service account roles
- **API Tokens**: JWT-based authentication for API access
- **Session Management**: Secure session handling with expiration

### Network Security

- **Local-First**: All communication stays local by default
- **HTTPS**: Optional SSL/TLS encryption for remote access
- **Firewall**: Restricted network access policies
- **VPN**: Optional secure remote access

### Data Protection

- **Encryption**: Sensitive data encrypted at rest
- **Backup Security**: Encrypted backups with access controls
- **Audit Logging**: Comprehensive logging of all operations

## Deployment Architecture

### Docker Deployment

```
┌─────────────────┐    ┌──────────────────┐
│   SmartOS       │    │   Database       │
│   Container     │    │   (PostgreSQL)   │
│                 │    │                  │
│  ┌────────────┐ │    │                  │
│  │ Home       │ │    └──────────────────┘
│  │ Assistant  │ │             │
│  │ Core       │ │             │
│  └────────────┘ │             │
│        │         │             │
│  ┌────────────┐ │    ┌──────────────────┐
│  │ SmartOS   │ │    │   Redis Cache     │
│  │ Layer     │ │    │                  │
│  └────────────┘ │    └──────────────────┘
└─────────────────┘             │
          │                     │
          └─────────────────────┘
               Docker Network
```

### Bare Metal Deployment

```
┌─────────────────────────────────────┐
│           Host System               │
├─────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐   │
│  │  SmartOS    │  │   System    │   │
│  │   Service   │  │   Services  │   │
│  └─────────────┘  └─────────────┘   │
├─────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐   │
│  │ Home        │  │   Python    │   │
│  │ Assistant   │  │   venv      │   │
│  │ Core        │  └─────────────┘   │
│  └─────────────┘                    │
├─────────────────────────────────────┤
│         Configuration & Data        │
└─────────────────────────────────────┘
```

## Integration Architecture

### Custom Integrations

SmartOS provides custom integrations that extend Home Assistant:

- **SmartOS Core Integration**: Base functionality and branding
- **Device Management**: Enhanced device discovery and control
- **User Management**: Role-based access control
- **Backup & Restore**: Automated backup systems
- **Monitoring**: System health and performance tracking

### Third-Party Integrations

SmartOS is compatible with all Home Assistant integrations:

- **Local Integrations**: Zigbee, Z-Wave, Bluetooth
- **Cloud Integrations**: Google, Amazon, Apple
- **Protocol Integrations**: MQTT, HTTP, WebSocket
- **Hardware Integrations**: Raspberry Pi, USB devices

## Scalability Considerations

### Horizontal Scaling

- **Multi-Instance**: Multiple SmartOS instances with load balancing
- **Database Clustering**: PostgreSQL clustering for high availability
- **Cache Distribution**: Redis clustering for performance

### Vertical Scaling

- **Resource Optimization**: Efficient memory and CPU usage
- **Async Processing**: Non-blocking operations throughout
- **Background Tasks**: Offloaded processing for heavy operations

## Monitoring & Observability

### System Monitoring

- **Performance Metrics**: CPU, memory, disk, network usage
- **Integration Health**: Device connectivity and response times
- **User Activity**: Login attempts, API usage, automation triggers

### Logging

- **Structured Logging**: JSON-formatted logs with context
- **Log Levels**: DEBUG, INFO, WARNING, ERROR, CRITICAL
- **Log Rotation**: Automatic log rotation and cleanup
- **Remote Logging**: Optional centralized logging

### Alerting

- **System Alerts**: Resource usage thresholds
- **Integration Alerts**: Device offline notifications
- **Security Alerts**: Failed login attempts, suspicious activity

## Development Architecture

### Code Organization

- **Modular Design**: Clear separation of concerns
- **Dependency Injection**: Loose coupling between components
- **Interface Contracts**: Well-defined APIs between modules
- **Testing Framework**: Comprehensive unit and integration tests

### Build System

- **Docker Images**: Multi-stage builds for optimization
- **CI/CD Pipeline**: Automated testing and deployment
- **Version Management**: Semantic versioning with change logs
- **Documentation**: Auto-generated API documentation

This architecture ensures SmartOS remains maintainable, scalable, and user-friendly while leveraging the power of Home Assistant.
