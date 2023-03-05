import 'package:flutter/material.dart';
import 'package:stripe_custom_ui/utils/app_routes.dart';

import '../../../common/widget/widget_custom_button.dart';
import '../../../utils/navigator_key.dart';

class ScreenPaymentMethods extends StatelessWidget {
  const ScreenPaymentMethods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("pay using")),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 10,
            ),
            WidgetCustomButton(
                onTap: () {
                  NavigatorKey.navigatorKey.currentState!
                      .pushReplacementNamed(AppRoutes.routeScreenAddCard);
                },
                title: "Add a new card"),
            const SizedBox(
              height: 10,
            ),
            WidgetCustomButton(
                onTap: () {
                  NavigatorKey.navigatorKey.currentState!
                      .pushReplacementNamed(AppRoutes.routesCard);
                },
                title: "Select from saved card"),
            const SizedBox(
              height: 10,
            ),
            WidgetCustomButton(
                onTap: () {
                  NavigatorKey.navigatorKey.currentState!
                      .pushReplacementNamed(AppRoutes.routeScreenPayWithCard);
                },
                title: "Pay without saving card")
          ],
        ),
      ),
    );
  }
}
