#!/bin/bash

# Flutter Starter Template - Production Build Script
# This script builds the app for production environment with additional safety checks

set -e  # Exit on any error

echo "🚀 Building Flutter Starter Template - Production"
echo "================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

print_important() {
    echo -e "${PURPLE}[IMPORTANT]${NC} $1"
}

# Production build confirmation
print_important "You are about to build for PRODUCTION environment!"
print_warning "This will create optimized builds suitable for app stores."
echo ""
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_status "Production build cancelled."
    exit 0
fi

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
ENV_FILE="assets/env/.env.prod"
if [ ! -f "$ENV_FILE" ]; then
    print_warning "Environment file $ENV_FILE not found"
    print_warning "Creating default production environment file..."
    
    mkdir -p assets/env
    cat > "$ENV_FILE" << EOF
# Production Environment Configuration
APP_NAME=Flutter Starter
APP_VERSION=1.0.0+1
APP_SUFFIX=
API_BASE_URL=https://api.example.com
API_TIMEOUT=30000
API_VERSION=v1
ENABLE_LOGGING=false
ENABLE_DEBUG_BANNER=false
ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true
DATABASE_NAME=flutter_starter.db
DATABASE_VERSION=1
THEME_MODE=system
PRIMARY_COLOR=0xFF6750A4
ENABLE_MATERIAL_YOU=true
LOG_LEVEL=error
LOG_TO_CONSOLE=false
LOG_TO_FILE=true
CACHE_DURATION=3600
MAX_CACHE_SIZE=200MB
EOF
    print_success "Created default production environment file"
    print_warning "Please review and update the production configuration before building!"
fi

# Validate production configuration
print_status "Validating production configuration..."

# Check for placeholder values that should be updated
if grep -q "example.com" "$ENV_FILE"; then
    print_error "Production environment contains placeholder API URL (example.com)"
    print_error "Please update $ENV_FILE with actual production values"
    exit 1
fi

if grep -q "ENABLE_LOGGING=true" "$ENV_FILE"; then
    print_warning "Logging is enabled in production. Consider disabling for performance."
fi

if grep -q "ENABLE_DEBUG_BANNER=true" "$ENV_FILE"; then
    print_error "Debug banner is enabled in production. This should be disabled."
    exit 1
fi

print_success "Production configuration validation passed"

print_status "Cleaning previous builds..."
flutter clean

print_status "Getting dependencies..."
flutter pub get

print_status "Running code generation..."
if command -v dart &> /dev/null; then
    dart run build_runner build --delete-conflicting-outputs
else
    print_error "Dart command not found. Code generation is required for production builds."
    exit 1
fi

print_status "Running Flutter analyzer..."
flutter analyze
if [ $? -ne 0 ]; then
    print_error "Flutter analyzer found issues. Please fix them before building for production."
    exit 1
fi

print_status "Building for production..."

# Build options - Production only supports release builds
BUILD_TYPE="release"
TARGET_PLATFORM=${1:-""}  # Platform must be specified for production

if [ -z "$TARGET_PLATFORM" ]; then
    print_error "Platform must be specified for production builds"
    print_error "Usage: ./scripts/build_prod.sh <platform>"
    print_error "Available platforms: apk, appbundle, ios, web, macos, windows, linux"
    exit 1
fi

# Additional validation for specific platforms
case $TARGET_PLATFORM in
    "apk"|"appbundle")
        print_status "Building Android $TARGET_PLATFORM..."
        flutter build $TARGET_PLATFORM --release --flavor prod --dart-define-from-file=$ENV_FILE --obfuscate --split-debug-info=build/debug-info/
        ;;
    "ios")
        print_status "Building iOS app..."
        flutter build ios --release --flavor prod --dart-define-from-file=$ENV_FILE --obfuscate --split-debug-info=build/debug-info/
        ;;
    "web")
        print_status "Building web app..."
        flutter build web --release --dart-define-from-file=$ENV_FILE --web-renderer canvaskit
        ;;
    "macos")
        print_status "Building macOS app..."
        flutter build macos --release --dart-define-from-file=$ENV_FILE
        ;;
    "windows")
        print_status "Building Windows app..."
        flutter build windows --release --dart-define-from-file=$ENV_FILE
        ;;
    "linux")
        print_status "Building Linux app..."
        flutter build linux --release --dart-define-from-file=$ENV_FILE
        ;;
    *)
        print_error "Unsupported platform: $TARGET_PLATFORM"
        print_error "Supported platforms: apk, appbundle, ios, web, macos, windows, linux"
        exit 1
        ;;
esac

print_success "Production build completed successfully!"
echo ""
print_important "Production Build Summary:"
echo "========================="
echo "Platform: $TARGET_PLATFORM"
echo "Environment: Production"
echo "Build Type: Release"
echo "Obfuscation: Enabled (for mobile platforms)"
echo ""
print_warning "Next Steps:"
echo "1. Test the build thoroughly before distribution"
echo "2. Update version numbers in pubspec.yaml for releases"
echo "3. Create release notes and changelog"
echo "4. Upload to appropriate app store/distribution platform"
echo "" 