<!-- ZURAFFA-LAUNCH-PROMO (valid until Dec 1, 2026) -->
## 🦒 [Zuraffa Browser](https://zuraffa.com) — now live

<div align="center">
  <a href="https://zuraffa.com"><img src="https://zuraffa.com/img/zuraffa-browser-home.jpg" alt="Zuraffa Browser — 10 Browsers. One window." width="800"></a>
</div>

**[Zuraffa Browser](https://zuraffa.com)** — the multi-tasking browser for AI agents & humans — is live on the [Mac App Store](https://apps.apple.com/app/id6811352058).

🎁 **Launch offer: 6 months free with code `ZURAFFA`** — no credit card, no subscription, no payment. Redeem in-app until **Dec 1, 2026**.

---

# curl_generator

A Dart package to create simple curl (bash) with params, headers and body.

## Getting started

To use this plugin, add `curl_generator` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

## Usage

#### Example 

```dart
    const url =
        'http://some.api.com/some/api?some=some&params=params';
        // or
    const url =
        'http://some.api.com/some/api';
    const params = {
      'some': 'some',
      'params': 'params',
    };
    
    const header = {
      'Accept': 'application/json',
      'Accept-Language': 'en-US,en;q=0.9',
      'Connection': 'keep-alive',
    };
    
    const body = {
      'some': 'some',
      'value': 'value',
      'intValue': 123,
    };
    
    final result = Curl.curlOf(
      url: url,
      header: header,   //  optional
      queryParams: params,   //  optional
      body: body,   //  optional
    );
    //  output will be
    //  curl 'http://some.api.com/some/api?some=some&params=params' \
    //    -H 'Accept: application/json' \
    //    -H 'Accept-Language: en-US,en;q=0.9' \
    //    -H 'Connection: keep-alive' \
    //    --data-raw '{"some":"some","value":"value","intValue":123}' \
    //    --compressed \
    //    --insecure
```

