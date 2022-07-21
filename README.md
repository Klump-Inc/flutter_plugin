# Klump Checkout Flutter Plugin


Flutter SDK for implementing the Klump Checkout - Klump is a 

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
  klump_checkout: ^1.0.1
```

### Usage

## Flow Summary

1. Collect user's card details, email and phone number. 
	
2. Initialize the klump_checkoutPlugin by creating an object of the klump_checkoutPlugin class with two named parameters passed to the constructor.
	- The first argument is the public key of the merchant
	- The second argument is the secret key of the merchant.
	- Both public and secret keys are provided by klump_checkout to the merchants.
	-  Prompts backend to initialize transactions by calling the `initialPayment` method.
	- klump_checkout's backend returns a `payment slug` which is returned when `Initiate Payment` endpoint is called
	- App provides the `payment slug` and card details to our SDK's using the `pay` and `verifyCardNumber` methods
	
3. Once request is successful,  `ThirdPartyPaymentResponse` is return.


## Installation
- To start using this package, simply add the following to project `pubspec.yaml`

```
  flutter_klump_checkout: <lastes-version>
```

## Usage

### 1. Permissions
To use this package, your android app must declare internet permission. Add the following code to the application level of your AndroidManifest.xml.

```xml
	<uses-permission android:name="android.permission.INTERNET" />
```

### 2. Initializing Plugin
	To use [klump_checkout] SDK, you need to first initialize it by using the `KlumpPlugin` class.
	
```dart

   KlumpPlugin klumpPlugin = KlumpPlugin(
                publicKey:
                    'klp_pk_test_...');

```

### 4. Perform ckeckout with klump_checkout Web UI
Payment transaction can be made with the `checkout` method: 
## Parameters
- `context` BuildContext.
- `data` The `KlumpCheckoputData` . 

	
```dart
	.
	.
	.
	final res = await klumpPlugin.checkout(
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
  print(res);
  }
```

### Author
- [Jeremiah Agbama](https://www.linkedin.com/in/jeremiah-agbama-168653161/)