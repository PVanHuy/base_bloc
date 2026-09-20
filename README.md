# Somics OS

Welcome to the Somics OS project! This project is built with Flutter and
provides a mobile application for the Somics OS ecosystem.

## Table of Contents

- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Project](#running-the-project)
- [Generate Files](#generate-files)
- [Testing](#testing)
- [Build](#build)

## Getting Started

These instructions will get you a copy of the project up and running for
development and testing purposes.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- **Flutter**:
  - [Flutter documentation](https://docs.flutter.dev/get-started/install)
  - Version: 3.44.2
  - Dart: 3.12.2

- **Android Studio**:
  - [Download Android Studio](https://developer.android.com/studio)
  - Version: 36 or later

- **Xcode**:
  - [Download Xcode](https://developer.apple.com/xcode/)
  - Required for iOS development on macOS

- **Device or Emulator**:
  - You have an Android or iOS device, simulator, or emulator available.

## Installation

1. Clone the repository to your local machine:

    ```bash
    git clone https://....
    cd somics_os
    ```

2. Install the dependencies:

    ```bash
    flutter pub get
    ```

## Running the Project

1. Connect a device or start an emulator/simulator.

2. Run the project:

    ```bash
    flutter run
    ```

3. To run the project on a specific device, use:

    ```bash
    flutter run -d <device_id>
    ```

    You can list all connected devices using:

    ```bash
    flutter devices
    ```

## Generate Files

The project includes a JavaScript generator for creating a BLoC page
structure.

Run the generator from the project root:

```bash
node lib/pages/temp/auto_gen_file.js
```

Enter a page name in `snake_case`, for example `device_status`. The generator
creates these files under `lib/pages/<page_name>/`:

```text
<page_name>_controller.dart
<page_name>_event.dart
<page_name>_state.dart
<page_name>_parameter.dart
<page_name>_page.dart
```

## Testing

This project uses Flutter's built-in testing framework. To run tests, use the
following command:

```bash
flutter test
```

## Build

Build the Android application:

```bash
flutter build apk --release
```

Build an Android App Bundle for Google Play:

```bash
flutter build appbundle --release
```

Build the iOS application on macOS with Xcode installed:

```bash
flutter build ios --release
```

Build for the iOS simulator:

```bash
flutter build ios --simulator
```
