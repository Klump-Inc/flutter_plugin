import 'package:klump_checkout/klump_checkout.dart';

String genereteWebPage(String publicKey, KlumpCheckoutData data) {
  var webpage = '''
<!DOCTYPE html>
<html>
<script src="https://klump-js.netlify.app/klump.js?mobile=true" defer></script>
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
    FlutterCloseLoader.postMessage(true);
    const payload = {
        publicKey: '$publicKey',
        data: ${data.toMap()},
        onSuccess: (data) => {
            console.log('html onSuccess will be handled by the merchant');
            console.log(data);
         FlutterOnSuccess.postMessage(JSON.stringify(data));
        },
        onError: (data) => {
            console.log('html onError will be handled by the merchant');
            console.log(data);
           FlutterOnError.postMessage(JSON.stringify(data));
        },
        onLoad: (data) => {
            console.log('html onLoad will be handled by the merchant');
            console.log(data);
          FlutterOnSuccess.postMessage(JSON.stringify(data));
        },
        onOpen: (data) => {
            console.log('html OnOpen will be handled by the merchant');
            console.log(data);
         FlutterOnOpen.postMessage(JSON.stringify(data));
        },
        onClose: (data) => {
            console.log('html onClose will be handled by the merchant');
            console.log(data);
          FlutterOnClose.postMessage(JSON.stringify(data));
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
