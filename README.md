# Klump Checkout Flutter Plugin


![test image size]<img src="https://user-images.githubusercontent.com/34801232/180447659-e002e64c-a9f8-4a0e-819a-bfdb1773309e.png" width="200" height="200">
![Simulator Screen Shot - iPhone 11 Pro - 2022-07-22 at 11 40 31](https://user-images.githubusercontent.com/34801232/180447659-e002e64c-a9f8-4a0e-819a-bfdb1773309e.png) ![Simulator Screen Shot - iPhone 11 Pro - 2022-07-22 at 11 40 40](https://user-images.githubusercontent.com/34801232/180447623-b03b6aaf-ce37-486b-ad6a-aecd4a7d7de9.png | width="300px")
![Simulator Screen Shot - iPhone 11 Pro - 2022-07-22 at 11 40 49](https://user-images.githubusercontent.com/34801232/180447702-fd6f4083-546b-4304-961a-02edf03893e6.png)
![Simulator Screen Shot - iPhone 11 Pro - 2022-07-22 at 11 41 40](https://user-images.githubusercontent.com/34801232/180447738-43a6517b-3c06-4436-a5e3-e735a5c16b39.png)
![Simulator Screen Shot - iPhone 11 Pro - 2022-07-22 at 11 43 00](https://user-images.githubusercontent.com/34801232/180447750-88307cac-eff9-45e8-8e0a-4a34660ec11a.png)

Flutter SDK for implementing the Klump Checkout - Klump is a modern, simple to use platform that allows the user to collect payments from customers in instalments using a payment card (debit or credit) or a bank account.

## Before getting started
- Checkout our [get started guide](https://docs.useklump.com/docs/intro-to-klump) to create your mechant account and retrieve your API Keys.
- Create a [Merchant account](https://useklump.com/), so you can get connecting immediately. 

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

1. Collect Klump checkout data. 
	
2. Initialize the `KlumpPlugin` by creating an object of the klumpPlugin class with a named parameters passed to the constructor.
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
	To use [klump_checkout] SDK, you need to first initialize it by using the `KlumpPlugin` class.
	
```dart

   KlumpPlugin klumpPlugin = KlumpPlugin(
      publicKey: 'klp_pk_test_...');

```

### 3. Perform ckeckout with klump_checkout Web UI
Payment transaction can be made with the `checkout` method: 
## Parameters
- `context` BuildContext.
- `data` The `KlumpCheckoputData` . 

	
```dart

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
