This page walks you through installing the **curl_generator** package into your Dart or Flutter project. The package generates curl (bash) command strings from Dart code, and is published as a standard Dart package with no runtime dependencies beyond the Dart SDK itself.

## Prerequisites

Before installing curl_generator, ensure you have the following tools available on your system.

**Dart SDK**: Version **3.5.3** or newer is required. This is declared in the `pubspec.yaml` environment constraint. You can verify your installed version by running:

```bash
dart --version
```

If you are using **Flutter**, any recent stable channel release includes a compatible Dart SDK, so no separate Dart installation is needed. Just ensure your Flutter installation is up to date with `flutter upgrade`.

**No additional native dependencies** are required. The package is pure Dart — there are no platform-specific plugins, no compiled binaries, and no FFI bindings. This means it works identically across all platforms that Dart supports (macOS, Linux, Windows, web, iOS, Android).

Sources: [pubspec.yaml](pubspec.yaml#L10-L10)

## Installing from pub.dev

The recommended installation method is to add the package as a dependency through Dart's official package manager.

### Step 1: Add the dependency

Run the following command from the root directory of your project:

```bash
dart pub add curl_generator
```

Or, if you are using a **Flutter** project:

```bash
flutter pub add curl_generator
```

This command automatically adds the package to your `pubspec.yaml` under the `dependencies` section and resolves the latest compatible version. After running it, your `pubspec.yaml` will contain an entry like this:

```yaml
dependencies:
  curl_generator: ^1.0.2
```

Alternatively, you can edit `pubspec.yaml` manually by adding the line above under `dependencies`, then run `dart pub get` (or `flutter pub get`) to resolve and download the package.

### Step 2: Verify the installation

After adding the dependency, confirm that the package downloaded successfully:

```bash
dart pub get
```

You should see output confirming that packages were resolved without errors. To verify the package is accessible in code, add the following import to any Dart file:

```dart
import 'package:curl_generator/curl_generator.dart';
```

If your editor or linter shows no errors on this import, the installation is complete and you are ready to use the `Curl` class.

Sources: [pubspec.yaml](pubspec.yaml#L1-L14), [README.md](README.md#L9-L11)

## Installing from Git

If you need a version not yet published to pub.dev, or want to work from a specific commit or branch, you can install directly from the GitHub repository.

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  curl_generator:
    git:
      url: https://github.com/P-B1101/curl_generator.git
```

You can optionally pin a specific **ref** (branch, tag, or commit SHA) to ensure reproducible builds:

```yaml
dependencies:
  curl_generator:
    git:
      url: https://github.com/P-B1101/curl_generator.git
      ref: main
```

Then run `dart pub get` to fetch the package. Note that Git dependencies do not follow semantic versioning — the version you get depends on the state of the referenced ref at fetch time.

Sources: [pubspec.yaml](pubspec.yaml#L5-L5)

## Installing from a Local Path

During development, if you have cloned the repository locally or are contributing to the package, you can reference it via a relative path. This is the approach used by the bundled example project.

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  curl_generator:
    path: ../curl_generator
```

Adjust the path to match the relative location of the `curl_generator` directory on your machine. Then run `dart pub get`. This setup is particularly useful for:

- **Contributing** to the package while testing changes in a consuming project
- **Testing** unreleased features before publishing
- **Offline development** where network access to pub.dev is unavailable

Sources: [example/pubspec.yaml](example/pubspec.yaml#L13-L14)

## Installation Methods Comparison

| Method | Command / Config | Version Control | Best For |
|---|---|---|---|
| **pub.dev** (recommended) | `dart pub add curl_generator` | Semantic versioning (`^1.0.2`) | Production projects |
| **Git repository** | `git: url: https://github.com/P-B1101/curl_generator.git` | Branch, tag, or commit ref | Pre-release features, forks |
| **Local path** | `path: ../curl_generator` | Local filesystem state | Contributing, offline dev |

## Verifying the Installation

Once the package is installed, run the following minimal smoke test to confirm everything works. Create a Dart file (or use an existing one) and add:

```dart
import 'package:curl_generator/curl_generator.dart';

void main() {
  final curl = Curl.curlOf(
    url: 'https://jsonplaceholder.typicode.com/posts',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: {'title': 'hello', 'body': 'world', 'userId': 1},
  );
  print(curl);
}
```

Run it with:

```bash
dart run your_file.dart
```

If the installation was successful, you will see a properly formatted curl command printed to the console. Any import errors or unresolved references at this stage indicate a problem with the installation steps above.

Sources: [lib/src/curl.dart](lib/src/curl.dart#L28-L42)

## Troubleshooting

| Symptom | Likely Cause | Resolution |
|---|---|---|
| `Could not find package "curl_generator"` | Package not yet fetched | Run `dart pub get` |
| `SDK version constraint not satisfied` | Dart SDK below 3.5.3 | Upgrade Dart: `dart upgrade` or update Flutter |
| Import `package:curl_generator/curl_generator.dart` shows red | pubspec.yaml not saved or pub get not run | Save pubspec.yaml, then run `dart pub get` |
| Git install fails with auth error | Repository is private or SSH keys missing | Use HTTPS URL, or configure SSH access |
| Path install fails with "directory not found" | Relative path is incorrect | Verify the path from your project root to the package directory |

## What's Next

With the package installed and verified, proceed to [Basic Usage Examples](4-basic-usage-examples) to see practical demonstrations of generating curl commands for GET, POST, and other HTTP methods with varying combinations of headers, query parameters, and request bodies.