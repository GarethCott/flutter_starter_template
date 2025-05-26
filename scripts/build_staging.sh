#!/bin/bash

# Flutter Starter Template - Staging Build Script
# This script builds the app for staging environment

set -e  # Exit on any error

echo "🚀 Building Flutter Starter Template - Staging"
echo "==============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found. Please run this script from the project root."
    exit 1
fi

# Check if environment file exists
ENV_FILE="assets/env/.env.staging"
if [ ! -f "$ENV_FILE" ]; then
    print_warning "Environment file $ENV_FILE not found"
    print_warning "Creating default staging environment file..."
    
    mkdir -p assets/env
    cat > "$ENV_FILE" << EOF
# Staging Environment Configuration
APP_NAME=Flutter Starter (Staging)
APP_VERSION=1.0.0+1
APP_SUFFIX=.staging
API_BASE_URL=https://api-staging.example.com
API_TIMEOUT=30000
API_VERSION=v1
ENABLE_LOGGING=true
ENABLE_DEBUG_BANNER=false
ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true
DATABASE_NAME=flutter_starter_staging.db
DATABASE_VERSION=1
THEME_MODE=system
PRIMARY_COLOR=0xFF6750A4
ENABLE_MATERIAL_YOU=true
LOG_LEVEL=info
LOG_TO_CONSOLE=false
LOG_TO_FILE=true
CACHE_DURATION=600
MAX_CACHE_SIZE=100MB
EOF
    print_success "Created default staging environment file"
fi

print_status "Cleaning previous builds..."
flutter clean

print_status "Getting dependencies..."
flutter pub get

print_status "Running code generation..."
if command -v dart &> /dev/null; then
    dart run build_runner build --delete-conflicting-outputs
else
    print_warning "Dart command not found, skipping code generation"
fi

print_status "Building for staging..."

# Build options
BUILD_TYPE=${1:-"release"}  # Default to release for staging
TARGET_PLATFORM=${2:-""}  # Optional platform specification

case $BUILD_TYPE in
    "debug")
        print_status "Building debug version..."
        if [ -n "$TARGET_PLATFORM" ]; then
            flutter build $TARGET_PLATFORM --debug --flavor staging --dart-define-from-file=$ENV_FILE
        else
            flutter run --flavor staging --dart-define-from-file=$ENV_FILE --debug
        fi
        ;;
    "release")
        print_status "Building release version..."
        if [ -n "$TARGET_PLATFORM" ]; then
            flutter build $TARGET_PLATFORM --release --flavor staging --dart-define-from-file=$ENV_FILE
        else
            print_warning "No platform specified, running in release mode..."
            flutter run --flavor staging --dart-define-from-file=$ENV_FILE --release
        fi
        ;;
    *)
        print_error "Invalid build type: $BUILD_TYPE. Use 'debug' or 'release'"
        exit 1
        ;;
esac

print_success "Staging build completed successfully!"
echo ""
echo "📱 To run the app:"
echo "   flutter run --flavor staging --dart-define-from-file=$ENV_FILE"
echo ""
echo "🔧 To build for specific platforms:"
echo "   ./scripts/build_staging.sh release apk    # Android APK"
echo "   ./scripts/build_staging.sh release ios    # iOS"
echo "   ./scripts/build_staging.sh release web    # Web"
echo ""
echo "⚠️  Note: Staging builds default to release mode for performance testing"
echo "" 