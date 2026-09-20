# Somics OS

Welcome to the Somics OS project. This project is built with Flutter and provides a mobile application for the Somics OS ecosystem.

## Table of Contents

- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Project](#running-the-project)
- [Testing](#testing)
- [Build](#build)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- **Flutter**:
  - [Flutter documentation](https://docs.flutter.dev/get-started/install)
  - Version: 3.44.2
  - Dart: 3.12.2

- **Android Studio**:
  - [Download Android Studio](https://developer.android.com/studio)
  - Version 36 or later

- **Xcode**:
  - [Download Xcode](https://developer.apple.com/xcode/)
  - Version 16.2 or later

- **Device or Emulator**:
  - You have a device or emulator to run the application.

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

1. Connect a device or start an emulator.

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

## Testing

This project uses Flutter's built-in testing framework. To run tests, use the following command:

    ```bash
    flutter test
    ```

## Build

    ```bash
    flutter build windows --release
    ```
