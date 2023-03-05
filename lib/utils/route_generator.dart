import 'package:flutter/material.dart';
import 'package:stripe_custom_ui/modules/add_card_screen/view/screen_add_card.dart';
import 'package:stripe_custom_ui/modules/card_screen/view/screen_cards.dart';
import 'package:stripe_custom_ui/modules/home_screen/view/screen_home.dart';
import 'package:stripe_custom_ui/modules/pay_using_card/view/screen_pay_using_card.dart';
import 'package:stripe_custom_ui/modules/payment_option_screen/view/screen_payment_methods.dart';
import 'package:stripe_custom_ui/modules/payment_screen/view/screen_payment.dart';

import '../modules/payment_screen/view/screen_payment_status.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.routesCard:
        return MaterialPageRoute(
            builder: (_) => const ScreenCards(),
            settings: const RouteSettings(name: AppRoutes.routesCard));
      case AppRoutes.routePayment:
        return MaterialPageRoute(
            builder: (_) => ScreenPayment(paymentIntent: args as String),
            settings: const RouteSettings(name: AppRoutes.routePayment));
      case AppRoutes.routesPaymentMethod:
        return MaterialPageRoute(
            builder: (_) => const ScreenPaymentMethods(),
            settings: const RouteSettings(name: AppRoutes.routesPaymentMethod));
      case AppRoutes.routeScreenAddCard:
        return MaterialPageRoute(
            builder: (_) => const ScreenAddCard(),
            settings: const RouteSettings(name: AppRoutes.routeScreenAddCard));
      case AppRoutes.routeScreenPayWithCard:
        return MaterialPageRoute(
            builder: (_) => const ScreenPayUsingCard(),
            settings:
                const RouteSettings(name: AppRoutes.routeScreenPayWithCard));
      case AppRoutes.routeScreenPaymentStatus:
        return MaterialPageRoute(
            builder: (_) => ScreenPaymentStatus(status: args as String),
            settings:
                const RouteSettings(name: AppRoutes.routeScreenPaymentStatus));

      default:
        return MaterialPageRoute(
            builder: (_) => const ScreenHome(),
            settings: const RouteSettings(name: AppRoutes.routesHome));
    }
  }
}
