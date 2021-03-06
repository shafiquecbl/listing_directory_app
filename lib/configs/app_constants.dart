import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// TODO: CHANGE YOUR IN-APP DEFAULT IMAGE (OPTIONAL)
const kDefaultImage =
    'https://firebasestorage.googleapis.com/v0/b/thelista-7f00d.appspot.com/o/Transparent.png?alt=media&token=b18adfc0-57ab-443b-bed8-4c00f76e9bff';

/// TODO: CHANGE YOUR IN-APP LOGO (OPTIONAL)
const kLogo =
    'https://firebasestorage.googleapis.com/v0/b/thelista-7f00d.appspot.com/o/Transparent.png?alt=media&token=b18adfc0-57ab-443b-bed8-4c00f76e9bff';

/// TODO: CHANGE YOUR PREFERRED CONFIGURATION (OPTIONAL)
/// All variables must be double
const kGoogleMapConfig = {
  'initLatitude': 1.3848587,
  'initLongitude': 103.7432535,
  'initRadius': 1.0, // must be between maxRadius and minRadius
  'maxRadius': 10.0,
  'minRadius': 0.0,
  'zoom': 13.0,
};

/// TODO: CHANGE DEFAULT THEME FOR FIRST TIME (OPTIONAL)
const kDefaultDarkTheme = true;
const kPaymentMethods = [
  {
    'id': 'paypal',
    'name': 'PayPal',
    'icon': FontAwesomeIcons.ccPaypal,
  },
  {
    'id': 'wire',
    'name': 'Bank Wire',
    'icon': FontAwesomeIcons.creditCard,
  },
  {
    'id': 'stripe',
    'name': 'Stripe',
    'icon': FontAwesomeIcons.stripe,
  },
  {
    'id': 'twocheck',
    'name': '2CheckOut',
    'icon': FontAwesomeIcons.moneyBill,
  }
];
