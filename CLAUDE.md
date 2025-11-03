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

이 프로젝트는 **Conventional Commits** 스펙을 따르되, 한국어로 작성합니다.

**커밋 메시지 형식:**
```
<type>: <제목>

<본문>
```

**커밋 타입:**
- `feat` - 새로운 기능 추가
- `fix` - 버그 수정
- `docs` - 문서 변경
- `style` - 코드 스타일 변경 (포맷팅, 세미콜론 누락 등)
- `refactor` - 코드 리팩토링 (기능 변경 없음)
- `perf` - 성능 개선
- `test` - 테스트 추가 또는 수정
- `chore` - 빌드 프로세스, 의존성, 도구 변경

**카테고리별 예시:**

**기능 추가:**
```bash
feat: 습관 추적 도메인 레이어 추가
feat: Riverpod Provider 구현
feat: 할일-습관 네비게이션 추가
```

**버그 수정:**
```bash
fix: CardTheme 타입 에러 수정
fix: 더 이상 사용되지 않는 color.shade800 API 제거
fix: FloatingActionButton Hero 태그 충돌 해결
```

**UI/스타일:**
```bash
style: TodoItem 위젯 디자인 개선
style: 앱 테마 및 다크모드 지원 개선
```

**문서:**
```bash
docs: Git 커밋 가이드라인 추가
docs: CLAUDE.md 프로젝트 구조 문서화
```

**리팩토링:**
```bash
refactor: Riverpod 3.0 API로 마이그레이션
refactor: 공통 유틸리티 함수 추출
```

**커밋 모범 사례:**

1. **논리적 단위로 커밋 분리**
   - 하나의 커밋 = 하나의 논리적 변경
   - 예시: UI 개선 시 각 위젯마다 별도의 커밋

2. **의미 있는 커밋 메시지 작성**
   - 제목: 50자 이내, 명령형으로 작성
   - 본문: 무엇을, 왜 변경했는지 설명 (어떻게가 아닌)
   - 여러 변경사항은 불릿 포인트(-) 사용

3. **AI 관련 정보 제외**
   - 커밋에 AI 출처 정보를 포함하지 않음
   - 자동 생성된 메시지 제거

4. **좋은 예시 vs 나쁜 예시:**
```bash
# 좋은 예시
git commit -m "feat: 습관 추적 도메인 레이어 구현

- Freezed를 사용한 HabitEntity와 HabitLogEntity 추가
- HabitRepository 인터페이스 정의
- CRUD 작업을 위한 Use Case 생성"

git commit -m "fix: Drift Companion 데이터베이스 삽입 오류 해결

- toInsertCompanion에서 createdAt 제거 (DB 기본값 사용)
- 빈 description을 Value.absent()로 처리
- 스택 트레이스와 함께 에러 로깅 추가"

# 나쁜 예시
git commit -m "업데이트"
git commit -m "버그 수정"
git commit -m "변경사항"
```

**커밋 작업 흐름:**
```bash
# 1. 변경사항 확인
git status
git diff

# 2. 논리적 단위로 파일 스테이징
git add <file_path>

# 3. Conventional Commits 형식으로 커밋
git commit -m "type: 제목

- 상세 변경사항 1
- 상세 변경사항 2
- 상세 변경사항 3"

# 4. 커밋 확인
git log --oneline -10
```

**여러 줄 커밋 메시지:**
```bash
# heredoc을 사용한 올바른 형식
git commit -m "$(cat <<'EOF'
feat: 습관 추적 데이터 레이어 추가

습관 추적 기능을 위한 데이터 영속성 구현

- Drift 데이터베이스 테이블 추가 (Habits, HabitLogs)
- 데이터베이스 마이그레이션 전략 구현 (v1 -> v2)
- Entity-Model 매퍼 생성
- Drift 작업을 포함한 Repository 구현
EOF
)"
```

## Flutter 코딩 가이드라인

### Deprecated API 마이그레이션

#### Color.withOpacity() → Color.withValues()

Flutter에서 `Color.withOpacity()`는 deprecated API입니다. 대신 `Color.withValues()`를 사용해야 합니다.

**❌ 사용하지 말 것 (Deprecated):**
```dart
final color = Colors.blue.withOpacity(0.5);
final backgroundColor = theme.colorScheme.surface.withOpacity(0.3);
```

**✅ 사용할 것 (최신 API):**
```dart
final color = Colors.blue.withValues(alpha: 0.5);
final backgroundColor = theme.colorScheme.surface.withValues(alpha: 0.3);
```

**마이그레이션 방법:**
```bash
# 프로젝트 전체에서 withOpacity를 withValues로 변경
# 파일 단위로 replace_all 사용하거나 IDE의 Find & Replace 기능 사용
# .withOpacity( → .withValues(alpha:
```

**주의사항:**
- `withValues`는 여러 색상 채널을 동시에 변경할 수 있습니다 (alpha, red, green, blue)
- alpha 값은 0.0 (완전 투명) ~ 1.0 (완전 불투명) 범위
- 기존 `withOpacity(value)` 호출을 `withValues(alpha: value)`로 변경

### 하드코딩된 값 상수화

코드 가독성과 유지보수성을 위해 반복되는 하드코딩된 값은 상수로 정의하여 사용합니다.

#### 상수 파일 위치

```
lib/core/constants/app_constants.dart
```

#### 정의된 상수 카테고리

**1. Alpha (투명도) 값**
```dart
AppConstants.alphaVeryLight    // 0.08
AppConstants.alphaLight        // 0.1
AppConstants.alphaMediumLight  // 0.15
AppConstants.alphaMedium       // 0.2
AppConstants.alphaMediumHigh   // 0.25
AppConstants.alphaHigh         // 0.3
AppConstants.alphaStrong       // 0.5
AppConstants.alphaVeryStrong   // 0.6
AppConstants.alphaIntense      // 0.7
AppConstants.alphaVeryIntense  // 0.75
```

**2. Border Radius 값**
```dart
AppConstants.radiusXSmall   // 2.0
AppConstants.radiusSmall    // 4.0
AppConstants.radiusMedium   // 8.0
AppConstants.radiusLarge    // 12.0
AppConstants.radiusXLarge   // 16.0
AppConstants.radiusXXLarge  // 20.0
AppConstants.radiusHuge     // 24.0
```

**3. Spacing (Padding/Margin) 값**
```dart
AppConstants.spacingXXSmall  // 1.0
AppConstants.spacingXSmall   // 4.0
AppConstants.spacingSmall    // 8.0
AppConstants.spacingMedium   // 12.0
AppConstants.spacingLarge    // 16.0
AppConstants.spacingXLarge   // 20.0
AppConstants.spacingXXLarge  // 24.0
AppConstants.spacingHuge     // 32.0
// ... 더 많은 spacing 값들
```

**4. 기타 상수**
```dart
// Elevation
AppConstants.elevationNone    // 0.0
AppConstants.elevationSmall   // 2.0
AppConstants.elevationMedium  // 4.0

// Icon Size
AppConstants.iconSizeSmall    // 16.0
AppConstants.iconSizeMedium   // 20.0
AppConstants.iconSizeLarge    // 24.0

// Font Size
AppConstants.fontSizeXSmall   // 10.0
AppConstants.fontSizeSmall    // 12.0
AppConstants.fontSizeMedium   // 14.0

// Border Width
AppConstants.borderWidthThin     // 0.5
AppConstants.borderWidthNormal   // 1.0
AppConstants.borderWidthThick    // 2.0
```

#### 사용 예시

**❌ 하드코딩 (피해야 할 방식):**
```dart
Container(
  padding: const EdgeInsets.all(16.0),
  decoration: BoxDecoration(
    color: Colors.blue.withValues(alpha: 0.3),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 14),
  ),
)
```

**✅ 상수 사용 (권장):**
```dart
import '../../core/constants/app_constants.dart';

Container(
  padding: const EdgeInsets.all(AppConstants.spacingLarge),
  decoration: BoxDecoration(
    color: Colors.blue.withValues(alpha: AppConstants.alphaHigh),
    borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
  ),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: AppConstants.fontSizeMedium),
  ),
)
```

#### 상수화 가이드라인

1. **새로운 UI 컴포넌트 작성 시**
   - 처음부터 상수를 사용하여 작성
   - 하드코딩된 값 대신 적절한 상수 선택

2. **기존 코드 리팩토링 시**
   - 반복되는 값을 발견하면 상수로 교체
   - 파일 단위로 점진적으로 상수화 진행

3. **새로운 상수 추가 시**
   - `app_constants.dart`에 의미 있는 이름으로 추가
   - 기존 명명 규칙 따르기 (size + 크기 수준)

4. **상수 선택 기준**
   - 의미적으로 가장 가까운 상수 선택
   - 예: 0.3 투명도 → `alphaHigh`, 16px padding → `spacingLarge`

**참고 예시 파일:**
- `lib/presentation/widgets/habit_heatmap.dart` - 완전히 상수화된 예시
- `lib/main.dart` - 테마 설정에서 상수 사용 예시

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