import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_custom_ui/modules/payment_screen/widget/widget_dialog.dart';

import '../bloc/make_payment_bloc/make_payment_bloc.dart';

class ScreenPayment extends StatefulWidget {
  final String paymentIntent;
  const ScreenPayment({Key? key, required this.paymentIntent})
      : super(key: key);

  @override
  State<ScreenPayment> createState() => _ScreenPaymentState();
}

class _ScreenPaymentState extends State<ScreenPayment> {
  @override
  void initState() {
    BlocProvider.of<MakePaymentBloc>(context).add(MakePaymentUser(
        url:
            "https://api.stripe.com/v1/payment_intents/${widget.paymentIntent}/confirm"));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<MakePaymentBloc, MakePaymentState>(
        listener: (context, state) {
          if (state is MakePaymentResponse) {
            if (state.mModelUser.amountReceived == 0) {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  return WidgetDialog(
                    paymentIntent: widget.paymentIntent,
                    url: state.mModelUser.nextAction!.useStripeSdk!.stripeJs
                        .toString(),
                  );
                },
              );
            }
          }
        },
        builder: (context, state) {
          if (state is MakePaymentLoading) {
            return const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(color: Colors.black),
            );
          } else if (state is MakePaymentResponse) {
            if (state.mModelUser.amountReceived != 0) {
              return const Align(
                alignment: Alignment.center,
                child: Text(
                  "Payment intent confirmed please wait for while...",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
              );
            }
          } else {
            return const Align(
              alignment: Alignment.center,
              child: Text(
                "Payment Failed",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
              ),
            );
          }

          return const Align(
            alignment: Alignment.center,
            child: Text(
              "Payment intent confirmed please wait for while...",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          );
        },
      ),
    );
  }
}
