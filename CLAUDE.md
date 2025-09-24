# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **x_design**, a Flutter UI component library that provides a comprehensive set of reusable widget for Flutter applications. The library focuses on mobile and desktop cross-platform development with internationalization support.

## Key Commands

### Development
- `flutter pub get` - Install dependencies
- `flutter pub run build_runner build` - Generate code (json serialization, etc.)
- `flutter analyze` - Run static analysis
- `flutter test` - Run tests

### Example App
The example app is located in the `example/` directory:
- `cd example && flutter run` - Run the example app
- `cd example && flutter build apk` - Build Android APK
- `cd example && flutter build windows` - Build Windows app

## Architecture

### Library Structure
The main library code is in `lib/src/` organized by feature:

- **`widget/`** - UI widget (buttons, forms, dialogs, maps, etc.)
- **`core/`** - Core functionality and global utilities
- **`models/`** - Data models and state classes
- **`services/`** - Business logic services (caching, networking)
- **`utils/`** - Utility functions and extensions
- **`theme/`** - Theme and styling definitions
- **`interceptors/`** - HTTP interceptors for Dio

### Key widget
- **XDApp** (`src/widget/xd_app.dart`) - Main app wrapper with localization and theme support
- **Map widget** (`src/widget/map/`) - Comprehensive map functionality with drawing tools, layers, and location services
- **Form widget** (`src/widget/form/`) - Form widgets and validation
- **Networking** (`src/widget/network_request/`) - HTTP request handling with Dio
- **Settings** (`src/widget/setting/`) - Language and theme management

### Patterns Used
- **Provider Pattern** - State management using Provider package
- **Component-based Architecture** - Modular UI widget with index.dart exports
- **Dependency Injection** - Using get_it for service location
- **Internationalization** - Flutter's built-in i18n with ARB files

### External Integrations
- **Map Services** - AMap integration for location services (China-focused)
- **File Handling** - File picker, image/video viewing, and uploads
- **Caching** - Hive for local data persistence
- **Network** - Dio with custom interceptors for token handling and logging

## Dependencies

The library uses local plugin dependencies in `plugins/` directory:
- `amap_flutter_location-3.0.0` - Location services
- `r_upgrade-master` - App update functionality

Major external dependencies include flutter_map, dio, hive, provider, and various media/file handling packages.

## Development Notes

- Analysis options exclude `plugins/` and `example/` directories
- Supports both mobile and desktop platforms (detection in `src/core/global.dart`)
- Uses Material 3 design system
- Custom font assets in `assets/fonts/iconfont.ttf`
- Localization files in `lib/l10n/arb/` for multiple languages (zh, en, id, zh_TW)