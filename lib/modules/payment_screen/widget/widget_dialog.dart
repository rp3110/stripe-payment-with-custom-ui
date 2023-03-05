import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_custom_ui/utils/app_routes.dart';
import 'package:stripe_custom_ui/utils/navigator_key.dart';
import 'package:webviewx/webviewx.dart';

import '../bloc/verify_payment_bloc/verify_payment_bloc.dart';

class WidgetDialog extends StatefulWidget {
  final String paymentIntent;
  final String url;

  const WidgetDialog({Key? key, required this.url, required this.paymentIntent})
      : super(key: key);

  @override
  State<WidgetDialog> createState() => _WidgetDialogState();
}

class _WidgetDialogState extends State<WidgetDialog> {
  @override
  dispose() {
    webViewXController?.dispose();
    super.dispose();
  }

  WebViewXController<dynamic>? webViewXController;
  int initialTime = 10;

  checkPayment(int timer, bool gotStatus) async {
    if (gotStatus) {
      return;
    } else if (timer == 0) {
      initialTime = 10;
      checkPayment(initialTime, false);
    } else {
      await Future.delayed(Duration(seconds: timer));

      BlocProvider.of<VerifyPaymentBloc>(
              NavigatorKey.navigatorKey.currentState!.context)
          .add(VerifyPaymentUser(
              url:
                  "https://api.stripe.com/v1/payment_intents/${widget.paymentIntent}"));
      initialTime = (initialTime / 2).floor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyPaymentBloc, VerifyPaymentState>(
      listener: (context, state) {
        if (state is VerifyPaymentResponse) {
          if (state.mModelUser.status == "succeeded") {
            print("succeeded------------------");
            checkPayment(initialTime, true);
            Navigator.pop(NavigatorKey.navigatorKey.currentState!.context);
            NavigatorKey.navigatorKey.currentState!.pushReplacementNamed(
                AppRoutes.routeScreenPaymentStatus,
                arguments: "Payment Successful");
          } else {
            checkPayment(initialTime, false);
          }
        } else if (state is VerifyPaymentFailure) {
          print("VerifyPaymentFailure------------------${state.mError}");
          checkPayment(initialTime, true);
          Navigator.pop(NavigatorKey.navigatorKey.currentState!.context);

          NavigatorKey.navigatorKey.currentState!.pushReplacementNamed(
              AppRoutes.routeScreenPaymentStatus,
              arguments: state.mError.toString());
        }
      },
      child: Dialog(
        backgroundColor: Colors.white,
        child: WebViewX(
          onWebViewCreated: (controller) {
            webViewXController = controller;
          },
          key: const ValueKey('webviewx'),
          initialContent: widget.url,
          onPageFinished: (url) {
            if (mounted) checkPayment(initialTime, false);
          },
          initialSourceType: SourceType.url,
          height: 500,
          width: double.maxFinite,
        ),
      ),
    );
  }
}
