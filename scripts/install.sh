#!/bin/bash

# SmartOS Installation Script
# This script installs SmartOS on various platforms

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

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        exit 1
    fi
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/debian_version ]; then
            OS="debian"
        elif [ -f /etc/redhat-release ]; then
            OS="redhat"
        elif [ -f /etc/arch-release ]; then
            OS="arch"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        log_error "Unsupported OS: $OSTYPE"
        exit 1
    fi

    log_info "Detected OS: $OS"
}

# Install system dependencies
install_dependencies() {
    log_info "Installing system dependencies..."

    case $OS in
        debian)
            sudo apt-get update
            sudo apt-get install -y \
                python3 python3-pip python3-venv \
                build-essential libffi-dev libssl-dev \
                libjpeg-dev zlib1g-dev libfreetype6-dev \
                liblcms2-dev libopenjp2-7-dev libtiff5-dev \
                tk-dev tcl-dev linux-libc-dev \
                libbluetooth-dev bluetooth bluez \
                git curl wget
            ;;
        redhat)
            sudo yum install -y \
                python3 python3-pip \
                gcc gcc-c++ libffi-devel openssl-devel \
                libjpeg-turbo-devel zlib-devel freetype-devel \
                lcms2-devel openjpeg2-devel libtiff-devel \
                tk-devel tcl-devel glibc-devel \
                bluez-libs-devel git curl wget
            ;;
        arch)
            sudo pacman -S --noconfirm \
                python python-pip \
                base-devel libffi openssl \
                libjpeg-turbo zlib freetype2 lcms2 openjpeg2 libtiff \
                tk tcl glibc bluez-libs git curl wget
            ;;
        macos)
            # Check if Homebrew is installed
            if ! command -v brew &> /dev/null; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi

            brew install python3 git curl wget
            ;;
        *)
            log_error "Unsupported OS for automatic dependency installation"
            exit 1
            ;;
    esac

    log_success "System dependencies installed"
}

# Create virtual environment
create_venv() {
    log_info "Creating Python virtual environment..."

    python3 -m venv ~/.smartos
    source ~/.smartos/bin/activate

    log_success "Virtual environment created"
}

# Install SmartOS
install_smartos() {
    log_info "Installing SmartOS..."

    # Clone or use existing SmartOS
    if [ ! -d "~/SmartOS" ]; then
        git clone https://github.com/ledokoz-tech/smartos.git ~/SmartOS
    fi

    cd ~/SmartOS

    # Install Python dependencies
    pip install --upgrade pip
    pip install -r engine/requirements.txt

    # Create config directory
    mkdir -p ~/.smartos/config

    # Copy default configuration
    if [ ! -f ~/.smartos/config/configuration.yaml ]; then
        cp core/config/configuration.yaml ~/.smartos/config/
    fi

    log_success "SmartOS installed"
}

# Create systemd service (Linux only)
create_service() {
    if [[ "$OS" != "linux" ]]; then
        return
    fi

    log_info "Creating systemd service..."

    cat > /tmp/smartos.service << EOF
[Unit]
Description=SmartOS Home Automation
After=network.target

[Service]
Type=simple
User=$USER
ExecStart=$HOME/.smartos/bin/hass --config $HOME/.smartos/config
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    sudo mv /tmp/smartos.service /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable smartos

    log_success "Systemd service created"
}

# Create launch agent (macOS)
create_launch_agent() {
    if [[ "$OS" != "macos" ]]; then
        return
    fi

    log_info "Creating launch agent..."

    mkdir -p ~/Library/LaunchAgents

    cat > ~/Library/LaunchAgents/com.smartos.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.smartos</string>
    <key>ProgramArguments</key>
    <array>
        <string>$HOME/.smartos/bin/hass</string>
        <string>--config</string>
        <string>$HOME/.smartos/config</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$HOME/.smartos/smartos.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/.smartos/smartos_error.log</string>
</dict>
</plist>
EOF

    launchctl load ~/Library/LaunchAgents/com.smartos.plist

    log_success "Launch agent created"
}

# Setup complete
setup_complete() {
    log_success "SmartOS installation completed!"
    echo
    echo "Next steps:"
    echo "1. Edit your configuration: nano ~/.smartos/config/configuration.yaml"
    echo "2. Start SmartOS: smartos-start"
    echo "3. Open http://localhost:8123 in your browser"
    echo
    echo "Useful commands:"
    echo "- smartos-start    : Start SmartOS"
    echo "- smartos-stop     : Stop SmartOS"
    echo "- smartos-restart  : Restart SmartOS"
    echo "- smartos-logs     : View logs"
}

# Create helper scripts
create_helper_scripts() {
    log_info "Creating helper scripts..."

    # smartos-start script
    cat > ~/bin/smartos-start << 'EOF'
#!/bin/bash
source ~/.smartos/bin/activate
cd ~/SmartOS/engine
hass --config ~/.smartos/config
EOF
    chmod +x ~/bin/smartos-start

    # smartos-stop script
    cat > ~/bin/smartos-stop << 'EOF'
#!/bin/bash
case $(uname) in
    Linux)
        sudo systemctl stop smartos
        ;;
    Darwin)
        launchctl unload ~/Library/LaunchAgents/com.smartos.plist
        ;;
esac
EOF
    chmod +x ~/bin/smartos-stop

    # smartos-restart script
    cat > ~/bin/smartos-restart << 'EOF'
#!/bin/bash
case $(uname) in
    Linux)
        sudo systemctl restart smartos
        ;;
    Darwin)
        launchctl unload ~/Library/LaunchAgents/com.smartos.plist
        launchctl load ~/Library/LaunchAgents/com.smartos.plist
        ;;
esac
EOF
    chmod +x ~/bin/smartos-restart

    # smartos-logs script
    cat > ~/bin/smartos-logs << 'EOF'
#!/bin/bash
case $(uname) in
    Linux)
        sudo journalctl -u smartos -f
        ;;
    Darwin)
        tail -f ~/.smartos/smartos.log
        ;;
esac
EOF
    chmod +x ~/bin/smartos-logs

    # Add ~/bin to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc 2>/dev/null || true
    fi

    log_success "Helper scripts created"
}

# Main installation process
main() {
    log_info "Starting SmartOS installation..."

    check_root
    detect_os
    install_dependencies
    create_venv
    install_smartos
    create_helper_scripts

    case $OS in
        linux)
            create_service
            ;;
        macos)
            create_launch_agent
            ;;
    esac

    setup_complete
}

# Run main function
main "$@"
