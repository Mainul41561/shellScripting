#!/bin/bash

# Deploy a Django app and handle errors

# Global flag to track if any package was installed
INSTALL_HAPPENED=false

# Function to clone the Django app code
code_clone() {
    echo "Cloning the Django app..."
    if [ -d "django-notes-app" ]; then
        echo "The code directory already exists. Skipping clone."
        return 0
    else
        git clone https://github.com/Mainul41561/django-notes-app.git || {
            echo "Failed to clone the code."
            return 1
        }
    fi
}

# Function to install required dependencies (only if missing)
install_requirements() {
    echo "Checking and installing dependencies..."

    local installed_something=false

    # Docker
    if command -v docker &> /dev/null; then
        echo "Docker is already installed. Version: $(docker --version)"
    else
        echo "Docker not found. Installing..."
        sudo apt-get update && sudo apt-get install -y docker.io || {
            echo "Failed to install Docker."
            return 1
        }
        echo "Docker installed. Version: $(docker --version)"
        installed_something=true
    fi

    # Docker Compose
    if command -v docker-compose &> /dev/null; then
        echo "Docker Compose is already installed. Version: $(docker-compose --version)"
    else
        echo "Docker Compose not found. Installing..."
        sudo apt-get install -y docker-compose || {
            echo "Failed to install Docker Compose."
            return 1
        }
        echo "Docker Compose installed. Version: $(docker-compose --version)"
        installed_something=true
    fi

    if [ "$installed_something" = true ]; then
        INSTALL_HAPPENED=true
    fi

    echo "All dependencies are ready."
    return 0
}


# Function to deploy the Django app
deploy() {
    echo "Building and deploying the Django app..."
    docker build -t notes-app . && docker-compose up -d || {
        echo "Failed to build and deploy the app."
        return 1
    }
}

# Main deployment script
echo "********** DEPLOYMENT STARTED *********"

if ! code_clone; then
    cd django-notes-app || exit 1
fi
# Enter the app directory for subsequent steps
cd django-notes-app || { echo "Failed to enter django-notes-app directory."; exit 1; }

# Install dependencies
if ! install_requirements; then
    exit 1
fi

# Perform required restarts ONLY if something was installed
if [ "$INSTALL_HAPPENED" = true ]; then
    if ! required_restarts; then
        exit 1
    fi
else
    # Still ensure docker.sock permission (lightweight, safe to always do)
    sudo chown "$USER": /var/run/docker.sock || {
        echo "Warning: Could not set docker.sock ownership. You may need to add your user to the 'docker' group."
    }
fi

# Deploy the app
if ! deploy; then
    echo "Deployment failed"
    exit 1
fi

echo "********** DEPLOYMENT DONE *********"
