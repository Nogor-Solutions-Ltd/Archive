#!/bin/bash
# Author: Sarfaraz
# For running in linux, please use "chmod u+x setup.sh" first.

# Ensure you have Composer installed
if ! command -v composer &> /dev/null; then
    echo "Composer is not installed. Please install Composer and try again."
    exit 1
fi

echo "Setup will take 5/10 Minutes, So please be patient. Thank You!"

# Storage
SOURCE_DIR="docs/storage"

# Determine the path to the Laravel project's root directory (the location of setup.sh)
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Check if the source folder exists
if [ -d "$SOURCE_DIR/$FOLDER_TO_COPY" ]; then
    # Use the -r option to copy the folder recursively
    cp -r "$SOURCE_DIR/$FOLDER_TO_COPY" "$PROJECT_ROOT/"
    echo "Copied $FOLDER_TO_COPY folder to $PROJECT_ROOT"
else
    echo "Folder $FOLDER_TO_COPY does not exist in $SOURCE_DIR"
fi

echo "Folder copying completed."

# Install Laravel dependencies
composer install
echo "Composer install is completed."

# Generate a key for the application
php artisan key:generate

# Run database migrations
php artisan migrate:fresh --seed
echo "Database seed is completed."

# Ensure you have Node installed
if ! node -v composer &> /dev/null; then
    echo "Node is not installed. Please install Node and try again."
    exit 1
fi

# # Install Node.js dependencies and build assets
npm install
echo "npm install is completed."
npm run prod
echo "Production build is completed."


# CKEditor
SOURCE_FILE="docs/assets/ckeditor.zip"
DEST_DIR="public"

# Determine the path to the Laravel project's root directory (the location of setup.sh)
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Check if the ckeditor.zip file already exists in the destination directory
if [ -f "$PROJECT_ROOT/$DEST_DIR/ckeditor.zip" ]; then
    echo "ckeditor.zip already exists in $PROJECT_ROOT/$DEST_DIR/ - Skipping copy and unzip."
else
    # Check if the source file exists
    if [ -f "$SOURCE_FILE" ]; then
        # Copy the file to the public directory
        cp "$SOURCE_FILE" "$PROJECT_ROOT/$DEST_DIR/"
        echo "Copied $SOURCE_FILE to $PROJECT_ROOT/$DEST_DIR/"

        # Unzip the ckeditor.zip file in the public directory
        unzip -q "$PROJECT_ROOT/$DEST_DIR/ckeditor.zip" -d "$PROJECT_ROOT/$DEST_DIR/"
        echo "Unzipped ckeditor.zip in $PROJECT_ROOT/$DEST_DIR/"
    else
        echo "File $SOURCE_FILE does not exist"
    fi
fi

# System Update
php artisan system:update

echo "System update is completed."

# Cache Clear
php artisan optimize:clear

# Output information
echo "Congratulations! Setup Complete ðŸŽ‰"
