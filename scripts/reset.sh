#!/bin/bash

# SmartOS Reset Script
# Resets SmartOS to a clean state (WARNING: This will delete all data!)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Show warning and get confirmation
show_warning() {
    echo -e "${RED}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                    ⚠️  WARNING ⚠️                           ║${NC}"
    echo -e "${RED}║                                                              ║${NC}"
    echo -e "${RED}║  This will COMPLETELY RESET SmartOS and delete ALL data!    ║${NC}"
    echo -e "${RED}║                                                              ║${NC}"
    echo -e "${RED}║  This includes:                                              ║${NC}"
    echo -e "${RED}║  - All configurations                                        ║${NC}"
    echo -e "${RED}║  - All automations                                           ║${NC}"
    echo -e "${RED}║  - All device integrations                                   ║${NC}"
    echo -e "${RED}║  - All user data                                             ║${NC}"
    echo -e "${RED}║  - All backups                                               ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
    read -p "Are you sure you want to continue? Type 'YES' to confirm: " confirm

    if [ "$confirm" != "YES" ]; then
        log_info "Reset cancelled by user"
        exit 0
    fi
}

# Stop SmartOS service
stop_services() {
    log_info "Stopping SmartOS services..."

    case $(uname) in
        Linux)
            if sudo systemctl is-active --quiet smartos; then
                sudo systemctl stop smartos
                sudo systemctl disable smartos
            fi
            ;;
        Darwin)
            if launchctl list | grep -q com.smartos; then
                launchctl unload ~/Library/LaunchAgents/com.smartos.plist
            fi
            ;;
    esac

    log_success "Services stopped"
}

# Remove SmartOS data and configuration
remove_smartos_data() {
    log_info "Removing SmartOS data and configuration..."

    # Remove SmartOS home directory
    if [ -d "$HOME/.smartos" ]; then
        rm -rf "$HOME/.smartos"
        log_info "Removed ~/.smartos directory"
    fi

    # Remove helper scripts
    if [ -d "$HOME/bin" ]; then
        rm -f "$HOME/bin/smartos-"*
        log_info "Removed SmartOS helper scripts"
    fi

    # Remove systemd service
    if [[ $(uname) == "Linux" ]] && [ -f "/etc/systemd/system/smartos.service" ]; then
        sudo rm -f /etc/systemd/system/smartos.service
        sudo systemctl daemon-reload
        log_info "Removed systemd service"
    fi

    # Remove launch agent
    if [[ $(uname) == "Darwin" ]] && [ -f "$HOME/Library/LaunchAgents/com.smartos.plist" ]; then
        rm -f ~/Library/LaunchAgents/com.smartos.plist
        log_info "Removed launch agent"
    fi

    log_success "SmartOS data removed"
}

# Clean up Python virtual environment
clean_python_env() {
    log_info "Cleaning up Python virtual environment..."

    if [ -d "$HOME/.smartos" ]; then
        rm -rf "$HOME/.smartos"
        log_info "Removed Python virtual environment"
    fi

    log_success "Python environment cleaned"
}

# Remove Docker containers and volumes (if using Docker)
clean_docker() {
    log_info "Checking for Docker containers..."

    if command -v docker &> /dev/null; then
        # Stop and remove SmartOS containers
        docker stop smartos smartos_db smartos_redis 2>/dev/null || true
        docker rm smartos smartos_db smartos_redis 2>/dev/null || true

        # Remove SmartOS volumes
        docker volume rm smartos_data smartos_ssl smartos_db smartos_redis 2>/dev/null || true

        log_info "Docker containers and volumes removed"
    fi

    log_success "Docker cleanup completed"
}

# Reset source code to clean state
reset_source_code() {
    log_info "Resetting source code..."

    if [ -d "$HOME/SmartOS" ]; then
        cd ~/SmartOS

        # Reset to clean state
        git reset --hard HEAD
        git clean -fd

        # Pull latest clean version
        git pull origin main

        log_info "Source code reset to clean state"
    fi

    log_success "Source code reset completed"
}

# Show completion message
show_completion() {
    log_success "SmartOS has been completely reset!"
    echo
    echo "What was removed:"
    echo "✓ All configurations and user data"
    echo "✓ All automations and scripts"
    echo "✓ All device integrations"
    echo "✓ Python virtual environment"
    echo "✓ System services and launch agents"
    echo "✓ Docker containers and volumes"
    echo
    echo "To reinstall SmartOS:"
    echo "  curl -fsSL https://raw.githubusercontent.com/ledokoz-tech/smartos/main/scripts/install.sh | bash"
    echo
    echo "Or clone and install manually:"
    echo "  git clone https://github.com/ledokoz-tech/smartos.git ~/SmartOS"
    echo "  cd ~/SmartOS && ./scripts/install.sh"
}

# Main reset process
main() {
    show_warning
    stop_services
    remove_smartos_data
    clean_python_env
    clean_docker
    reset_source_code
    show_completion
}

# Show help
show_help() {
    echo "SmartOS Reset Script"
    echo
    echo "DANGER: This will completely reset SmartOS and delete ALL data!"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  --force        Skip confirmation prompt (use with caution!)"
    echo
    echo "Examples:"
    echo "  $0             # Interactive reset with confirmation"
    echo "  $0 --force     # Force reset without confirmation"
}

# Parse command line arguments
FORCE_RESET=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        --force)
            FORCE_RESET=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Override confirmation if force flag is used
if [ "$FORCE_RESET" = true ]; then
    show_warning() { log_warning "Force reset enabled - skipping confirmation"; }
fi

main "$@"
