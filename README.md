# stock_tracker_demo

Stock tracker demo app

## Overview

This project leverages a combination of architectural patterns to provide a robust and maintainable
structure. The core components include:

- Provider: A state management solution that simplifies data flow and updates throughout the
  application.
- GraphQL: A query language for APIs that enables efficient data fetching and manipulation.
- syncfusion_flutter_charts: A chart library that provides a variety of chart types and
  customization options.
- Hive: An in-memory database that stores data in encrypted format (Provided in GraphQL package).
- pull_to_refresh: A library that provides pull-to-refresh functionality for Flutter applications.
- mockito: A mocking library for unit testing.
- golden_toolkit: A library for easier golden tests for Flutter applications.

## Prerequisites:

- Flutter SDK: Ensure you have Flutter 3.24.0 or later installed on your system. You can download it
- from the official Flutter website: https://docs.flutter.dev/get-started/install
- Dart SDK: The Dart SDK is included with Flutter, so you should have it installed automatically.
- IDE or Code Editor: Choose a suitable IDE or code editor that supports Flutter development.
  Popular
  options include:
    - Android Studio (with Flutter plugin)
    - IntelliJ IDEA (with Flutter plugin)
    - Visual Studio Code (with Flutter and Dart extensions)

## Steps to Run the App:

### Clone or Download the App Repository:

- If you have the app's source code available as a Git repository, clone it using the following
  command in your terminal:

```bash
git clone https://github.com/distatk/stock_tracker_demo.git
```

- If you have the app downloaded as a ZIP file, extract its contents to a desired location.

### Navigate to the App Directory:

- Open your terminal or command prompt and navigate to the root directory of the app's source code.

### Get Dependencies:

```bash
flutter pub get
```

### Choose a Device or Emulator:

- Decide whether you want to run the app on a physical device or an emulator.
    - Physical Device: Connect your device to your computer and enable USB debugging.
    - Emulator: Create an emulator configuration that matches your device's specifications and
      launch it.

### Run the App:

- Use the following command to run the app:

```bash
flutter run
```

- The app should build and launch on your chosen device or emulator.

Additional Notes:

If you encounter any errors during the build or run process, carefully review the error messages for
clues on how to resolve them.
You can use the flutter devices command to list available devices or emulators.
For more advanced debugging and profiling, consider using Flutter's built-in tools and extensions.
