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

# Pull the nillion/verifier:v1.0.1 image
run_command "docker pull nillion/verifier:v1.0.1"

# Create the nillion/verifier directory
run_command "mkdir -p nillion/verifier"

# Run the nillion/verifier:v1.0.1 image
run_command "docker run -v ./nillion/verifier:/var/tmp nillion/verifier:v1.0.1 initialise"