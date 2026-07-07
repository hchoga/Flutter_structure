# Flutter Structure

A Flutter application built with Clean Architecture and SOLID principles.

## Project Structure

This project follows **Clean Architecture** with the following layers:

- **Presentation Layer** (`lib/features/*/presentation/`) - UI and state management (Cubits)
- **Domain Layer** (`lib/features/*/domain/`) - Business logic (Use Cases, Entities, Repositories)
- **Data Layer** (`lib/features/*/data/`) - Data access (Models, Data Sources)
- **Core Layer** (`lib/core/`) - Shared utilities (Errors, Constants, Network)

For detailed architecture information, see [ARCHITECTURE.md](ARCHITECTURE.md).

## Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### Setup

1. Clone the repository
2. Run setup command:
   ```bash
   make setup
   # Or manually:
   flutter pub get
   make gen-locales
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Available Commands

Use the Makefile for common tasks:

```bash
make help              # Show all available commands
make gen-locales      # Generate localization keys from translations
make pub-get          # Get project dependencies
make clean            # Clean build artifacts
make build            # Build the app
make run              # Run the app
make test             # Run tests
make setup            # Setup project (dependencies + locales)
```

### Localization

After adding new translations to `assets/translations/en.json` and `assets/translations/ar.json`:

```bash
make gen-locales
```

This generates `lib/generated/locale_keys.g.dart` with type-safe translation keys.

**Usage in code:**
```dart
import 'package:touch/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

Text(LocaleKeys.home_title.tr())
```

See [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) for more details.

## Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - Architecture overview and SOLID principles
- [ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md) - Visual flow diagrams
- [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) - Implementation guides and examples
- [SETUP_SUMMARY.md](SETUP_SUMMARY.md) - Initial setup summary

## Testing

Run all tests:
```bash
make test
```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter BLoC Documentation](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)

