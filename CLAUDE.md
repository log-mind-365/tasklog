# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter cross-platform application project named "tasklog". The project supports multiple platforms: Android, iOS, Web, Windows, Linux, and macOS.

## Development Commands

### Running the Application
```bash
# Run on connected device or emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# Run on web
flutter run -d chrome

# Run on macOS (if on macOS)
flutter run -d macos

# List available devices
flutter devices
```

### Hot Reload and Hot Restart
- Hot reload: Press `r` in terminal while app is running (or save file in IDE)
- Hot restart: Press `R` in terminal while app is running

### Building
```bash
# Build for Android
flutter build apk           # Build release APK
flutter build appbundle     # Build app bundle for Play Store

# Build for iOS (requires macOS)
flutter build ios

# Build for web
flutter build web

# Build for macOS (requires macOS)
flutter build macos

# Build for Windows (requires Windows)
flutter build windows

# Build for Linux (requires Linux)
flutter build linux
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

### Linting and Analysis
```bash
# Analyze code for issues
flutter analyze

# Format all Dart files
dart format .

# Format specific file
dart format lib/main.dart
```

### Dependencies
```bash
# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated

# Add a new package
flutter pub add <package_name>

# Remove a package
flutter pub remove <package_name>
```

### Cleaning
```bash
# Clean build files
flutter clean

# Clean and reinstall dependencies
flutter clean && flutter pub get
```

### Code Generation
```bash
# Generate code for Freezed, Drift, and Riverpod
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on file changes)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean generated files and regenerate
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

**When to run code generation:**
- After creating/modifying Freezed classes (entities, failures)
- After changing Drift database schema or tables
- After adding/modifying Riverpod providers with `@riverpod` annotation
- After pulling changes that include any of the above

### Git and Commit Guidelines

This project follows **Conventional Commits** specification for consistent and meaningful commit messages.

**Commit Message Format:**
```
<type>: <subject>

<body>
```

**Commit Types:**
- `feat` - New feature or functionality
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style changes (formatting, missing semicolons, etc.)
- `refactor` - Code refactoring (neither fixes a bug nor adds a feature)
- `perf` - Performance improvements
- `test` - Adding or updating tests
- `chore` - Build process, dependencies, tooling changes

**Examples by Category:**

**Features:**
```bash
feat: add habit tracking domain layer
feat: implement Riverpod providers
feat: add navigation between todos and habits
```

**Bug Fixes:**
```bash
fix: resolve CardTheme type error
fix: remove deprecated color.shade800 API
fix: resolve FloatingActionButton Hero tag conflict
```

**UI/Style:**
```bash
style: modernize TodoItem widget design
style: improve app theme with dark mode support
```

**Documentation:**
```bash
docs: add Git commit guidelines to CLAUDE.md
docs: update CLAUDE.md with project structure
```

**Refactoring:**
```bash
refactor: migrate to Riverpod 3.0 API
refactor: extract common utility functions
```

**Commit Best Practices:**

1. **Separate commits by logical units**
   - One commit = one logical change
   - Example: Separate commits for each widget when improving UI

2. **Write meaningful commit messages**
   - Subject line: 50 characters or less, imperative mood
   - Body: Explain what and why, not how
   - Use bullet points (-) for multiple changes

3. **NO AI-related information**
   - Do not include AI attribution in commits
   - Remove auto-generated messages

4. **Good vs Bad Examples:**
```bash
# Good Examples
git commit -m "feat: implement habit tracking domain layer

- Add HabitEntity and HabitLogEntity with Freezed
- Define HabitRepository interface
- Create use cases for CRUD operations"

git commit -m "fix: resolve Drift Companion database insertion error

- Remove createdAt from toInsertCompanion (use DB default)
- Handle empty description with Value.absent()
- Add error logging with stack traces"

# Bad Examples
git commit -m "update"
git commit -m "fix bug"
git commit -m "changes"
```

**Committing Workflow:**
```bash
# 1. Review changes
git status
git diff

# 2. Stage files by logical units
git add <file_path>

# 3. Commit with conventional format
git commit -m "type: subject

- detailed change 1
- detailed change 2
- detailed change 3"

# 4. Verify commits
git log --oneline -10
```

**Multi-line Commit Messages:**
```bash
# Use heredoc for proper formatting
git commit -m "$(cat <<'EOF'
feat: add habit tracking data layer

Implements data persistence for habit tracking feature

- Add Drift database tables (Habits, HabitLogs)
- Implement database migration strategy (v1 -> v2)
- Create entity-model mappers
- Implement repository with Drift operations
EOF
)"
```

## Code Architecture

This project follows **Clean Architecture** principles with **MVVM** pattern, separating concerns into three distinct layers:

### Layer Structure

```
lib/
├── core/                    # Shared utilities and error handling
│   ├── error/              # Failure classes (freezed)
│   └── utils/              # Date formatting, helpers
├── data/                    # Data layer (implements domain contracts)
│   ├── datasources/local/  # Drift database definitions
│   ├── models/             # Mappers (Drift ↔ Domain entities)
│   └── repositories/       # Repository implementations
├── domain/                  # Business logic layer (pure Dart)
│   ├── entities/           # Business entities (freezed immutable)
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business use cases
└── presentation/            # UI layer
    ├── providers/          # Riverpod providers (code-gen)
    ├── pages/              # Screen widgets
    └── widgets/            # Reusable UI components
```

### Key Architectural Patterns

**1. Clean Architecture Layers**
- **Domain Layer**: Pure business logic, no external dependencies. Contains entities, repository interfaces, and use cases.
- **Data Layer**: Implements domain repositories using Drift (SQLite). Handles data persistence and mapping between database models and domain entities.
- **Presentation Layer**: UI components and state management using Riverpod. Consumes use cases via providers.

**2. Dependency Rule**
- Dependencies point inward: Presentation → Domain ← Data
- Domain layer has no dependencies on outer layers
- Data and Presentation depend on Domain abstractions

**3. State Management**
- **Riverpod** with code generation (`@riverpod` annotation)
- Stream-based reactive updates from Drift database
- Providers defined in `presentation/providers/`

**4. Immutable Data**
- All entities and failures use **Freezed** for immutability
- Code generation creates `.freezed.dart` files
- Ensures type-safe, immutable data structures

**5. Database**
- **Drift** (SQLite wrapper) with type-safe queries
- Tables: `todos` and `categories`
- Auto-generates DAO methods and type-safe query builders
- Schema defined in `data/datasources/local/database.dart`

### Code Generation

After modifying Freezed, Riverpod, or Drift code, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- `.freezed.dart` files for immutable classes
- `.g.dart` files for Riverpod providers and Drift database
- Mappers between data models and domain entities

### Data Flow Example

1. **User Action** → UI widget calls provider method
2. **Provider** → Invokes use case
3. **Use Case** → Calls repository interface (domain)
4. **Repository Impl** → Executes Drift database query (data)
5. **Mapper** → Converts Drift model to domain entity
6. **Stream/Future** → Returns data through layers
7. **UI Update** → Riverpod notifies widgets to rebuild

### Adding New Features

When adding a feature (e.g., "tags"):

1. **Domain Layer**:
   - Create `TagEntity` with freezed in `domain/entities/`
   - Define `TagRepository` interface in `domain/repositories/`
   - Create use cases in `domain/usecases/`

2. **Data Layer**:
   - Add `Tags` table to Drift database
   - Create mapper in `data/models/`
   - Implement `TagRepositoryImpl` in `data/repositories/`

3. **Presentation Layer**:
   - Add providers in `presentation/providers/`
   - Create UI widgets/pages
   - Connect to use cases via providers

4. **Code Generation**:
   - Run `flutter pub run build_runner build --delete-conflicting-outputs`

## Configuration Files

- `pubspec.yaml` - Package configuration, dependencies, assets
- `analysis_options.yaml` - Dart analyzer configuration using `package:flutter_lints/flutter.yaml`
- `.metadata` - Flutter tooling metadata
- Platform-specific configurations in respective platform directories

## Development Environment

- Dart SDK: ^3.9.2
- Flutter SDK: Latest stable
- Uses `flutter_lints: ^5.0.0` for recommended linting rules
- Material Design 3 with Cupertino icons support

### Key Dependencies

**State Management:**
- `flutter_riverpod: ^2.4.0` - Reactive state management
- `riverpod_annotation: ^2.3.0` - Code generation for providers

**Database:**
- `drift: ^2.14.0` - Type-safe SQLite wrapper
- `drift_flutter: ^0.1.0` - Flutter integration
- `sqlite3_flutter_libs: ^0.5.0` - Native SQLite libraries

**Code Generation:**
- `freezed_annotation: ^2.4.1` - Immutable classes
- `json_annotation: ^4.8.1` - JSON serialization
- `build_runner: ^2.4.0` - Code generation runner
- `drift_dev: ^2.14.0` - Drift code generator
- `riverpod_generator: ^2.3.0` - Riverpod code generator
- `freezed: ^2.4.5` - Freezed code generator

**Utilities:**
- `intl: ^0.19.0` - Internationalization and date formatting

## Platform-Specific Notes

### Android
- Configuration in `android/app/build.gradle.kts`
- App icon resources in `android/app/src/main/res/mipmap-*/`
- Launch background in `android/app/src/main/res/drawable/`

### iOS
- Xcode project at `ios/Runner.xcodeproj/`
- App icon in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Configuration in `ios/Runner/Info.plist`

### macOS
- Xcode project at `macos/Runner.xcodeproj/`
- App icon in `macos/Runner/Assets.xcassets/AppIcon.appiconset/`
- Entitlements in `macos/Runner/*.entitlements`

### Web
- Entry point: `web/index.html`
- Manifest: `web/manifest.json`
- Icons in `web/icons/`

### Windows
- CMake configuration in `windows/CMakeLists.txt`
- Native runner code in `windows/runner/`

### Linux
- CMake configuration in `linux/CMakeLists.txt`
- Native runner code in `linux/runner/`