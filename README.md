# Klump Checkout Flutter Plugin

Flutter Plugin for implementing the Klump Checkout - Klump is a modern, simple to use platform that allows the user to collect payments from customers in instalments using a payment card (debit or credit) or a bank account.

## Before getting started
- Create a merchant account on [useklump](https://useklump.com/)
- Checkout our [get started guide](https://docs.useklump.com/docs/intro-to-klump) to create your mechant account and retrieve your API Keys.

### Getting Started
This library would help you add Klump Checkout to your hybrid android/ios application in no time. All you need to do is ...

### Install
To use this plugin, add `klump_checkout` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).
```pub
dependencies:
  klump_checkout: ^1.0.1
```

### Usage

## Flow Summary

1. Collect Klump `checkout data`. 
	
2. Initialize the `KlumpWidget` by creating an object of the KlumpWidget class with a named parameters passed to the constructor.
	- The named paramater is the public key of the merchant.
	- Call the `checkout` method with the context and data named paramaters  to render the Klump checkout webview.

3. Once request is successful,  `KlumpCheckoutResponse` is return.


## Installation
- To start using this package, simply add the following to project `pubspec.yaml`

```
  klump_checkout: <lastest-version>
```

## Usage

### 1. Permissions
To use this package, your android app must declare internet permission. Add the following code to the application level of your AndroidManifest.xml.

```xml
	<uses-permission android:name="android.permission.INTERNET" />
```

### 2. Initializing Plugin
	To use [klump_checkout] SDK, you need to first initialize it by using the `KlumpWidget` class.
	
```dart

   KlumpWidget klumpWidget = KlumpWidget(
      publicKey: 'klp_pk_test_...');

```

### 3. Perform ckeckout with klump_checkout Web UI
Payment transaction can be made with the `checkout` method: 
## Parameters
- `context` is the view BuildContext.
- `data` is the `KlumpCheckoputData` . 

	
```dart

final res = await klumpWidget.checkout(
      context: context,
      data: const KlumpCheckoutData(
      amount: 45000,
      shippingFee: 5000,
      merchantReference: "what-ever-you-want-this-to-be",
      metaData: {
        'customer': "Elon Musk",
        'email': "musk@spacex.com",
      },
      items: [
        KlumpCheckoutItem(
          imageUrl:
              'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
          itemUrl: 'https://www.paypal.com/in/webapps/mpp/home',
          name: 'Awesome item',
          unitPrice: 20000,
          quantity: 2,
        )
      ],
    ),
  );
  }
```
