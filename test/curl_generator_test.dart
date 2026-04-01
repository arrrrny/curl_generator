import 'package:curl_generator/curl_generator.dart';
import 'package:test/test.dart';

void main() {
  test('test method if it is not null', () {
    const url = 'https://some.api.com/some/api';
    const expectedReturn =
        'curl --request POST \'https://some.api.com/some/api\' \\\n'
        '  --compressed \\';
    final result = Curl.curlOf(url: url, method: 'POST');
    expect(expectedReturn, result);
  });

  test('test ignore get method', () {
    const url = 'https://some.api.com/some/api';
    const expectedReturn = 'curl \'https://some.api.com/some/api\' \\\n'
        '  --compressed \\';
    final result = Curl.curlOf(url: url, method: 'GET');
    expect(expectedReturn, result);
  });
  test('test GET method with no query params and headers', () {
    const url = 'https://some.api.com/some/api';
    const expectedReturn = 'curl \'https://some.api.com/some/api\' \\\n'
        '  --compressed \\';
    final result = Curl.curlOf(url: url);
    expect(expectedReturn, result);
  });

  test('test GET method with query params in url and no headers', () {
    const url = 'https://some.api.com/some/api?some=some&param=param';
    const expectedReturn =
        'curl \'https://some.api.com/some/api?some=some&param=param\' \\\n'
        '  --compressed \\';
    final result = Curl.curlOf(url: url);
    expect(expectedReturn, result);
  });

  test('test GET method with query params seperated and no headers', () {
    const url = 'https://some.api.com/some/api';
    const expectedReturn =
        'curl \'https://some.api.com/some/api?some=some&param=param\' \\\n'
        '  --compressed \\';
    const params = {
      'some': 'some',
      'param': 'param',
    };
    final result = Curl.curlOf(url: url, queryParams: params);
    expect(expectedReturn, result);
  });

  test('test GET method with headers and no query params', () {
    const url = 'https://some.api.com/some/api';
    const header = {
      'Accept': 'application/json',
      'Accept-Language': 'en-US,en;q=0.9',
      'Connection': 'keep-alive',
    };
    const expectedReturn = 'curl \'https://some.api.com/some/api\' \\\n'
        '  -H \'Accept: application/json\' \\\n'
        '  -H \'Accept-Language: en-US,en;q=0.9\' \\\n'
        '  -H \'Connection: keep-alive\' \\\n'
        '  --compressed \\';
    final result = Curl.curlOf(url: url, headers: header);
    expect(expectedReturn, result);
  });

  test('test GET method with headers and query params', () {
    const url = 'https://some.api.com/some/api';
    const params = {
      'some': 'some',
      'param': 'param',
    };
    const header = {
      'Accept': 'application/json',
      'Accept-Language': 'en-US,en;q=0.9',
      'Connection': 'keep-alive',
    };
    const expectedReturn =
        'curl \'https://some.api.com/some/api?some=some&param=param\' \\\n'
        '  -H \'Accept: application/json\' \\\n'
        '  -H \'Accept-Language: en-US,en;q=0.9\' \\\n'
        '  -H \'Connection: keep-alive\' \\\n'
        '  --compressed \\';
    final result = Curl.curlOf(url: url, headers: header, queryParams: params);
    expect(expectedReturn, result);
  });

  test('test POST method with has only body', () {
    const url = 'https://some.api.com/some/api';
    const body = {
      'some': 'some',
      'value': 'value',
      'intValue': 1234,
    };
    const expectedReturn = 'curl \'https://some.api.com/some/api\' \\\n'
        '  -H \'Content-Type: application/json\' \\\n'
        '  --data-raw \'{"some":"some","value":"value","intValue":1234}\' \\\n'
        '  --compressed \\';
    final result = Curl.curlOf(url: url, body: body);
    expect(expectedReturn, result);
  });

  test('test POST method with all headers and query params and body', () {
    const url = 'https://some.aoi.com/some/api';
    const params = {
      'some': 'some',
      'param': 'param',
    };
    const header = {
      'Accept': 'application/json',
      'Accept-Language': 'en-US,en;q=0.9',
      'Connection': 'keep-alive',
    };
    const body = {
      'some': 'some',
      'value': 'value',
      'intValue': 1234,
    };
    const expectedReturn =
        'curl \'https://some.aoi.com/some/api?some=some&param=param\' \\\n'
        '  -H \'Accept: application/json\' \\\n'
        '  -H \'Accept-Language: en-US,en;q=0.9\' \\\n'
        '  -H \'Connection: keep-alive\' \\\n'
        '  -H \'Content-Type: application/json\' \\\n'
        '  --data-raw \'{"some":"some","value":"value","intValue":1234}\' \\\n'
        '  --compressed \\';
    final result = Curl.curlOf(
      url: url,
      headers: header,
      queryParams: params,
      body: body,
    );
    expect(expectedReturn, result);
  });

  test('test http call', () {
    const url = 'http://some.api.com/some/api';
    const expectedReturn = 'curl \'http://some.api.com/some/api\' \\\n'
        '  --compressed \\\n'
        '  --insecure';
    final result = Curl.curlOf(url: url);
    expect(expectedReturn, result);
  });

  test('test if content-type will aded to post calls', () {
    const url = 'http://some.api.com/some/api';
    const expectedReturn = 'curl \'http://some.api.com/some/api\' \\\n'
        '  -H \'Content-Type: application/json\' \\\n'
        '  --data-raw \'{"some":"value"}\' \\\n'
        '  --compressed \\\n'
        '  --insecure';
    final result = Curl.curlOf(url: url, body: {'some': 'value'});
    expect(expectedReturn, result);
  });

  test('test if content-type will not aded to calls that have no body', () {
    const url = 'http://some.api.com/some/api';
    const expectedReturn = 'curl \'http://some.api.com/some/api\' \\\n'
        '  --compressed \\\n'
        '  --insecure';
    final result = Curl.curlOf(url: url);
    expect(expectedReturn, result);
  });

  test(
      'test if content-type will not aded to calls that have body but has content type in its header',
      () {
    const url = 'http://some.api.com/some/api';
    const expectedReturn = 'curl \'http://some.api.com/some/api\' \\\n'
        '  -H \'Content-Type: application/json\' \\\n'
        '  --data-raw \'{"some":"value"}\' \\\n'
        '  --compressed \\\n'
        '  --insecure';
    final result = Curl.curlOf(
      url: url,
      headers: {'Content-Type': 'application/json'},
      body: {'some': 'value'},
    );
    expect(expectedReturn, result);
  });

  test(
      'test if content-type will not aded to calls that have body but has content type (lower case) in its header',
      () {
    const url = 'http://some.api.com/some/api';
    const expectedReturn = 'curl \'http://some.api.com/some/api\' \\\n'
        '  -H \'content-Type: application/json\' \\\n'
        '  --data-raw \'{"some":"value"}\' \\\n'
        '  --compressed \\\n'
        '  --insecure';
    final result = Curl.curlOf(
      url: url,
      headers: {'content-Type': 'application/json'},
      body: {'some': 'value'},
    );
    expect(expectedReturn, result);
  });

  test('test if body contains an object that cannot directly convert to json',
      () {
    const url = 'http://some.api.com/some/api';
    const expectedReturn = 'curl \'http://some.api.com/some/api\' \\\n'
        '  -H \'content-Type: application/json\' \\\n'
        '  --data-raw \'{"some":"value","test":"Curl"}\' \\\n'
        '  --compressed \\\n'
        '  --insecure';
    final result = Curl.curlOf(
      url: url,
      headers: {'content-Type': 'application/json'},
      body: {
        'some': 'value',
        'test': Curl,
      },
    );
    expect(expectedReturn, result);
  });
}
