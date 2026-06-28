.PHONY: help gen-locales clean build run test

help:
	@echo "Available commands:"
	@echo "  make gen-locales   - Generate localization keys and locale files"
	@echo "  make clean         - Clean build artifacts"
	@echo "  make build         - Build the project"
	@echo "  make run           - Run the app"
	@echo "  make test          - Run tests"
	@echo "  make pub-get       - Get dependencies"

# Generate localization keys and locale files from translations
gen-locales:
	@echo "Generating localization keys..."
	dart run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart && dart run easy_localization:generate --source-dir ./assets/translations
	@echo "Done! Generated files in lib/generated/"

# Get dependencies
pub-get:
	flutter pub get

# Clean build artifacts
clean:
	flutter clean

# Build the app
build: pub-get
	flutter build apk

# Run the app
run: pub-get
	flutter run

# Run tests
test:
	flutter test

# Combined: get dependencies, generate locales, and run
setup: pub-get gen-locales
	@echo "Setup complete!"
