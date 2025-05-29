# Melody Match

Flutter frontend for the Melody Match.

- [Melody Match](#melody-match)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Running the Project](#running-the-project)
  - [Building the Project](#building-the-project)

## Requirements

Before you begin, ensure you have the following tools installed:

- [Flutter](https://flutter.dev/docs/get-started/install) (version 2.0 or higher)
- [Dart](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/)
- An Android emulator or iOS device for testing

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/kirurr/flutter-melody-match.git
   ```

2. Navigate to the project directory:

   ```bash
   cd flutter-melody-match
   ```

3. Install the dependencies:

   ```bash
   flutter pub get
   ```

## Running the Project

To run the project on an emulator or connected device, execute the following command:

```bash
flutter run
```

You can also specify a particular device if you have multiple:

```bash
flutter run -d <device_id>
```

## Building the Project

To build the project for Android, run:

```bash
flutter build apk
```

To build the project for iOS, run:

```bash
flutter build ios
```