part of '../curl_generator.dart';

/// The [Curl] entry point.
///
/// To get a curl, call [Curl.curlOf]
class Curl {
  /// private constructor
  ///
  Curl._();

  /// final generated curl.
  ///
  static String _curl = '';

  /// Generate curl base on provided data.
  ///
  /// [queryParams], [headers] and [body] are optional.
  ///
  /// to add query parameters use [queryParams] or add it manually to the end
  /// of [url] with `?`
  ///
  /// [body] can be a String (JSON string or raw data), Map, or any object that
  /// can be JSON encoded. If a String is provided, it will be used as-is.
  /// If a Map or other object is provided, it will be JSON encoded.
  ///
  /// ```dart
  ///  final example1 = Curl.curlOf(url: 'https://some.api.com/some/path?some=some&query=query');
  ///// or
  ///  final example2 = Curl.curlOf(
  ///    url: 'https://some.api.com/some/path',
  ///    queryParams: {
  ///      'some': 'some',
  ///      'query': 'query',
  ///    },
  ///  );
  ///
  /// print(example1);
  /// print(example2);
  ///// curl 'https://some.api.com/some/path?some=some&query=query' --compressed
  ///
  ///// curl 'https://some.api.com/some/path?some=some&query=query' --compressed
  /// ```
  static String curlOf({
    required String url,
    String? method,
    Map<String, String> queryParams = const {},
    Map<String, String> headers = const {},
    Object? body,
  }) {
    _curl = '';
    final isSecure = url.startsWith('https');
    _addMethod(method);
    _addUrl(url);
    _addQueryParams(queryParams);
    _curl = '$_curl\' \\\n';
    _addHeaders(headers);
    if (body != null) _addBody(body);
    
    // Add --compressed (with backslash only if not secure to add --insecure)
    if (!isSecure) {
      _curl = '$_curl  --compressed \\\n';
      _curl = '$_curl  --insecure';
    } else {
      _curl = '$_curl  --compressed';
    }
    return _curl;
  }

  /// initialize [_curl] with [method] if it is not null.
  static void _addMethod(String? method) {
    if (method == null) return;
    if (method.toUpperCase() == 'GET') return;
    _curl = 'curl --request ${method.toUpperCase()}';
  }

  /// initialize [_curl] with [url] if [_curl] is empty
  /// else add url to existing [_curl].
  static void _addUrl(String url) {
    if (_curl.isEmpty) {
      _curl = 'curl \'$url';
      return;
    }
    _curl = '$_curl \'$url';
  }

  /// add [queryParams] to [_curl]
  static void _addQueryParams(Map<String, String> queryParams) {
    if (queryParams.isEmpty) return;
    final params =
        queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
    _curl = '$_curl?$params';
  }

  /// add [headers] to [_curl] if exists.
  static void _addHeaders(Map<String, String> headers) {
    final headerEntries = headers.entries.toList();
    for (int i = 0; i < headerEntries.length; i++) {
      _curl = '$_curl  -H \'${headerEntries[i].key}: ${headerEntries[i].value}\' \\\n';
    }
  }

  /// add [body] to [_curl] if exists.
  ///
  /// Handles multiple body types:
  /// - String: Used as-is (can be JSON string, form data, or any raw string)
  /// - Map or other objects: JSON encoded
  /// - Empty string: Ignored
  static void _addBody(Object body) {
    String bodyData;

    if (body is String) {
      // If body is an empty string, don't add it
      if (body.trim().isEmpty) {
        return;
      }
      // If body is already a string, use it as-is
      bodyData = body;
    } else if (body is Map && body.isEmpty) {
      // Empty map, no body to add
      return;
    } else {
      // Encode any other type to JSON
      bodyData = json.encode(
        body,
        toEncodable: (object) => object.toString(),
      );
    }

    // Only add Content-Type header if not already present and body looks like JSON
    if (!_curl.toLowerCase().contains('content-type')) {
      // Check if body looks like JSON (starts with { or [)
      final trimmedBody = bodyData.trim();
      if (trimmedBody.startsWith('{') || trimmedBody.startsWith('[')) {
        _curl = '$_curl  -H \'Content-Type: application/json\' \\\n';
      }
    }

    _curl = '$_curl  --data-raw \'$bodyData\' \\\n';
  }
}
