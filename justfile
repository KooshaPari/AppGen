# AppGen justfile
# Expo React Native application

set shell := ["bash", "-uc"]

# List available recipes
default:
    @just --list

# Start the Expo dev server (Metro bundler with watch mode)
dev:
    bun run start

# Build the production app for web
build:
    bun run web

# Run the test suite (vitest)
test:
    bun run test

# Run ESLint
lint:
    bun run lint

# Apply Prettier formatter
fmt:
    bun run format

# Remove build artifacts and node_modules cache
clean:
    rm -rf .expo .expo-shared node_modules/.cache dist web-build
    @echo "Cleaned Expo and build artifacts"
