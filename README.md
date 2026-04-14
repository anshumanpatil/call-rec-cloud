# CLL Upload

A Flutter application for managing workout recordings and downloads.

## Prerequisites

Before you begin, ensure you have the following installed on your machine:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.0 or higher)
- [Git](https://git-scm.com/)
- A compatible IDE (VS Code, Android Studio, or Xcode)

## Setup Instructions

### 1. Clone the Repository

Clone the project from the remote repository:

```bash
git clone <repository-url>
cd cll_upld
```

Replace `<repository-url>` with the actual URL of the git repository.

### 2. Run Flutter Code

Follow these steps to run the application:

#### Step 1: Get Dependencies
```bash
flutter pub get
```

#### Step 2: Run the Application
```bash
flutter run
```

This command will build and launch the app on your connected device or emulator.

**Optional:** To run on a specific device or emulator, you can specify the device:
```bash
flutter devices                    # List available devices
flutter run -d <device-id>          # Run on specific device
```

## Project Structure

- `lib/` - Main application source code
- `android/` - Android-specific files
- `ios/` - iOS-specific files
- `web/` - Web application files
- `assets/` - Images, fonts, and other assets

## Troubleshooting

If you encounter issues:
- Run `flutter doctor` to check your Flutter environment
- Ensure all dependencies are installed with `flutter pub get`
- Clean the build artifacts with `flutter clean` before rebuilding

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Samples](https://github.com/flutter/samples)
- [Flutter Community](https://flutter.dev/community)
