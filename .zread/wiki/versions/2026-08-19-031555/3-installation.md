This page guides you through installing the `curl_generator` package into your Dart or Flutter project. By the end, you will have the library available for use and be ready to generate curl commands from your Dart code.

## Prerequisites

Before installing `curl_generator`, ensure your development environment meets these requirements:

| Requirement | Minimum Version | Check Command |
|-------------|-----------------|---------------|
| Dart SDK | `3.5.3` or higher | `dart --version` |
| Flutter SDK *(optional)* | `3.x` or higher | `flutter --version` |
| Package manager | `dart pub` or `flutter pub` | Bundled with SDK |

> **Note**: If you are using Flutter, the Flutter SDK includes Dart and `pub` automatically. You do not need to install Dart separately.

Sources: [pubspec.yaml](pubspec.yaml#L8-L9)

## Installation Methods

Choose one of the following methods based on your project setup:

### Option 1: pub.dev (Recommended)

The standard and recommended way to install `curl_generator` is through pub.dev, the official Dart package repository.

**For Dart projects:**
```bash
dart pub add curl_generator
```

**For Flutter projects:**
```bash
flutter pub add curl_generator
```

This command automatically:
- Adds `curl_generator` to your `pubspec.yaml` under `dependencies`
- Resolves and downloads the package to your `.dart_tool/package_config.json`
- Makes the library available for import

**Manual alternative** — Add directly to your `pubspec.yaml`:
```yaml
dependencies:
  curl_generator: ^1.0.2
```

Then run:
```bash
dart pub get    # Dart projects
# or
flutter pub get # Flutter projects
```

Sources: [README.md](README.md#L11-L12), [pubspec.yaml](pubspec.yaml#L3-L4)

### Option 2: Git Repository

Install directly from the GitHub repository for access to the latest unreleased changes:

```yaml
dependencies:
  curl_generator:
    git:
      url: https://github.com/P-B1101/curl_generator.git
      ref: main
```

Then run `dart pub get` or `flutter pub get` to fetch the package.

| When to Use Git | When to Use pub.dev |
|-----------------|---------------------|
| Need latest unreleased features | Stable production use |
| Contributing to development | Standard projects |
| Specific branch or commit | Maximum compatibility |

Sources: [pubspec.yaml](pubspec.yaml#L6-L7)

### Option 3: Local Path Dependency

For local development or testing against a modified version of the package, use a path dependency:

```yaml
dependencies:
  curl_generator:
    path: ../path/to/curl_generator
```

This is how the included `example` project references the library:

Sources: [example/pubspec.yaml](example/pubspec.yaml#L13-L14)

## Importing the Library

Once installed, import the package in your Dart files:

```dart
import 'package:curl_generator/curl_generator.dart';
```

This single import gives you access to the `Curl` class and all its static methods. The library uses Dart's `part` directive internally to organize its implementation — you only need to remember one import statement.

Sources: [lib/curl_generator.dart](lib/curl_generator.dart#L1-L6)

## Verifying Your Installation

After installation, create a simple test to confirm everything works:

```dart
import 'package:curl_generator/curl_generator.dart';

void main() {
  final curl = Curl.curlOf(
    url: 'https://api.example.com/data',
  );
  
  print(curl);
  // Expected output: curl 'https://api.example.com/data' \
  //   --compressed \
  //   --insecure
}
```

Run the file to verify:
```bash
dart run your_file.dart
```

If you see the curl output above, the installation is complete.

## Project Structure After Installation

Your project will have the following relevant files after adding the dependency:

```
your_project/
├── pubspec.yaml            # curl_generator listed under dependencies
├── pubspec.lock            # Lock file with resolved version
├── .dart_tool/
│   └── package_config.json # Package resolution paths
└── lib/
    └── your_file.dart      # Your code with import statement
```

Sources: [lib/curl_generator.dart](lib/curl_generator.dart#L1-L6)

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| `Package not found` | Package not added to dependencies | Run `dart pub add curl_generator` |
| `SDK constraint not satisfied` | Dart SDK below `3.5.3` | Upgrade Dart: `dart upgrade` or install latest SDK |
| `Could not find a file named "curl_generator.dart"` | Import path incorrect | Use `package:curl_generator/curl_generator.dart` not a relative path |
| ` pub get failed` | Network or cache issue | Run `dart pub cache repair` then retry `dart pub get` |

## What's Next?

With `curl_generator` installed, you are ready to start generating curl commands:

- **[Quick Start](2-quick-start)** — See a working example in under 2 minutes
- **[The Curl.curlOf Method](4-the-curl-curlof-method)** — Understand the core API for generating curl commands
- **[Generating Basic GET Requests](5-generating-basic-get-requests)** — Build your first curl string step by step