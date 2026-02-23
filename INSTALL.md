# app_refer

A Flutter application targeting Android and iOS.

---

## Prerequisites

Before running this project, ensure you have the following installed:

- [Flutter](https://docs.flutter.dev/get-started/install) — managed via FVM (do not install a global Flutter version manually)
- [JDK-17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html) - create a new environment variable JAVA_HOME=C:\your_path\jdk-17
- [Android Studio](https://developer.android.com/studio) with the Android SDK configured

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

### 3. Add a new environment variable in Path

```bash
C:\Users\<username>\AppData\Local\Pub\Cache\bin
```

### 4. Install the correct Flutter version via FVM

```bash
fvm install
```

This reads the `.fvmrc` file and installs Flutter **3.38.9** automatically.

### 5. Install dependencies

```bash
fvm flutter pub get
```

### 5.5. Stripe was recently added so there's now a need to install the functions
```bash
cd functions
npm install
```
<!-- firebase functions:secrets:set STRIPE_SECRET_KEY -->

### 6. Add required config files

These files are excluded from version control for security reasons. Obtain them from the project owner and place them as follows:

| File | Destination |
|------|-------------|
| `google-services.json` | `android/app/google-services.json` |
| `firebase_options.dart` | `lib/firebase_options.dart` |
| `secrets.json` | `/` |

### 7. Configure Android signing (release builds only)

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
- Never commit `.env`, `google-services.json`, `key.properties`, `secrets.jsno` or any keystore files.
- If you encounter Gradle issues on Android, run `fvm flutter clean` and try again.
