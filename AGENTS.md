# AGENTS.md

## Flutter Commands

- Run app: `flutter run`
- Run tests: `flutter test`
- Static analysis (lint): `flutter analyze`
- Install dependencies: `flutter pub get`
- Build for iOS: `flutter build ios`
- Build for Android: `flutter build apk`

## Known Issues

Syntax errors in `lib/main.dart`:
- Line 31: `colorScheme: .fromSeed(...)` → `colorScheme: ColorScheme.fromSeed(...)`
- Line 105: `mainAxisAlignment: .center` → `mainAxisAlignment: MainAxisAlignment.center`

## Project Structure

- Entry point: `lib/main.dart`
- Tests: `test/widget_test.dart`
- Config: `pubspec.yaml`, `analysis_options.yaml`
- SDK: ^3.11.0 (Dart 3)

## Before Running

Run `flutter pub get` to fetch dependencies, then `flutter analyze` to verify code.