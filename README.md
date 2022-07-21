# Klump Checkout Flutter Plugin

This library allows for the easy integration of [Klump Checkout] into your Flutter application. 

Flutter SDK for implementing the Klump Checkout - Okra is a safe and secure web drop-in module and this library provides a front-end web (also available in [iOS](https://github.com/okraHQ/okra-ios-sdk), [Android](https://github.com/okraHQ/okra-android-sdk), and [JavaScript](https://github.com/okraHQ/okra-js)) SDK for [account authentication](https://docs.okra.ng/docs/widget-properties) and [payment initiation](https://docs.okra.ng/docs/creating-a-charge) for each bank that Okra [supports](https://docs.okra.ng/docs/bank-coverage). 

## Try the demo
Checkout the [widget flow](https://okra.ng/) to view how the Klump Checkout works. *Click "See How it Works"*

## Before getting started
- Checkout our [get started guide](https://docs.okra.ng/docs/get-started-with-okra) to create your developer account and retrieve your Client Token, API Keys, and Private Keys.
- Create a [sandbox customer](https://docs.okra.ng/docs/creating-sandbox-customers), so you can get connecting immediately. 

*Bonus Points*
- Setup [Slack Notifications](https://docs.okra.ng/docs/slack-integration) so you can see your API call statuses and re-run calls in real-time!

### Getting Started
This library would help you add Klump Checkout to your hybrid android/ios application in no time. All you need to do is ...

### Install
To use this plugin, add `klump_checkout` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).
```pub
dependencies:
  klump_checkout: ^2.0.3-beta
```

On iOS, opt-in to the embedded views preview by adding a boolean property to the app's Info.plist file with the key     `io.flutter.embedded_views_preview` and the value `true`.

```plist
<dict>  
  <key>io.flutter.embedded_views_preview</key>
  <true/>  
</dict>
```

### Usage

### Author
- [Jeremiah Agbama](https://www.linkedin.com/in/jeremiah-agbama-168653161/)