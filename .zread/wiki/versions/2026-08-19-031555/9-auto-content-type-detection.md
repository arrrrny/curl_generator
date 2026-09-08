The `curl_generator` library implements an intelligent auto-detection mechanism for the `Content-Type` header when generating curl commands with request bodies. This feature automatically adds the appropriate `Content-Type: application/json` header based on the type and content of the body, reducing manual configuration while maintaining flexibility for explicit header overrides.

## Detection Mechanism Overview

The auto-detection logic resides within the `_addBody` method of the `Curl` class, which evaluates both the Dart type and the string representation of the body content to determine whether to automatically add a `Content-Type` header.

```mermaid
flowchart TD
    A[Body provided to _addBody] --> B{Body type?}
    B -->|String| C{Is empty?}
    C -->|Yes| D[Skip body]
    C -->|No| E{Already has Content-Type header?}
    B -->|Map or Object| F[JSON encode body]
    
    E -->|Yes| G[Skip Content-Type addition]
    E -->|No| H{String looks like JSON?}
    H -->|Starts with \{ or \[| I[Add application/json]
    H -->|Other format| J[Skip Content-Type]
    
    F --> E
    
    I --> K[Append --data-raw with body]
    J --> K
    G --> K
```

Sources: [lib/src/curl.dart#L101-L143](lib/src/curl.dart#L101-L143)

## Detection Rules and Decision Matrix

The detection system applies different rules based on body type and content analysis. The following table summarizes the decision logic:

| Body Type | Body Condition | Header Already Present? | Action Taken | Content-Type Added? |
|-----------|----------------|------------------------|--------------|---------------------|
| `String` | Empty string | Any | Skip body entirely | No |
| `String` | Non-empty, looks like JSON (`{` or `[` prefix) | No | Add `application/json` | Yes |
| `String` | Non-empty, looks like JSON | Yes (case-insensitive) | Skip header addition | No |
| `String` | Non-empty, non-JSON format | No | Skip header addition | No |
| `String` | Non-empty, non-JSON format | Yes | Skip header addition | No |
| `Map` (empty) | Empty map | Any | Skip body entirely | No |
| `Map` (non-empty) | Any | No | Add `application/json` | Yes |
| `Map` (non-empty) | Any | Yes (case-insensitive) | Skip header addition | No |
| `Object` | Any non-Map, non-String | No | Add `application/json` | Yes |
| `Object` | Any non-Map, non-String | Yes (case-insensitive) | Skip header addition | No |

Sources: [lib/src/curl.dart#L101-L143](lib/src/curl.dart#L101-L143)

## Header Override Detection

The library uses a case-insensitive check to detect whether a `Content-Type` header has already been provided in the headers map. This prevents duplicate headers while allowing the user to specify custom content types.

```dart
// Case-insensitive check in _addBody method
if (!_curl.toLowerCase().contains('content-type')) {
    // Add automatic Content-Type header
}
```

This approach means that both `Content-Type` and `content-type` (or any case variation) will be recognized as present, preventing the library from adding a duplicate automatic header.

Sources: [lib/src/curl.dart#L128-L135](lib/src/curl.dart#L128-L135)

## Practical Examples and Behavior

The auto-detection produces different outputs based on input types. The following examples demonstrate the behavior:

| Input Body | Body Type | Auto-Generated Header | Generated Curl Segment |
|------------|-----------|----------------------|------------------------|
| `{'key': 'value'}` | `Map<String, String>` | `Content-Type: application/json` | `-H 'Content-Type: application/json' \` |
| `'{"key": "value"}'` | `String` (JSON-like) | `Content-Type: application/json` | `-H 'Content-Type: application/json' \` |
| `'key=value'` | `String` (form data) | None | (no Content-Type added) |
| Custom object | `Object` | `Content-Type: application/json` | `-H 'Content-Type: application/json' \` |
| Empty `String` or `Map` | N/A | None | (body omitted entirely) |

Sources: [test/curl_generator_test.dart#L134-L160](test/curl_generator_test.dart#L134-L160)

## Comparison: Auto vs Manual Content-Type Configuration

Understanding when to use auto-detection versus explicit headers helps developers choose the appropriate approach:

| Scenario | Auto-Detection Approach | Manual Header Approach | Recommended For |
|----------|------------------------|------------------------|-----------------|
| Standard JSON API calls | Pass `Map` body, let library add header | Explicit `Content-Type: application/json` | Auto-detection |
| Form data submission | Pass `String` body, no header added | Explicit `Content-Type: application/x-www-form-urlencoded` | Manual header |
| Custom content types | Pass `String` body, no header added | Explicit `Content-Type: text/plain` | Manual header |
| Mixed header requirements | Pass body + headers map with `Content-Type` | Library respects existing header | Manual header |
| Rapid prototyping | Auto-detection reduces boilerplate | More verbose but explicit | Auto-detection |

Sources: [lib/src/curl.dart#L128-L135](lib/src/curl.dart#L128-L135), [test/curl_generator_test.dart#L134-L160](test/curl_generator_test.dart#L134-L160)

## JSON Encoding Strategy

When non-String bodies are provided, the library applies JSON encoding with a custom `toEncodable` handler that falls back to `toString()` for objects that cannot be directly JSON-encoded. This ensures that any object type can be included in the body while maintaining JSON structure.

```dart
// JSON encoding with custom fallback
bodyData = json.encode(
  body,
  toEncodable: (object) => object.toString(),
);
```

The auto-detection logic then recognizes these JSON-encoded strings by checking for `{` or `[` prefixes, ensuring the appropriate `Content-Type` header is added.

Sources: [lib/src/curl.dart#L119-L123](lib/src/curl.dart#L119-L123)

## Edge Cases and Limitations

The auto-detection system handles several edge cases but has some limitations to consider:

| Edge Case | Behavior | Limitation |
|-----------|----------|------------|
| Nested JSON objects | Properly encoded and detected | None |
| Non-JSON string bodies (e.g., XML, plain text) | No Content-Type added | Requires manual header |
| Mixed case `content-type` headers | Recognized as present | None |
| Empty body strings | Body omitted entirely | None |
| Empty Maps | Body omitted entirely | None |
| Custom classes with `toString()` | JSON encoded with `toString()` fallback | May produce non-JSON strings |

The primary limitation is that string bodies that aren't JSON-formatted won't receive automatic content-type detection, requiring manual header configuration for non-JSON content types.

Sources: [lib/src/curl.dart#L101-L143](lib/src/curl.dart#L101-L143)

## Next Steps

For a complete understanding of the `curl_generator` library, consider exploring these related topics:

- **[Including Request Body](8-including-request-body)**: Learn more about different body types and how they're handled
- **[Adding Headers](7-adding-headers)**: Understand how to manually configure headers including custom `Content-Type` values
- **[HTTPS vs HTTP Handling](10-https-vs-http-handling)**: See how protocol affects curl command generation
- **[The Curl.curlOf Method](4-the-curl-curlof-method)**: Explore the complete API of the main generation method