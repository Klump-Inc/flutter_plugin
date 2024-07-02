import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixPanelService {
  static Mixpanel? mixpanel;

  static Future<void> initMixpanel(String token) async {
    mixpanel = await Mixpanel.init(token, trackAutomaticEvents: true);
  }

  static Future<void> logEvent(String event,
      {Map<String, dynamic>? properties}) async {
    final Map<String, dynamic> allProperties = {'source': 'mobile'};
    if (properties != null) {
      allProperties.addAll(properties);
    }
    if (mixpanel != null) {
      mixpanel!.track(event, properties: allProperties);
    }
  }
}
