import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_custom_ui/modules/bloc/payment_initent_bloc/payment_intent_bloc.dart';
import 'package:stripe_custom_ui/utils/multi_value_listenable_builder.dart';

import '../../../common/widget/modal_progress_hud.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/card_input_formatter.dart';
import '../../../utils/card_utils.dart';
import '../../../utils/navigator_key.dart';
import '../bloc/pay_using_card_bloc.dart';

class ScreenPayUsingCard extends StatefulWidget {
  const ScreenPayUsingCard({Key? key}) : super(key: key);

  @override
  State<ScreenPayUsingCard> createState() => _ScreenPayUsingCardState();
}

class _ScreenPayUsingCardState extends State<ScreenPayUsingCard> {
  /// A controller for the text field.
  TextEditingController cardNumberController = TextEditingController();

  /// A controller for the text field.
  TextEditingController cardName = TextEditingController();

  /// A controller for the text field.
  TextEditingController cardCVV = TextEditingController();

  /// A controller for the text field.
  TextEditingController cardDate = TextEditingController();

  /// A state management technique.
  ValueNotifier<CardType> cardType = ValueNotifier<CardType>(CardType.Invalid);

  /// A state management technique.
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  /// Used to validate the form.
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    cardNumberController.addListener(
      () {
        getCardTypeFrmNumber();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    super.dispose();
  }

  /// It gets the card type from the card number.
  void getCardTypeFrmNumber() {
    if (cardNumberController.text.length <= 6) {
      String input = CardUtils.getCleanedNumber(cardNumberController.text);
      CardType type = CardUtils.getCardTypeFrmNumber(input);
      if (type != cardType.value) {
        cardType.value = type;
      }
    }
  }

  /// It returns an OutlineInputBorder object.
  OutlineInputBorder mOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.white, width: 0),
    );
  }

  ///common decoration for the fields
  InputDecoration decoration(
      {required String hintText, required Widget? suffix}) {
    return InputDecoration(
        hintText: hintText,
        suffix: suffix,
        contentPadding: const EdgeInsets.all(15),
        hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.25), fontWeight: FontWeight.w400),
        filled: true,
        fillColor: Colors.cyanAccent,
        enabledBorder: mOutlineInputBorder(),
        focusedBorder: mOutlineInputBorder(),
        disabledBorder: mOutlineInputBorder(),
        errorBorder: mOutlineInputBorder(),
        focusedErrorBorder: mOutlineInputBorder());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PayUsingCardBloc, PayUsingCardState>(
      listener: (context, state) {
        if (state is PayUsingCardLoading) {
          isLoading.value = true;
        } else {
          if (state is PayUsingCardResponse) {
            ///TODO:Change customer
            Map<String, String> body = {
              'payment_method_types[]': 'card',
              'amount': '10000',
              'currency': 'inr',
              'customer': 'cus_NJMkTniOfYNabW',
              'payment_method': state.mModelUser.id.toString()
            };
            BlocProvider.of<PaymentIntentBloc>(context).add(PaymentIntentUser(
                body: body, url: "https://api.stripe.com/v1/payment_intents"));
          }
        }
      },
      child: BlocListener<PaymentIntentBloc, PaymentIntentState>(
        listener: (context, state) {
          if (state is PaymentIntentLoading) {
            isLoading.value = true;
          } else {
            isLoading.value = false;
            if (state is PaymentIntentResponse) {
              print("log----------------${state.mModelUser.id}");

              NavigatorKey.navigatorKey.currentState!.pushReplacementNamed(
                  AppRoutes.routePayment,
                  arguments: state.mModelUser.id);
            } else if (state is PaymentIntentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.black, content: Text(state.mError)));
            }
          }
        },
        child: MultiValueListenableBuilder(
          valueListenables: [cardType, isLoading],
          builder: (context, lst, child) {
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(title: const Text("New card")),
                body: SafeArea(
                  child: ModalProgressHUD(
                    inAsyncCall: isLoading.value,
                    color: Colors.transparent,
                    progressIndicator: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        backgroundColor: Colors.transparent),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                    validator: (String? value) {
                                      return CardUtils.validateCardNum(value);
                                    },
                                    controller: cardNumberController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(16),
                                      CardNumberInputFormatter()
                                    ],
                                    decoration: decoration(
                                        hintText: "Card number",
                                        suffix: CardUtils.getCardIcon(
                                            cardType.value))),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: TextFormField(
                                    controller: cardName,
                                    validator: (String? value) {
                                      if ((value ?? "").isEmpty) {
                                        return "This field can't be empty.";
                                      }
                                      return null;
                                    },
                                    decoration: decoration(
                                        hintText: "Full name",
                                        suffix: const SizedBox()),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: cardCVV,
                                        validator: (String? value) {
                                          return CardUtils.validateCVV(value);
                                        },
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          // Limit the input
                                          LengthLimitingTextInputFormatter(3),
                                        ],
                                        decoration: decoration(
                                            hintText: "CVV",
                                            suffix: const SizedBox()),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: cardDate,
                                        validator: (String? value) {
                                          return CardUtils.validateDate(value);
                                        },
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                          CardMonthInputFormatter()
                                        ],
                                        decoration: decoration(
                                            hintText: "MM/YY",
                                            suffix: const SizedBox()),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            child: Container(
                                height: 46,
                                width: double.maxFinite,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Text(
                                  "Pay using card",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                )),
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                final Map<String, String> body = {
                                  'type': 'card',
                                  'card[number]': cardNumberController.text,
                                  'card[exp_month]':
                                      CardUtils.getExpiryDate(cardDate.text)
                                          .first
                                          .toString(),
                                  'card[exp_year]':
                                      CardUtils.convertYearTo4Digits(
                                              CardUtils.getExpiryDate(
                                                      cardDate.text)
                                                  .last)
                                          .toString(),
                                  'card[cvc]': cardCVV.text
                                };
                                BlocProvider.of<PayUsingCardBloc>(context).add(
                                    PayUsingCardUser(
                                        body: body,
                                        url:
                                            "https://api.stripe.com/v1/payment_methods"));
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }
}
