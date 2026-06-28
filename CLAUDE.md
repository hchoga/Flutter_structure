# CLAUDE.md — Project Rules & Architecture Reference

## Project Overview

Flutter app named **purchases**, built with Clean Architecture and SOLID principles.
- **State management**: flutter_bloc (Cubit)
- **Navigation**: GoRouter
- **Localization**: easy_localization (EN + AR)
- **DI**: GetIt service locator
- **Error handling**: dartz Either pattern
- **HTTP**: Dio with token injection + pretty logging

---

## Commands

```bash
flutter pub get          # Install dependencies
flutter run              # Run the app
dart run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart && dart run easy_localization:generate --source-dir ./assets/translations  # Regenerate l10n files after translation changes
make test                # Run tests
make clean               # Clean build artifacts
```

**Localization generation (run after adding new keys):**
```bash
dart run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart && dart run easy_localization:generate --source-dir ./assets/translations
```

---

## Directory Structure

```
lib/
├── core/
│   ├── constants/app_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── network_info.dart
│   │   ├── dio_client.dart
│   │   └── dio_exception_handler.dart
│   ├── routes/
│   │   ├── app_routes.dart
│   │   └── route_names.dart
│   ├── services/
│   │   ├── localization_service.dart
│   │   └── ...
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── app_text_styles.dart
│   └── usecases/usecase.dart
├── features/
│   └── [feature]/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── [feature]_remote_data_source.dart   # REQUIRED
│       │   │   └── [feature]_local_data_source.dart    # OPTIONAL
│       │   ├── models/[feature]_model.dart
│       │   └── repositories/[feature]_repository_impl.dart
│       ├── domain/
│       │   ├── entities/[feature]_entity.dart
│       │   ├── repositories/[feature]_repository.dart
│       │   └── usecases/
│       │       └── get_[feature]_usecase.dart
│       └── presentation/
│           ├── cubit/[feature]_cubit.dart
│           ├── pages/[feature]_page.dart
│           └── widgets/[feature]_widget.dart
├── generated/
│   └── locale_keys.g.dart
├── assets/
│   └── translations/
│       ├── en.json
│       └── ar.json
├── service_locator.dart
└── main.dart
```

---


### Layer Responsibilities

| Layer | Location | Responsibility | May Depend On |
|-------|----------|----------------|---------------|
| Presentation | `presentation/` | UI + Cubit state | Domain only |
| Domain | `domain/` | Business logic, entities, use cases | Nothing (pure Dart) |
| Data | `data/` | API calls, caching, models | Domain interfaces |
| Core | `core/` | Shared utilities | Nothing |

**Never** access the data layer directly from UI. **Never** put business logic in widgets.

### Dependency Flow

```
Presentation → Domain → Data → Core
```

Cubits depend on Use Cases. Use Cases depend on Repository interfaces. Repository implementations depend on DataSources. Everything wires through GetIt.

### Error Flow

```
DioClient → DioException → DioExceptionHandler.fromDioException()
→ DataSource throws Failure
→ Repository wraps in Either<Failure, Success>
→ Cubit handles with .fold()
→ UI renders error state
```

---

## Coding Patterns

### Entity (pure Dart — no dependencies)

```dart
class YourEntity {
  final int id;
  final String name;
  const YourEntity({required this.id, required this.name});
}
```

### Model (extends Entity, adds JSON)

```dart
class YourModel extends YourEntity {
  const YourModel({required super.id, required super.name});

  factory YourModel.fromJson(Map<String, dynamic> json) =>
      YourModel(id: json['id'] as int, name: json['name'] as String);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  YourEntity toEntity() => YourEntity(id: id, name: name);
}
```

### Repository Interface

```dart
abstract class YourRepository {
  Future<Either<Failure, YourEntity>> getYourData();
}
```

### Use Case

```dart
class GetYourDataUseCase extends UseCaseNoParams<YourEntity> {
  final YourRepository repository;
  GetYourDataUseCase({required this.repository});

  @override
  Future<Either<Failure, YourEntity>> call() async =>
      await repository.getYourData();
}
```

### Remote DataSource

```dart
abstract class YourRemoteDataSource {
  Future<YourModel> getYourData();
}

class YourRemoteDataSourceImpl implements YourRemoteDataSource {
  final DioClient dioClient;
  YourRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<YourModel> getYourData() async {
    try {
      // Use constants from ApisUrl - never use hardcoded strings for api paths
      final response = await dioClient.get(path: ApisUrl.yourEndpoint);
      return YourModel.fromJson(response.data);
    } on DioException catch (e) {
      throw DioExceptionHandler.fromDioException(e);
    }
  }
}
```

### Local DataSource (only add when offline support is needed)

```dart
abstract class YourLocalDataSource {
  Future<YourModel> getCachedData();
  Future<void> cacheData(YourModel model);
  Future<void> clearCache();
}

class YourLocalDataSourceImpl implements YourLocalDataSource {
  final SecureStorageService secureStorage;
  YourLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<YourModel> getCachedData() async {
    try {
      final data = await secureStorage.read(key: ConstantsKeys.cachedYourData);
      if (data == null) throw CacheFailure(message: 'No cached data found');
      return YourModel.fromJson(jsonDecode(data));
    } catch (e) {
      if (e is CacheFailure) rethrow;
      throw CacheFailure(message: 'Failed to retrieve cached data: $e');
    }
  }

  @override
  Future<void> cacheData(YourModel model) async {
    try {
      await secureStorage.write(
        key: ConstantsKeys.cachedYourData,
        value: jsonEncode(model.toJson()),
      );
    } catch (e) {
      throw CacheFailure(message: 'Failed to cache data: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await secureStorage.delete(key: ConstantsKeys.cachedYourData);
    } catch (e) {
      throw CacheFailure(message: 'Failed to clear cache: $e');
    }
  }
}
```

### Repository Implementation

```dart
class YourRepositoryImpl implements YourRepository {
  final YourRemoteDataSource remoteDataSource;
  final YourLocalDataSource localDataSource;

  YourRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, YourModel>> getYourData() async {
    try {
      final remoteData = await remoteDataSource.getYourData();
      await localDataSource.cacheData(remoteData);
      return Right(remoteData);
    } on ServerFailure catch (e) {
      return Left(e); // passes ServerFailure directly, type is preserved
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

### Cubit & States (Two Separate Files)

#### `your_state.dart`
```dart
part of 'your_cubit.dart';

abstract class YourState {
  const YourState();
}

class YourInitialState extends YourState {
  const YourInitialState();
}

class YourLoadingState extends YourState {
  const YourLoadingState();
}

class YourLoadedState extends YourState {
  final YourEntity data;
  const YourLoadedState({required this.data});
}

class YourErrorState extends YourState {
  final String message;
  const YourErrorState({required this.message});
}
```

#### `your_cubit.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/errors/failures.dart';
import '../../domain/usecases/get_your_data_usecase.dart';
import '../../domain/entities/your_entity.dart';

part 'your_state.dart';

class YourCubit extends Cubit<YourState> {
  final GetYourDataUseCase getYourDataUseCase;
  YourCubit({required this.getYourDataUseCase}) : super(const YourInitialState());

  Future<void> getYourData() async {
    emit(const YourLoadingState());
    final result = await getYourDataUseCase();
    result.fold(
      (failure) {
        final message = failure is ServerFailure
            ? failure.displayMessage
            : failure.message;
        emit(YourErrorState(message: message));
      },
      (data) => emit(YourLoadedState(data: data)),
    );
  }
}
```

### Page (BlocBuilder)

```dart
class YourPage extends StatefulWidget {
  const YourPage({super.key});
  @override
  State<YourPage> createState() => _YourPageState();
}

class _YourPageState extends State<YourPage> {
  @override
  void initState() {
    super.initState();
    context.read<YourCubit>().getYourData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.yourFeatureTitle.tr())),
      body: BlocBuilder<YourCubit, YourState>(
        builder: (context, state) {
          if (state is YourLoadingState) return const Center(child: CircularProgressIndicator());
          if (state is YourLoadedState) return Center(child: Text(state.data.name));
          if (state is YourErrorState) return Center(child: Text('Error: ${state.message}'));
          return const SizedBox();
        },
      ),
    );
  }
}
```

### Service Locator Registration

```dart
// In service_locator.dart — always register in this order:
// 1. DataSources
getIt.registerLazySingleton<YourRemoteDataSource>(
  () => YourRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
);
// 2. Repository
getIt.registerLazySingleton<YourRepository>(
  () => YourRepositoryImpl(remoteDataSource: getIt<YourRemoteDataSource>()),
);
// 3. Use Case
getIt.registerLazySingleton<GetYourDataUseCase>(
  () => GetYourDataUseCase(repository: getIt<YourRepository>()),
);
// 4. Cubit
getIt.registerLazySingleton<YourCubit>(
  () => YourCubit(getYourDataUseCase: getIt<GetYourDataUseCase>()),
);
```

### Routes

```dart
// In route_names.dart
enum RoutesName {
  home(path: '/home', name: 'Home Page'),
  homeDetail(path: '/home/detail/:id', name: 'Home Detail');

  const RoutesName({required this.path, required this.name});
  final String path;
  final String name;
}

// Navigation
context.go(RoutesName.home.path);
context.goNamed(RoutesName.homeDetail.name, pathParameters: {'id': '123'});
```

---

## Localization

**Every user-visible string MUST go through `LocaleKeys`. Never hardcode display text.**

Workflow for new text:
1. Add the key + English value to `assets/translations/en.json`
2. Add the key + Arabic value to `assets/translations/ar.json`
3. Run the generation command:
   ```bash
   dart run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart && dart run easy_localization:generate --source-dir ./assets/translations
   ```
4. Use `LocaleKeys.yourKey.tr()` in the widget

```dart
import 'package:easy_localization/easy_localization.dart';
import 'package:purchases/generated/locale_keys.g.dart';

// Simple string
Text(LocaleKeys.hello.tr())

// Parameterised string
Text(LocaleKeys.failedToGetLocation.tr(args: [errorMessage]))

// Change language at runtime
context.setLocale(const Locale('ar'));
```

**Rules:**
- No Arabic or English string literals in `.dart` files — only in `.json` translation files
- `en.json` is the source of truth for key names
- Both `.json` files must always have the same set of keys
- `assets/translations/` must be declared in `pubspec.yaml` under `flutter: assets:`
- The `generated/locale_keys.g.dart` file is auto-generated — never edit it by hand
- Always run the generation command after adding new keys

---

## Responsive Sizing — ScreenUtil

This project uses `flutter_screenutil` for **all** responsive sizing. Every widget, layout, and style
must use ScreenUtil extensions. No hardcoded `double` pixels in the UI layer.

**Design baseline:** `393 × 852` (iPhone 14 Pro portrait). ScreenUtilInit is already wired in `main.dart` — never change the designSize.

### Rules

| Use case | Correct | Wrong |
|---|---|---|
| Fixed width | `120.w` | `120` |
| Fixed height | `48.h` | `48` |
| Font size | `16.sp` | `16` |
| Border radius | `12.r` | `12` |
| Icon size | `24.sp` | `24` or `24.r` |
| Horizontal padding/margin | `16.w` | `16` |
| Vertical padding/margin | `12.h` | `12` |

```dart
// ✅ Correct
SizedBox(height: 24.h)
SizedBox(width: 8.w)
Text('Hello', style: TextStyle(fontSize: 16.sp))
BorderRadius.circular(12.r)
Icon(Icons.star, size: 20.sp)
EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)
Container(width: 44.w, height: 44.h)

// ❌ Wrong — will be rejected in review
SizedBox(height: 24)
Text('Hello', style: TextStyle(fontSize: 16))
BorderRadius.circular(12)
```

Raw `int` values are fine for non-pixel concerns: animation durations (`300`ms), flex factors (`Expanded(flex: 2)`), `strokeWidth`, opacity multipliers.

---

## Colors

**Every color value MUST come from `AppColors`. Never use inline `Color(0xFFXXXXXX)` literals.**

```dart
import 'package:purchases/core/constants/app_colors.dart';

// Correct
color: AppColors.darkD1          // #1A1919 — primary text
color: AppColors.darkD3          // #808080 — secondary / hint text
color: AppColors.darkD2          // #DFDFDF — dividers, inactive borders
color: AppColors.darkD4          // #EEEEEE — icon container backgrounds
color: AppColors.borderInactive  // #E0E0E0 — inactive field borders
color: AppColors.fieldBackground // #F8F8F8 — text field fill
color: AppColors.iconBackground  // #F3F3F3 — icon / button container fill
color: AppColors.hintText        // #BDBDBD — placeholder text
color: AppColors.success         // #4CAF50 — success state
color: AppColors.error           // #FE6241 — error state
color: AppColors.splashGradientTop    // #CF5F3A — primary brand
color: AppColors.splashGradientBottom // #3A9E8C — secondary brand

// Wrong — never do this
color: const Color(0xFF808080)
color: Color(0xFFF8F8F8)
```

**When you need a color that doesn't exist yet:**
1. Add it to `lib/core/constants/app_colors.dart` with a descriptive semantic name
2. Use the new constant everywhere — never the raw hex

**Never** use `Colors.*` Flutter constants — every color, including white, black, and transparent, must come from `AppColors`. Add a new named constant to `app_colors.dart` if the color you need does not yet exist there. Common equivalents already available:

| Flutter constant | AppColors equivalent |
|---|---|
| `Colors.white` | `AppColors.white` |
| `Colors.black` | `AppColors.black` |
| `Colors.transparent` | `AppColors.transparent` |
| `Colors.black54` | `AppColors.black54` |
| `Colors.white70` | `AppColors.white70` |
| `Colors.grey` | `AppColors.grey` |
| `Colors.grey[100]` | `AppColors.greyLight` |
| `Colors.green` | `AppColors.success` |
| `Colors.green.shade600` | `AppColors.exportExcelGreen` |
| `Colors.red` | `AppColors.error` |
| `Colors.red.shade600` | `AppColors.exportPdfRed` |
| `Colors.amber` | `AppColors.warning` |

---

## Typography

Always use `context.textTheme` — never hardcode `TextStyle`.

```dart
// Headings (all Bold w700)
context.textTheme.h1    // 48px
context.textTheme.h2    // 40px
context.textTheme.h3    // 32px
context.textTheme.h4    // 24px
context.textTheme.h5    // 20px
context.textTheme.h6    // 18px

// Body with weight variants
context.textTheme.bodyLargeBold / bodyLargeMedium / bodyLargeRegular      // 18px
context.textTheme.bodyMediumBold / bodyMediumMedium / bodyMediumRegular   // 16px
context.textTheme.bodySmallBold / bodySmallMedium / bodySmallRegular      // 14px
context.textTheme.bodyVerySmallRegular                                     // 12px

// Override only when needed
style: context.textTheme.bodyMedium?.copyWith(color: Colors.red)
```

---

## Failure Classes

```dart
abstract class Failure { final String message; Failure({required this.message}); }

class ServerFailure extends Failure { ... }   // 4xx, 5xx HTTP errors
class NetworkFailure extends Failure { ... }  // Timeout, no connection
class CacheFailure extends Failure { ... }    // Local storage errors
class ValidationFailure extends Failure { ... }
class UnknownFailure extends Failure { ... }
```

---

## Adding a New Feature — Checklist

Follow this order every time:

1. `domain/entities/` → Entity (pure Dart)
2. `domain/repositories/` → Abstract repository interface
3. `domain/usecases/` → Use case(s)
4. `data/models/` → Model extending entity
5. `data/datasources/` → Remote DataSource (+ Local only if caching needed)
6. `data/repositories/` → Repository implementation
7. `presentation/cubit/` → Cubit & States in two separate files (`your_cubit.dart` & `your_state.dart` using `part` / `part of`)
8. `presentation/pages/` → Page
9. `presentation/widgets/` → Widget(s)
10. `service_locator.dart` → Register all dependencies
11. `main.dart` → Add BlocProvider if needed
12. `core/routes/` → Add GoRoute + RoutesName entry
13. `assets/translations/` → Add keys to **both** `en.json` and `ar.json`; then run the generation command to regenerate `generated/locale_keys.g.dart`
14. Colors → use existing `AppColors.*` constants; add new ones to `app_colors.dart` if needed — never inline hex values

---

---

## ⚠️ Widget Rules — Read Before Writing Any UI

### Before writing any UI component

1. Check `lib/core/widgets/` for an existing widget that covers the use case.
2. Check `lib/core/theme/` for colors, text styles, and spacing.
3. Use existing widgets — **never recreate them**.

### Widget locations

| Widget type | Location |
|---|---|
| General reusable widgets | `lib/core/widgets/` |
| Text inputs / form fields | `lib/core/widgets/app_text_field.dart`, `app_search_bar.dart`, etc. |
| Dropdown fields | `lib/core/widgets/app_dropdown_field.dart` |
| Date fields | `lib/core/widgets/app_date_field.dart` |
| Priority badges | `lib/core/widgets/app_priority_badge.dart` |
| App bar | `lib/core/widgets/app_bar_widget.dart` |
| Theme / colors / spacing | `lib/core/theme/` |

### Rules

- **NEVER** create inline `StatelessWidget` or `StatefulWidget` classes inside screen/page files unless they are purely private to that screen and have no counterpart in `lib/core/widgets/`.
- **ALWAYS** check `lib/core/widgets/` before building any UI element.
- Any widget used in more than one place **must** be extracted to `lib/core/widgets/`.
- New reusable widgets go in `lib/core/widgets/` and must be documented in the **Reusable Core Widgets** section below.
- Never copy widget code between files — import from `lib/core/widgets/` instead.

---

## Reusable Core Widgets

All shared UI primitives live in `lib/core/widgets/`. **Never build a custom
version inline** — always use the widget below and add new ones here when a
pattern repeats across features.

### `AppPriorityBadge` — priority pill

```dart
import 'package:purchases/core/widgets/app_priority_badge.dart';

// Static display (list card, detail header)
AppPriorityBadge(priority: pr.priority!, label: pr.priorityValue)

// Selectable chip (filter sheet)
AppPriorityBadge(
  priority: key,
  label: label,
  isSelected: selected == key,
  onTap: () => onSelect(selected == key ? null : key),
)
```

Parameters: `priority` (required, `urgent`/`high`/`medium`/`low`),
`label` (optional, falls back to l10n), `isSelected` (border when selected),
`onTap` (makes badge tappable).

Helper functions `priorityBackgroundColor(priority)` and
`priorityDotColor(priority)` are also exported from the same file.

### `AppDateField` — labelled date picker trigger

```dart
import 'package:purchases/core/widgets/app_date_field.dart';

AppDateField(
  title: LocaleKeys.prExpectedArrival.tr(),  // label above field
  value: fd.receiveDate,                      // formatted display string or null
  placeholder: LocaleKeys.prExpectedArrival.tr(),
  hasError: state.fieldErrors.containsKey('receiveDate'),
  onTap: _pickDate,                        // open showDatePicker in caller
)
```

Parameters: `title` (required), `onTap` (required), `value` (formatted
string to display), `placeholder` (shown when null), `hasError` (red border).

### `AppDropdownField<T>` — labelled dropdown

```dart
import 'package:purchases/core/widgets/app_dropdown_field.dart';

AppDropdownField<DepartmentEntity>(
  title: LocaleKeys.prDepartment.tr(),
  value: selectedDept,
  hint: LocaleKeys.prDepartmentHint.tr(),
  items: departments.map((d) => DropdownMenuItem(
    value: d,
    child: Text(d.name),
  )).toList(),
  hasError: state.fieldErrors.containsKey('departmentId'),
  onChanged: (d) => cubit.updateDepartment(d?.id),
)
```

Parameters: `title` (required), `items` (required), `onChanged` (required),
`value`, `hint`, `hasError` (red border), `enabled` (greyed-out when false).

### `AppTextField` — styled text input field

```dart
import 'package:purchases/core/widgets/app_text_field.dart';

// Basic field with icon
AppTextField(
  controller: _nameCtrl,
  hint: LocaleKeys.prEmployeeNameHint.tr(),
  icon: Icons.person_outline_rounded,
  hasError: state.fieldErrors.containsKey('employeeName'),
  onChanged: (v) => cubit.updateEmployeeName(v),
)

// Numeric-only
AppTextField(
  controller: _periodCtrl,
  hint: LocaleKeys.prWaitingPeriodHint.tr(),
  keyboardType: TextInputType.number,
  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  onChanged: (v) => cubit.updatePeriod(int.tryParse(v) ?? 0),
)

// Multi-line notes
AppTextField(
  controller: _notesCtrl,
  hint: LocaleKeys.prItemNotesHint.tr(),
  maxLines: 3,
  onChanged: cubit.updateNotes,
)
```

Parameters: `controller` (required), `hint`, `icon` (prefix, right in RTL),
`hasError` (red border), `enabled`, `onChanged`, `onSubmitted`,
`keyboardType`, `inputFormatters`, `maxLines` (default 1),
`textAlign` (default right), `textInputAction`, `focusNode`.

**Rules:**
- **Never** use a raw `TextField` or `TextFormField` inline — always use `AppTextField`.
- No orange/accent focus border — `focusedBorder` always uses `AppColors.borderInactive`
  (or `AppColors.error` when `hasError`).
- For fields that need their own controller lifecycle inside a list (e.g. product rows),
  wrap in a small `StatefulWidget` that holds the controller and delegates to `AppTextField`.

### `AppSearchBar` — search input with clear button

```dart
import 'package:purchases/core/widgets/app_search_bar.dart';

// Caller provides controller (to clear programmatically)
AppSearchBar(
  controller: _searchCtrl,
  hint: LocaleKeys.searchHint.tr(),
  onChanged: _onSearch,          // debounce in the caller if needed
  onClear: cubit.clearSearch,    // optional extra callback on clear tap
)

// Widget manages its own controller
AppSearchBar(
  hint: LocaleKeys.searchHint.tr(),
  onChanged: cubit.search,
)
```

Parameters: `onChanged` (required), `controller` (optional — widget manages
internally when omitted), `hint`, `onClear`.

Features: search icon at text-start (right in RTL); × clear button appears
automatically when text is present; neutral grey border on all states (no
orange focus ring).

**Rule:** Use `AppSearchBar` for every search input in the app — never
duplicate the styling inline or create a private `_SearchBar` widget.

---

## Do / Don't

**Do:**
- Keep entities as pure Dart classes with zero external dependencies
- Use constructor injection for all dependencies
- Handle all three result states (loading, loaded, error) in every BlocBuilder
- Register as `LazySingleton` by default; use `Factory` only for per-use instances
- Use `Either<Failure, T>` for all repository return types
- **Use the toast utility in `lib/core/`** for all user-facing messages (success, error, info)

**Don't:**
- Access the data layer from UI directly
- Put business logic in widgets or pages
- Use `BuildContext` outside the presentation layer
- **Use `ScaffoldMessenger` or `SnackBar` directly** — always use the core toast utility instead
- **Hardcode any color** — use `AppColors.*` for every color value including white, black, and transparent; add new constants when needed — never use `Colors.*`
- **Hardcode any display text** — use `LocaleKeys.yourKey.tr()`; add keys to both `.json` files and run generation first
- **Hardcode any pixel value** — use `.w`, `.h`, `.sp`, `.r` from ScreenUtil for all sizing
- Hardcode font sizes — use `.sp`
- Create `TextStyle()` instances inline — use `context.textTheme`
- Skip the `fold()` — always handle both left (failure) and right (success)
- **Build inline TextFields** — use `AppTextField` for every editable field
- **Build inline search fields** — use `AppSearchBar` for every search input
- **Create private `_SearchBar` or `_InputField` classes** — add to `core/widgets/` instead and reuse
- **Create inline widget classes inside screen files** for anything reusable — extract to `lib/core/widgets/`
- **Copy widget code between files** — import from `lib/core/widgets/`
- **Recreate a widget that already exists** in `lib/core/widgets/` — reuse it

---

## Lint Enforcement — very_good_analysis

This project uses `very_good_analysis` as the sole lint ruleset.
Every file Claude generates or modifies **must pass `dart analyze` with zero
errors, zero warnings, and zero hints** before being returned.

### analysis_options.yaml

```yaml
include: package:very_good_analysis/analysis_options.yaml
```

### Rules Claude must always follow

- `prefer_single_quotes` — single quotes everywhere
- `always_use_package_imports` — `package:` imports only, no relative
  `../` imports
- `prefer_const_constructors` — use `const` wherever possible
- `prefer_const_declarations` — `const` for all top-level and static
  variables
- `prefer_final_locals` — `final` for every local variable that is never
  reassigned
- `prefer_final_fields` — `final` for every field that is never
  reassigned
- `sort_constructors_first` — constructors before all other class members
- `use_key_in_widget_constructors` — every public widget must have
  `Key? key`
- `sized_box_for_whitespace` — `SizedBox` for spacing, never empty
  `Container`
- `use_decorated_box` — `DecoratedBox` instead of `Container` when only
  decoration is set
- `avoid_unnecessary_containers` — never wrap widgets in `Container`
  unnecessarily
- `avoid_dynamic_calls` — never call methods on `dynamic`
- `avoid_print` — never use `print()`; use a proper logger
- `unawaited_futures` — always `await` futures or explicitly call
  `unawaited()`
- `cancel_subscriptions` — always cancel `StreamSubscription` in
  `dispose()`
- `public_member_api_docs` — every public class, method, and field needs
  a `///` doc comment
- `lines_longer_than_80_chars` — hard wrap at 80 chars; use trailing
  commas to help dartfmt

### Hard rules

- **Never** use `// ignore:` to suppress a lint unless absolutely
  unavoidable, and always add a comment explaining why.
- **Never** use `// ignore_for_file:` — project-wide suppression is
  forbidden.
- **Never** use `BuildContext` across an async gap without a `mounted`
  check.
- **Never** leave a `dispose()` without cleaning up controllers,
  subscriptions, and focus nodes.

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| "Cubit not found in context" | Add it to `MultiBlocProvider` in `main.dart` |
| "Route not found" | Add the route to `app_routes.dart` and `RoutesName` enum |
| Localization not working | Run `flutter clean && flutter pub get` then `dart run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart && dart run easy_localization:generate --source-dir ./assets/translations` |
| Dependencies not resolving | Run `flutter pub get`, check `pubspec.yaml` syntax |
| Unhandled exception in event loop | Ensure all async use cases use `fold()` |
