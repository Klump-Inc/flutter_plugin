import 'package:klump_checkout/klump_checkout.dart';

String genereteWebPage(String publicKey, KlumpCheckoutData data) {
//   var webpage = '''
// <!DOCTYPE html>
// <html>
// <script src="https://staging-js.useklump.com/klump.js" defer></script>
// <body>
// <div style ="width: 500px; margin: 100px auto;">
//   <div id="klump__checkout"></div>
//   <div id="klump__ad">
//       <input type="number" value="45000" id="klump__price">
//       <input type="text" value="klp_pk_test_e4aaa1a8e96644ad9af23fa453ddd6ffa39a8233a88c4b93860f119c8cd9a332" id="klump__merchant__public__key">
//       <input type="text" value="NGN" id="klump__currency">
//   </div>
// </div>
// <script>
//     CloseLoader.postMessage(true);
//     const payload = {
//         publicKey: 'klp_pk_test_e4aaa1a8e96644ad9af23fa453ddd6ffa39a8233a88c4b93860f119c8cd9a332',
//         data: {
//             amount: 45000,
//             shipping_fee: 5000,
//             currency: 'NGN',
//             merchant_reference: 'what-ever-you-want-this-to-be',
//             meta_data: {
//               customer: 'Elon Musk',
//               email: 'musk@spacex.com'
//             },
//             source: 'mobile',
//             items: [
//                 {
//                     image_url:
//                         'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
//                     item_url: 'https://www.paypal.com/in/webapps/mpp/home',
//                     name: 'Awesome item',
//                     unit_price: '20000',
//                     quantity: 2,
//                 }
//             ]
//         },
//         onSuccess: (data) => {
//             console.log('html onSuccess will be handled by the merchant');
//             console.log(data);
//          Print.postMessage(JSON.stringify(data.data));
//         },
//         onError: (data) => {
//             console.log('html onError will be handled by the merchant');
//             console.log(data);
//            Print.postMessage(JSON.stringify(data));
//         },
//         onLoad: (data) => {
//             console.log('html onLoad will be handled by the merchant');
//             console.log(data);
//           Print.postMessage(JSON.stringify(data));
//         },
//         onOpen: (data) => {
//             console.log('html OnOpen will be handled by the merchant');
//             console.log(data);
//          Print.postMessage(JSON.stringify(data));
//         },
//         onClose: (data) => {
//             console.log('html onClose will be handled by the merchant');
//             console.log(data);
//           Print.postMessage(JSON.stringify(data));
//         }
//     }
//     document.getElementById('klump__checkout').addEventListener('click', function () {
//         const klump = new Klump(payload);
//     });
// </script>
// </body>

// </html>
// ''';
  var webpage = '''
<!DOCTYPE html>
<html>
<script src="https://staging-js.useklump.com/klump.js" defer></script>
<body>
<div style ="width: 500px; margin: 100px auto;">
  <div id="klump__checkout"></div>
  <div id="klump__ad">
      <input type="number" value="45000" id="klump__price">
      <input type="text" value="$publicKey" id="klump__merchant__public__key">
      <input type="text" value="${data.currency ?? 'NGN'}" id="klump__currency">
  </div>
</div>
<script>
    CloseLoader.postMessage(true);
    const payload = {
        publicKey: '$publicKey',
        data: ${data.toMap()},
        onSuccess: (data) => {
            console.log('html onSuccess will be handled by the merchant');
            console.log(data);
         Print.postMessage(JSON.stringify(data.data));
        },
        onError: (data) => {
            console.log('html onError will be handled by the merchant');
            console.log(data);
           Print.postMessage(JSON.stringify(data));
        },
        onLoad: (data) => {
            console.log('html onLoad will be handled by the merchant');
            console.log(data);
          Print.postMessage(JSON.stringify(data));
        },
        onOpen: (data) => {
            console.log('html OnOpen will be handled by the merchant');
            console.log(data);
         Print.postMessage(JSON.stringify(data));
        },
        onClose: (data) => {
            console.log('html onClose will be handled by the merchant');
            console.log(data);
          Print.postMessage(JSON.stringify(data));
        }
    }
    document.getElementById('klump__checkout').addEventListener('click', function () {
        const klump = new Klump(payload);
    });
</script>
</body>

</html>
''';
  return webpage;
}
