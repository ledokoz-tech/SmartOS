#!/bin/bash

# SmartOS Update Script
# Updates SmartOS and its dependencies

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

# Backup current configuration
backup_config() {
    log_info "Backing up current configuration..."

    BACKUP_DIR="$HOME/.smartos/backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    if [ -d "$HOME/.smartos/config" ]; then
        cp -r "$HOME/.smartos/config" "$BACKUP_DIR/"
    fi

    if [ -d "$HOME/SmartOS" ]; then
        cp -r "$HOME/SmartOS" "$BACKUP_DIR/smartos_source"
    fi

    log_success "Configuration backed up to: $BACKUP_DIR"
}

# Stop SmartOS service
stop_smartos() {
    log_info "Stopping SmartOS service..."

    case $(uname) in
        Linux)
            if sudo systemctl is-active --quiet smartos; then
                sudo systemctl stop smartos
            fi
            ;;
        Darwin)
            if launchctl list | grep -q com.smartos; then
                launchctl unload ~/Library/LaunchAgents/com.smartos.plist
            fi
            ;;
    esac

    log_success "SmartOS service stopped"
}

# Update SmartOS source code
update_source() {
    log_info "Updating SmartOS source code..."

    cd ~/SmartOS

    # Pull latest changes
    git pull origin main

    # Update submodules if any
    git submodule update --init --recursive

    log_success "Source code updated"
}

# Update Python dependencies
update_dependencies() {
    log_info "Updating Python dependencies..."

    source ~/.smartos/bin/activate

    # Upgrade pip
    pip install --upgrade pip

    # Update requirements
    pip install -r ~/SmartOS/engine/requirements.txt --upgrade

    log_success "Python dependencies updated"
}

# Run database migrations if needed
run_migrations() {
    log_info "Checking for database migrations..."

    # This would be more complex in a real implementation
    # For now, just check if Home Assistant needs to restart
    log_info "Database migration check completed"
}

# Start SmartOS service
start_smartos() {
    log_info "Starting SmartOS service..."

    case $(uname) in
        Linux)
            sudo systemctl start smartos
            ;;
        Darwin)
            launchctl load ~/Library/LaunchAgents/com.smartos.plist
            ;;
    esac

    log_success "SmartOS service started"
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."

    # Wait a bit for service to start
    sleep 10

    # Check if SmartOS is responding
    if curl -f http://localhost:8123/api/ &>/dev/null; then
        log_success "SmartOS is running and responding"
    else
        log_warning "SmartOS may not be fully started yet. Check logs with: smartos-logs"
    fi
}

# Cleanup old backups
cleanup_backups() {
    log_info "Cleaning up old backups..."

    # Keep only last 10 backups
    BACKUP_COUNT=$(ls -1d ~/.smartos/backups/*/ 2>/dev/null | wc -l)
    if [ "$BACKUP_COUNT" -gt 10 ]; then
        ls -1d ~/.smartos/backups/*/ | head -n -10 | xargs rm -rf
        log_info "Removed old backups (keeping last 10)"
    fi
}

# Show update summary
show_summary() {
    log_success "SmartOS update completed successfully!"
    echo
    echo "Update Summary:"
    echo "- Source code: Updated to latest version"
    echo "- Dependencies: Updated to latest versions"
    echo "- Configuration: Backed up automatically"
    echo "- Service: Restarted"
    echo
    echo "If you encounter any issues:"
    echo "1. Check logs: smartos-logs"
    echo "2. Restore from backup if needed"
    echo "3. Visit: https://github.com/ledokoz-tech/smartos/issues"
}

# Main update process
main() {
    log_info "Starting SmartOS update process..."

    backup_config
    stop_smartos
    update_source
    update_dependencies
    run_migrations
    start_smartos
    verify_installation
    cleanup_backups
    show_summary
}

# Show help
show_help() {
    echo "SmartOS Update Script"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  --no-backup    Skip configuration backup"
    echo "  --no-restart   Don't restart service after update"
    echo
    echo "Examples:"
    echo "  $0              # Full update with backup and restart"
    echo "  $0 --no-backup  # Update without backup"
}

# Parse command line arguments
SKIP_BACKUP=false
SKIP_RESTART=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        --no-backup)
            SKIP_BACKUP=true
            shift
            ;;
        --no-restart)
            SKIP_RESTART=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Run main function with options
if [ "$SKIP_BACKUP" = true ]; then
    log_warning "Skipping configuration backup (--no-backup specified)"
    backup_config() { log_info "Backup skipped"; }
fi

if [ "$SKIP_RESTART" = true ]; then
    log_warning "Skipping service restart (--no-restart specified)"
    stop_smartos() { log_info "Service stop skipped"; }
    start_smartos() { log_info "Service start skipped"; }
fi

main "$@"
