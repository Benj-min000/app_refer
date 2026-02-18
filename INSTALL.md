# app_refer

A Flutter application targeting Android and iOS.

---

## Prerequisites

Before running this project, ensure you have the following installed:

- [Flutter](https://docs.flutter.dev/get-started/install) — managed via FVM (do not install a global Flutter version manually)
- [FVM (Flutter Version Manager)](https://fvm.app/documentation/getting-started/installation)
- [Android Studio](https://developer.android.com/studio) with the Android SDK configured
- 
---

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/Benj-min000/app_refer.git
cd app_refer
git checkout text/marcin
```

### 2. Install FVM
```bash
dart pub global activate fvm
```

### 3. Install the correct Flutter version via FVM

```bash
fvm install
```

This reads the `.fvmrc` file and installs Flutter **3.38.9** automatically.

### 4. Install dependencies

```bash
fvm flutter pub get
```

### 5. Add required config files

These files are excluded from version control for security reasons. Obtain them from the project owner and place them as follows:

| File | Destination |
|------|-------------|
| `google-services.json` | `android/app/google-services.json` |
| `firebase_options.dart` | `lib/firebase_options.dart` |

> Alternatively, if you have Firebase access, regenerate `firebase_options.dart` by running:
> ```bash
> flutterfire configure
> ```

### 6. Configure Android signing (release builds only)

For debug builds this step can be skipped. For release, obtain `key.properties` and the keystore file from the project owner and place `key.properties` at `android/key.properties`.

---

## VS Code Setup

This project uses VS Code as the recommended editor. The repository includes shared configuration under `.vscode/`.

1. Open the project folder in VS Code:
   ```bash
   code .
   ```

2. FVM must be configured so VS Code uses the correct Flutter SDK. Run the following once inside the project:
   ```bash
   fvm flutter config --enable-fvm
   ```
   VS Code will automatically pick up the SDK path via the `.fvm/` symlink.

3. Use the **Run and Debug** panel (`Ctrl+Shift+D` / `Cmd+Shift+D`) to launch the app using the preconfigured launch profiles defined in `.vscode/launch.json`.

---

## Running the App

### Android

Connect a device or start an Android emulator, then:

- Use the VS Code Run and Debug panel and select the appropriate launch configuration, or

---

## Common Commands

| Command | Description |
|---------|-------------|
| `fvm flutter pub get` | Install/update dependencies |
| `fvm flutter run` | Run on connected device |
| `fvm flutter build apk` | Build Android APK |
| `fvm flutter clean` | Clean build artifacts |

---

## Notes

- Always use `fvm flutter` instead of `flutter` directly to ensure the correct SDK version (3.38.9) is used.
- Use VS Code with the provided `.vscode/launch.json` profiles for a consistent run configuration.
- Never commit `.env`, `google-services.json`, `key.properties`, or any keystore files.
- If you encounter Gradle issues on Android, run `fvm flutter clean` and try again.
