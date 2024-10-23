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
  klump_checkout: ^1.0.18
```

### Usage

## Flow Summary

1. Collect Klump `checkout data`. 
	
2. Initialize the `KlumpCheckout` by creating an object of the KlumpCheckout class.

3. Call the `pay` method with the isLive, context and data named paramaters to render the Klump checkout view.
	
4. Once request is successful, `KlumpCheckoutResponse` object is return.


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
To use [klump_checkout] SDK, you need to first initialize it by using the `KlumpCheckout` class.
	
```dart

    final klumpCheckout = KlumpCheckout();

```

### 3. Perform ckeckout with klump_checkout  UI
Payment transaction can be made with the `pay` method: 
## Parameters

- `isLive` boolean - pass true for live envireoment and false for test environment
- `context` BuildContext.
- `data` the `KlumpCheckoutData` . 

	
```dart

final res = await klumpCheckout.pay(
      isLive: false,
      context: context,
      data: const KlumpCheckoutData(
        merchantPublicKey:
                    'klp_pk_test_e4aaa1a8e96644ad9af23fa453ddd6ffa39a8233a88c4b93860f119c8cd9a332',
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
       shippingData: {
          "address": "Ediam road Akppa",
          "landmark": "extras",
          "city_id": "da513ab9-a28e-4451-af6b-16f029be2c37"
        },
    ),
  );
```

