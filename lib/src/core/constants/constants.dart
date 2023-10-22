// ignore_for_file: constant_identifier_names

export 'kc_assets.dart';
export 'kc_fonts.dart';

const String KC_PACKAGE_NAME = 'klump_checkout';
const String NGN = 'NGN';
const String PUBLIC_KEY = 'publicKey';

const String KC_BASE_URL = 'https://api.useklump.com';
const String KC_STAGING_BASE_URL = 'https://staging-api.useklump.com';
const int KC_CONNECT_TIMEOUT = 30;
const int KC_RECEIVE_TIMEOUT = 60;
const String KC_CLIENT_ID = 'Client-Id';
const String KC_CLIENT_KEY = 'Client-Key';
const String KC_CLIENT_SECRET = 'Client-Secret';
const String KC_CONTENT_TYPE_DEFAULT = 'application/json';
const String KC_CLIENT_ID_VALUE_STAGING = 'website';
const String KC_CLIENT_KEY_VALUE_STAGING = 'website';
const String KC_CLIENT_SECRET_VALUE_STAGING = 'VMws+/Q&=gVV+R7M';
const String KC_CLIENT_ID_VALUE_PROD = 'checkout_ebbb8d1b6';
const String KC_CLIENT_KEY_VALUE_PROD = 'checkout_gndhrhb8d1b6';
const String KC_CLIENT_SECRET_VALUE_PROD =
    'Mb3=647xsM121kLKaAyxe90c4a177d5b7c0';
const String KC_ENVIRONMENT_KEY = 'kc_environment_key';
const String KC_PRODUCTION_ENVIRONMENT = 'kc_production_env';
const String KC_STAGING_ENVIRONMENT = 'kc_staging_env';
const String KC_CKECKOUT_TOKEN = 'kc_checkout_token';
const String KC_LOGIN_TOKEN = 'kc_login_token';

const int kC_OTP_RESEND_WAIT_TIME_IN_SECONDS = 60;
const String KC_HTML_HEADER = '''
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta http-equiv="X-UA-Compatible" content="IE=edge">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
          body {
              margin: 0;
              color: #171717;
              text-align:left;
          }
          h3{
              font-size: 16px;
              line-height:24px;
              color: #171717;
              font-weight: 900;
              text-align:left;
          }
          div, p, li {
              margin: 0 !important;
              font-size: 14px;
              line-height:20px;
              color: #171717;
              text-align:left;
          }
          </style>
      </head>
      <body>
      ''';

const String KC_HTML_FOOTER = '''
      </body>
      </html>
      ''';

const KC_MIX_PANEL_TOKEN_PROD = '49e554d50d53d1053cfd68f87521073e';
const KC_MIX_PANEL_TOKEN_STAGING = 'e1b9e5dd4ac6691cb595772d402c7b1e';
