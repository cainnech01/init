#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Pipeline returns the exit status of the last command that had a non-zero status

# Define a function to execute a command and print status messages
run_command() {
    local command="$1"
    local description="$2"

    echo -e "\033[38;5;45m\n${description}...\033[0m"
    if eval "$command"; then
        echo -e "\033[32mSuccess!\033[0m\n"
    else
        echo -e "\033[31mFailed: $command\033[0m"
        exit 1
    fi
}

# Main script
echo -e "\033[38;5;45mStarting the setup process...\033[0m"

# Update and upgrade the system
run_command "sudo apt update && sudo apt upgrade -y" "Updating and upgrading the system"

# Install Build Tools
run_command "sudo apt -qy install curl git jq lz4 build-essential screen" "Installing Build Tools"

# Install Docker
run_command "sudo apt install -y docker.io" "Installing Docker"

# Install Docker Compose
docker_compose_url="https://github.com/docker/compose/releases/download/v2.29.2/docker-compose-\$(uname -s)-\$(uname -m)"
run_command "sudo curl -L \"${docker_compose_url}\" -o /usr/local/bin/docker-compose" "Installing Docker Compose"

# Install Docker Compose CLI Plugin
run_command "DOCKER_CONFIG=\${DOCKER_CONFIG:-\$HOME/.docker}" "Setting Docker config environment variable"
run_command "mkdir -p \$DOCKER_CONFIG/cli-plugins" "Creating directory for Docker Compose CLI Plugin"
docker_composeCLI_url="https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-x86_64"
run_command "curl -SL \"${docker_composeCLI_url}\" -o \$DOCKER_CONFIG/cli-plugins/docker-compose" "Downloading Docker Compose CLI Plugin"

# Verify Docker Compose installation
run_command "docker compose --version" "Verifying Docker Compose installation"

# Set executable permissions for Docker Compose CLI Plugin
run_command "chmod +x \$DOCKER_CONFIG/cli-plugins/docker-compose" "Setting executable permissions for Docker Compose CLI Plugin"

# Verify Docker and Docker Compose installation
run_command "docker --version && docker compose --version" "Verifying Docker and Docker Compose installation"

# Add user to Docker group
run_command "sudo usermod -aG docker \$USER" "Adding user to Docker group"
