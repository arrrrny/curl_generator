The `curl_generator` package ships with a focused unit test suite that validates the correctness of generated curl commands. This page explains how to execute the tests locally, interpret the results, and understand the test organization so you can confidently verify changes or contributions.

---

## Prerequisites

Before running tests, ensure you have a Dart SDK installed. The project targets Dart SDK `^3.5.3` as declared in the project configuration. Any SDK version satisfying that constraint (3.5.3 or higher) will work.

Sources: [pubspec.yaml](pubspec.yaml#L9-L10)

You can verify your installation by running:

```bash
dart --version
```

This should output a version number (e.g., `Dart SDK version: 3.13.0`). If the command is not found, visit [dart.dev](https://dart.dev/get-dart) to install the SDK.

---

## Running the Full Test Suite

The project uses the standard Dart `test` package as its only dev dependency. To execute all tests, navigate to the project root directory and run:

```bash
dart test
```

This command discovers all test files under the `test/` directory and executes every test case. You will see output similar to:

```
00:00 +15: All tests passed!
```

The `+15` indicates that all 15 test cases passed. A failing test would display a red summary with the specific test name and the assertion mismatch.

Sources: [pubspec.yaml](pubspec.yaml#L12-L13)

---

## Running a Single Test

When developing or debugging, you may want to isolate a specific test. The Dart test runner supports filtering by test name using the `--name` flag:

```bash
dart test --name "test POST method with has only body"
```

This executes only the test whose description matches the provided string (or a substring of it). This is particularly useful when you are iterating on a single feature, such as header auto-detection or body serialization.

---

## Test Organization and Structure

All tests reside in a single file: `test/curl_generator_test.dart`. The file contains **15 unit tests** organized by feature area, all within a single top-level `void main()` function.

Sources: [curl_generator_test.dart](test/curl_generator_test.dart#L1-L218)

Each test follows an identical three-step pattern:

| Step | Action | Example |
|------|--------|---------|
| 1. **Arrange** | Define input constants (`url`, `headers`, `queryParams`, `body`) | `const url = 'https://some.api.com/some/api';` |
| 2. **Act** | Call `Curl.curlOf(...)` with the inputs | `final result = Curl.curlOf(url: url, body: body);` |
| 3. **Assert** | Compare against an expected curl string using `expect()` | `expect(expectedReturn, result);` |

This **Arrange → Act → Assert** (AAA) pattern keeps each test self-contained and readable. There is no shared setup, mocking, or external state — every test is a pure function call with deterministic output.

---

## What the Tests Cover

The 15 test cases form a **behavioral specification** of the `Curl.curlOf()` API. They are grouped thematically across the following feature dimensions:

### Request Method Handling

Tests verify that non-GET methods (like `POST`) produce a `--request POST` flag, while `GET` is the default and omitted from the output.

Sources: [curl_generator_test.dart](test/curl_generator_test.dart#L7-L18)

### Query Parameter Construction

Three tests cover query parameters: parameters embedded directly in the URL string, parameters passed as a separate `queryParams` map, and the combination of both. This ensures the generator handles URL construction correctly regardless of input style.

Sources: [curl_generator_test.dart](test/curl_generator_test.dart#L44-L65)

### Header Emission

Tests validate that user-supplied headers appear as `-H 'Key: Value'` pairs in the correct order, and that `--compressed` is always appended as the final flag.

Sources: [curl_generator_test.dart](test/curl_generator_test.dart#L67-L82)

### Body Serialization and Content-Type Auto-Detection

Several tests verify that when a `body` map is provided, the generator automatically adds a `-H 'Content-Type: application/json'` header and serializes the body with `--data-raw`. Crucially, tests also verify that Content-Type is **not** duplicated when the user already supplies it (including case-insensitive matching).

Sources: [curl_generator_test.dart](test/curl_generator_test.dart#L120-L185)

### HTTPS vs HTTP Behavior

A dedicated test confirms that HTTP URLs receive the `--insecure` flag, while HTTPS URLs do not. This is a security-relevant behavior that the test suite guards explicitly.

Sources: [curl_generator_test.dart](test/curl_generator_test.dart#L153-L160)

### Complex Body Objects

The final test validates that nested objects (including instances of the `Curl` class itself) are serialized correctly into JSON within the `--data-raw` payload.

Sources: [curl_generator_test.dart](test/curl_generator_test.dart#L201-L218)

---

## Interpreting Test Failures

When a test fails, the output includes the test description, the expected value, and the actual value. A typical failure looks like:

```
Expected: curl 'https://example.com' \\\n  --compressed
  Actual: curl 'https://example.com' \\\n  --compressed \\\n  --insecure
```

Since the library produces plain string output, failures almost always indicate one of:

- A missing or extra flag (e.g., `--compressed`, `--insecure`, `--request`)
- A malformed header line (spacing or quoting issue)
- Incorrect JSON serialization order or format

Trace the failure back to the corresponding feature area in the table above, then examine the relevant source in `lib/src/curl.dart`.

Sources: [curl.dart](lib/src/curl.dart)

---

## Continuous Integration

The current CI/CD pipeline ([GitHub Actions Publishing Workflow](15-github-actions-publishing-workflow)) is configured for automated publishing on tagged releases. It runs `dart pub get` but does **not** execute `dart test` as a CI gate. This means tests are currently a **local-only verification step** — it is the contributor's responsibility to run them before pushing.

If you are setting up a fork or contributing to the project, consider running `dart test` as part of your pre-commit checklist.

Sources: [publish.yml](.github/workflows/publish.yml#L14-L18)

---

## Quick Reference

| Command | Purpose |
|---------|---------|
| `dart test` | Run all 15 tests |
| `dart test --name "substring"` | Run tests matching a name substring |
| `dart test --reporter expanded` | Show detailed per-test output |

---

## Next Steps

Now that you understand how to run and interpret the test suite, you may want to explore the specific behaviors each test validates in detail. For a line-by-line analysis of test coverage, continue to [Test Coverage Walkthrough](14-test-coverage-walkthrough). To understand the internal logic that these tests exercise, refer to [Curl Generation Pipeline Internals](7-curl-generation-pipeline-internals).