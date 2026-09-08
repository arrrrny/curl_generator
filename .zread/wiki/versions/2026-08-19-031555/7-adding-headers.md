HTTP headers carry metadata about a request — authentication tokens, content types, language preferences, and more. The `curl_generator` library provides a straightforward mechanism for attaching headers to your generated curl commands via the `headers` parameter of `Curl.curlOf`. This page explains how to use it, how it interacts with other features like automatic Content-Type detection, and how the output is structured.

## The Headers Parameter

The `headers` parameter accepts a `Map<String, String>` where each key-value pair represents a header name and its corresponding value. The parameter is optional and defaults to an empty map, meaning you can omit it entirely when no headers are needed.

```dart
final curl = Curl.curlOf(
  url: 'https://api.example.com/data',
  headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer abc123',
    'X-Custom-Header': 'some-value',
  },
);

// Output:
// curl 'https://api.example.com/data' \
//   -H 'Accept: application/json' \
//   -H 'Authorization: Bearer abc123' \
//   -H 'X-Custom-Header: some-value' \
//   --compressed \
```

Each header entry is rendered as a separate `-H` flag in the generated curl command, following standard curl syntax. Headers are emitted in the order they appear in the map's entry list, which in Dart preserves insertion order for `LinkedHashMap` (the default `Map` implementation). The parameter definition can be found at [curl.dart](lib/src/curl.dart#L45-L46).

Sources: [curl.dart](lib/src/curl.dart#L45-L46)

## How Headers Are Rendered

The internal `_addHeaders` method iterates over each entry in the map and appends a formatted `-H` flag to the curl string. Each line includes a backslash-newline continuation (`\\\n`), ensuring the generated curl command is multi-line and shell-executable.

```dart
static void _addHeaders(Map<String, String> headers) {
  final headerEntries = headers.entries.toList();
  for (int i = 0; i < headerEntries.length; i++) {
    _curl = '$_curl  -H \'${headerEntries[i].key}: ${headerEntries[i].value}\' \\\n';
  }
}
```

The rendering follows these rules:

| Aspect | Behavior |
|---|---|
| **Header format** | `-H 'Key: Value'` — single-quoted, with colon-space separator |
| **Indentation** | Two-space indent before each `-H` flag |
| **Line continuation** | Each header line ends with `\\\n` for multi-line shell output |
| **Order** | Headers appear in map insertion order |
| **Empty map** | Produces no header lines at all |

Sources: [curl.dart](lib/src/curl.dart#L92-L97)

## Header and Body Interaction: Auto Content-Type

One of the more nuanced behaviors of the library is its **automatic Content-Type detection**. When you provide a `body` parameter without explicitly setting a `Content-Type` header, the library inspects the body and conditionally adds `Content-Type: application/json` for you.

The logic in `_addBody` performs the following checks:

1. If **any** header already contains the string `content-type` (case-insensitive), the auto-detection is skipped entirely.
2. If the body is a **Map or object** (not a String), `Content-Type: application/json` is always added.
3. If the body is a **String**, it is only added if the string looks like JSON (starts with `{` or `[`).
4. If the body is **absent** (`null`), no Content-Type header is added.

```dart
// Body is a Map → auto-adds Content-Type
final curl1 = Curl.curlOf(
  url: 'https://api.example.com/data',
  body: {'key': 'value'},
);
// Generated: -H 'Content-Type: application/json' is included

// Body is a JSON-like String → auto-adds Content-Type
final curl2 = Curl.curlOf(
  url: 'https://api.example.com/data',
  body: '{"key": "value"}',
);
// Generated: -H 'Content-Type: application/json' is included

// Body is a plain String → NO auto Content-Type
final curl3 = Curl.curlOf(
  url: 'https://api.example.com/data',
  body: 'plain text data',
);
// Generated: no Content-Type header

// You provide Content-Type yourself → auto-detection is skipped
final curl4 = Curl.curlOf(
  url: 'https://api.example.com/data',
  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  body: {'key': 'value'},
);
// Generated: uses your Content-Type, no auto-addition
```

This means you have full control: when you need a non-JSON content type (like `multipart/form-data` or `text/plain`), simply include it in your `headers` map and the library will respect it. The case-insensitive check ensures that variations like `content-type`, `Content-Type`, or `CONTENT-TYPE` are all recognized.

Sources: [curl.dart](lib/src/curl.dart#L119-L133)

## Complete Example

Here is a full example demonstrating headers combined with query parameters and a request body:

```dart
final curl = Curl.curlOf(
  url: 'https://api.example.com/v1/users',
  method: 'POST',
  queryParams: {'format': 'json'},
  headers: {
    'Accept': 'application/json',
    'Accept-Language': 'en-US,en;q=0.9',
    'Authorization': 'Bearer token123',
  },
  body: {
    'name': 'Alice',
    'email': 'alice@example.com',
  },
);
```

The generated curl command:

```
curl --request POST 'https://api.example.com/v1/users?format=json' \
  -H 'Accept: application/json' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Authorization: Bearer token123' \
  -H 'Content-Type: application/json' \
  --data-raw '{"name":"Alice","email":"alice@example.com"}' \
  --compressed \
```

Notice how your explicit headers appear first (in insertion order), followed by the auto-generated `Content-Type: application/json`. This ordering is a direct result of the execution flow: headers are rendered before the body processing adds its own Content-Type.

Sources: [curl.dart](lib/src/curl.dart#L55-L80)

## Tips for Intermediate Developers

**Ordering matters for auto-detection.** If you set a custom `Content-Type` in the `headers` map, it will be emitted *before* the body is processed. Since the library checks for existing Content-Type strings at body processing time, your custom value will prevent duplication — but only if the exact string `content-type` (case-insensitive) appears in your curl string by that point.

**Map key casing is preserved.** The library does not normalize header names. If you write `'content-type'` as a key, the generated output will contain exactly that — lowercase `content-type`. This is functionally equivalent for curl but may look unusual compared to the conventional `Content-Type` casing.

**No URL-encoding is applied to header values.** Header values are inserted into the curl command as-is. If your values contain special characters that need escaping for shell usage, you will need to handle that at the call site.

Sources: [curl.dart](lib/src/curl.dart#L92-L97), [curl.dart](lib/src/curl.dart#L119-L133)

## Next Steps

Now that you understand how headers work, you might want to explore how request bodies are handled independently in [Including Request Body](8-including-request-body), or revisit the method parameter behavior covered in [HTTP Method Support](11-http-method-support). For a holistic view of the generation pipeline, see [The Curl.curlOf Method](4-the-curl-curlof-method).