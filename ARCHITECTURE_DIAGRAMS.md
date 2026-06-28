# Architecture Flow Diagram

## 1. Presentation Layer (UI) ↔ State Management

```
┌─────────────────────────────────────────────────┐
│         PRESENTATION LAYER                      │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────────┐         ┌──────────────────┐ │
│  │   HomePage   │◄────────┤    HomeCubit     │ │
│  └──────────────┘         └──────────────────┘ │
│         │                          △           │
│         │                          │           │
│  ┌──────▼──────────────────────────────────┐   │
│  │      BlocBuilder<HomeCubit>             │   │
│  │  - HomeLoadingState                     │   │
│  │  - HomeLoadedState(data)                │   │
│  │  - HomeErrorState(message)              │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │   Widgets                                │  │
│  │   - HomeItemWidget                       │  │
│  │   - CustomCard                           │  │
│  └──────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
           │
           │ Calls
           ▼
┌─────────────────────────────────────────────────┐
│       DOMAIN LAYER (Business Logic)             │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │  GetHomeUseCase                          │  │
│  │  - Takes params/no params                │  │
│  │  - Returns Either<Failure, HomeEntity>   │  │
│  └──────────────────────────────────────────┘  │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │  HomeRepository (Abstract Interface)     │  │
│  │  - getHome(): Future<Either<...>>        │  │
│  └──────────────────────────────────────────┘  │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │  HomeEntity                              │  │
│  │  - Pure Dart class                       │  │
│  │  - No dependencies on external packages  │  │
│  └──────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
           │
           │ Implements
           ▼
┌─────────────────────────────────────────────────┐
│        DATA LAYER (Data Access)                 │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │  HomeRepositoryImpl                       │  │
│  │  Implements HomeRepository               │  │
│  │  - Orchestrates Remote/Local data        │  │
│  │  - Handles fallback logic                │  │
│  └──────────────────────────────────────────┘  │
│           │                                   │
│           ├─────────────┬────────────────────┤
│           │             │                    │
│    ┌──────▼─────────────────────────────┐    │
│    │  datasources/                       │    │
│    │                                     │    │
│    │  ┌──────────────────────────────┐   │    │
│    │  │ Remote DataSource (Flat)     │   │    │
│    │  │ - Abstract + Impl            │   │    │
│    │  │ - API Calls via DioClient    │   │    │
│    │  └──────────────────────────────┘   │    │
│    │                                     │    │
│    │  ┌──────────────────────────────┐   │    │
│    │  │ Local DataSource (Flat)      │   │    │
│    │  │ - Abstract + Impl            │   │    │
│    │  │ - Cache via SecureStorage    │   │    │
│    │  │ - Throws CacheFailure        │   │    │
│    │  └──────────────────────────────┘   │    │
│    └─────────────────────────────────────┘    │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │  HomeModel (extends HomeEntity)          │  │
│  │  - JSON serialization (fromJson/toJson)  │  │
│  │  - Converts to Entity (toEntity())        │  │
│  └──────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
           │
           │ Uses
           ▼
┌─────────────────────────────────────────────────┐
│         CORE LAYER                              │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌─────────────┐  ┌──────────────┐            │
│  │  Failures   │  │  Exceptions  │            │
│  └─────────────┘  └──────────────┘            │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │  DioClient & DioExceptionHandler         │  │
│  │  - HTTP requests with token injection   │  │
│  │  - Exception to Failure conversion      │  │
│  └──────────────────────────────────────────┘  │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │  AppConstants                            │  │
│  │  - API endpoints                         │  │
│  │  - Timeouts                              │  │
│  │  - Cache keys & durations                │  │
│  └──────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

---

## 2. Dependency Injection Flow

```
┌─────────────────────────────────────────────┐
│  main.dart                                  │
│  setupServiceLocator()                      │
└─────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────┐
│  service_locator.dart                       │
├─────────────────────────────────────────────┤
│                                             │
│  1. Register Core Layer                     │
│     └─ DioClient, DioExceptionHandler        │
│                                             │
│  2. Register Data Sources (Separate Files)  │
│     ├─ Remote DataSources [REQUIRED]        │
│     │  ├─ HomeRemoteDataSource (abstract)   │
│     │  └─ HomeRemoteDataSourceImpl (impl)    │
│     └─ Local DataSources [OPTIONAL]         │
│        ├─ HomeLocalDataSource (abstract)    │
│        └─ HomeLocalDataSourceImpl (impl)     │
│                                             │
│  3. Register Repositories                   │
│     └─ HomeRepository                       │
│        (depends on: Remote & Local DS)      │
│                                             │
│  4. Register Use Cases                      │
│     └─ GetHomeUseCase                       │
│        (depends on: Repository)             │
│                                             │
│  5. Register Cubits                         │
│     └─ HomeCubit                            │
│        (depends on: UseCase)                │
│                                             │
└─────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────┐
│  GetIt ServiceLocator                       │
│  (Central registry of all dependencies)     │
└─────────────────────────────────────────────┘
           │
           │ Inject dependencies
           ▼
┌─────────────────────────────────────────────┐
│  UI/Pages/Cubits                            │
│  (Access dependencies via getIt<Type>())    │
└─────────────────────────────────────────────┘
```

---

## 3. Data Flow: User Action to UI Update

```
User Interaction (Button Tap)
        │
        ▼
┌──────────────────────────────┐
│ context.read<HomeCubit>()    │
│ .getHome()                   │
└──────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│ HomeCubit.getHome()                  │
│ 1. emit(HomeLoadingState())          │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│ GetHomeUseCase.call()                │
│ Returns Either<Failure, HomeEntity>  │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│ HomeRepository.getHome()             │
│                                      │
│ 1. Try Remote DataSource [REQUIRED]  │
│    └─ Fetch from API                 │
│    └─ If configured: Cache locally   │
│                                      │
│ 2. If Remote fails:                  │
│    └─ If Local DS exists [OPTIONAL]  │
│       └─ Try Local DataSource        │
│       └─ Return cached data          │
│    └─ Else: Return error             │
│                                      │
│ 3. Wrap in Either<Failure, Success>  │
└──────────────────────────────────────┘
        │
        ├─────────────────┬──────────────────┤
        │                 │                  │
        ▼                 ▼                  ▼
┌────────────────┐ ┌──────────────┐ ┌──────────┐
│ Remote DS      │ │ Remote fails │ │ Local DS │
│ datasources/   │ │              │ │ datasour │
│ your_remote    │ │ (DioExc)     │ │ ces/     │
│ _data_source   │ │ Converted via│ │ your_loc │
│                │ │ DioExcepti   │ │ al_data_ │
│ API Call       │ │ onHandler    │ │ source   │
│ via DioClient  │ │              │ │          │
│                │ │ Returns      │ │ Cache    │
│ Returns data   │ │ Failure:     │ │ retrieval│
│ or throws      │ │ Network/     │ │ Throws   │
│ Failure*       │ │ Server/etc   │ │ CacheFai │
│ (*via DioExc   │ │ (fallback)   │ │ lure     │
│  Handler)      │ │              │ │          │
└────────────────┘ └──────────────┘ └──────────┘
        │                              │
        └──────────────┬───────────────┘
                       │
                       ▼
┌──────────────────────────────────────┐
│ Parse & Convert                      │
│ HomeModel.fromJson()                 │
│ Convert to HomeEntity                │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│ result.fold()                        │
│ On Failure: HomeErrorState           │
│ On Success: HomeLoadedState          │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│ emit(HomeLoadedState(data: entity))  │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│ BlocBuilder listens to state changes │
│ Rebuilds UI with new state           │
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│ UI Updates with HomeLoadedState      │
│ - Displays data from HomeEntity      │
│ - User sees the result               │
└──────────────────────────────────────┘
```

---

## 4. Navigation Flow with GoRouter

```
┌────────────────────────────────────────────┐
│  app_routes.dart                           │
│  GoRouter Configuration                    │
├────────────────────────────────────────────┤
│                                            │
│  GoRouter(                                 │
│    initialLocation: '/home'                │
│    routes: [                               │
│      GoRoute(                              │
│        path: '/home' ◄─── RouteNames.home  │
│        builder: => HomePage()              │
│      ),                                    │
│      GoRoute(                              │
│        path: '/profile'                    │
│        builder: => ProfilePage()           │
│      ),                                    │
│    ]                                       │
│  )                                         │
│                                            │
└────────────────────────────────────────────┘
        │
        ▼
┌────────────────────────────────────────────┐
│  In Widget: Navigation                     │
│                                            │
│  Simple: context.go('/home')               │
│  Named:  context.goNamed('profile')        │
│  With params: context.go('/profile/123')   │
│  Back: context.pop()                       │
│                                            │
└────────────────────────────────────────────┘
        │
        ▼
┌────────────────────────────────────────────┐
│  GoRouter matches route and builds UI      │
│  Maintains history for back navigation     │
└────────────────────────────────────────────┘
```

---

## 5. Localization Flow

```
┌────────────────────────────────────────────┐
│  assets/translations/                      │
│  ├─ en.json  (English)                     │
│  └─ ar.json  (Arabic)                      │
└────────────────────────────────────────────┘
        │
        ▼
┌────────────────────────────────────────────┐
│  Easy Localization Configuration           │
│  (in main.dart)                            │
│                                            │
│  EasyLocalization(                         │
│    path: 'assets/translations',            │
│    supportedLocales: [en, ar],             │
│    fallbackLocale: en,                     │
│  )                                         │
│                                            │
└────────────────────────────────────────────┘
        │
        ▼
┌────────────────────────────────────────────┐
│  Generate LocaleKeys (Type-Safe)           │
│                                            │
│  $ dart run easy_localization:generate \   │
│    --source-dir ./assets/translations \    │
│    -f keys -o locale_keys.g.dart           │
│                                            │
│  Creates: lib/generated/locale_keys.g.dart│
│                                            │
└────────────────────────────────────────────┘
        │
        ▼
┌────────────────────────────────────────────┐
│  In Widgets: Use LocaleKeys (Recommended) │
│                                            │
│  import 'package:touch/generated/         │
│    locale_keys.g.dart';                    │
│                                            │
│  Text(LocaleKeys.welcome.tr())             │
│  // Type-safe & compiler checks key        │
│                                            │
│  Text(LocaleKeys.name.tr(args: ['John'])) │
│  // With parameters                        │
│                                            │
│  OR use direct string (not recommended):   │
│  Text('welcome'.tr())                      │
│                                            │
└────────────────────────────────────────────┘
        │
        ▼
┌────────────────────────────────────────────┐
│  Change Language (Runtime)                 │
│                                            │
│  EasyLocalization.of(context)?.setLocale(  │
│    const Locale('ar')                      │
│  )                                         │
│                                            │
│  // App rebuilds with new locale           │
│  // All texts update automatically         │
│                                            │
└────────────────────────────────────────────┘
```

---

## 6. Error Handling Pattern

```
Any Operation
        │
        ▼
┌──────────────────────────────────┐
│  try block                       │
│  Perform operation               │
└──────────────────────────────────┘
        │
        ├─ Success ──────────────────┐
        │                            │
        │                    ┌───────▼────────┐
        │                    │ return Right   │
        │                    │ (success data) │
        │                    └────────────────┘
        │                            │
        │                            ▼
        │                    ┌──────────────────────┐
        │                    │ result.fold(failure) │
        │                    │ Handle success       │
        │                    └──────────────────────┘
        │
        └─ Exception ────────────────┐
                                      │
                                ┌─────▼──────────┐
                                │ catch block    │
                                │ Create Failure │
                                │ return Left    │
                                └────────────────┘
                                       │
                                       ▼
                            ┌──────────────────────┐
                            │ result.fold(success) │
                            │ Handle error         │
                            └──────────────────────┘
```

---

## 7. Feature Structure

```
features/
└── home/
    ├── data/
    │   ├── datasources/
    │   │   ├── home_local_data_source.dart ⭕ [OPTIONAL]
│   │   └── home_remote_data_source.dart ✅ [REQUIRED]
    │   │       ├── HomeRemoteDataSource (interface)
    │   │       └── HomeLocalDataSource (interface)
    │   │
    │   ├── models/
    │   │   └── home_model.dart
    │   │       └── Extends HomeEntity
    │   │           Adds JSON serialization
    │   │
    │   └── repositories/
    │       └── home_repository_impl.dart
    │           └── Implements HomeRepository
    │               Coordinates data sources
    │
    ├── domain/
    │   ├── entities/
    │   │   └── home_entity.dart
    │   │       └── Pure Dart class
    │   │
    │   ├── repositories/
    │   │   └── home_repository.dart
    │   │       └── Abstract interface
    │   │
    │   └── usecases/
    │       └── usecases/
    │           ├── get_home_usecase.dart
    │           └── get_home_list_usecase.dart
    │           ├── GetHomeUseCase
    │           └── GetHomeListUseCase
    │
    └── presentation/
        ├── cubit/
        │   └── home_cubit.dart
        │       ├── Events
        │       ├── States
        │       └── HomeCubit
        │
        ├── pages/
        │   └── home_page.dart
        │       └── Main UI Screen
        │
        └── widgets/
            └── home_item_widget.dart
                └── Reusable Components
```

This visual guide helps understand how data flows through the architecture!
