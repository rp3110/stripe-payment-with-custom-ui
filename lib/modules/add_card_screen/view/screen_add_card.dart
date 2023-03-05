import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_custom_ui/modules/add_card_screen/bloc/bloc_add_card/add_card_bloc.dart';
import 'package:stripe_custom_ui/utils/app_routes.dart';
import 'package:stripe_custom_ui/utils/multi_value_listenable_builder.dart';
import 'package:stripe_custom_ui/utils/navigator_key.dart';

import '../../../api_service/preference_helper.dart';
import '../../../common/widget/modal_progress_hud.dart';
import '../../../common/widget/widget_custom_button.dart';
import '../../../utils/card_input_formatter.dart';
import '../../../utils/card_utils.dart';
import '../bloc/bloc_create_token/bloc_create_token_bloc.dart';

class ScreenAddCard extends StatefulWidget {
  const ScreenAddCard({Key? key}) : super(key: key);

  @override
  State<ScreenAddCard> createState() => _ScreenAddCardState();
}

class _ScreenAddCardState extends State<ScreenAddCard> {
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
    return BlocListener<CreateTokenBloc, CreateTokenState>(
      listener: (context, state) {
        if (state is CreateTokenLoading) {
          isLoading.value = true;
        } else {
          if (state is CreateTokenFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.black, content: Text(state.mError)));
          }
          if (state is CreateTokenResponse) {
            Map<String, String> body = {
              'source': state.mModelUser.id.toString()
            };
            String? id = PreferenceHelper.getString("id");
            BlocProvider.of<AddCardBloc>(context).add(AddCardUser(
                body: body,
                url: "https://api.stripe.com/v1/customers/$id/sources"));
          }
        }
      },
      child: BlocListener<AddCardBloc, AddCardState>(
        listener: (context, state) {
          if (state is AddCardFailure) {
            isLoading.value = false;

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.black, content: Text(state.mError)));
          }
          if (state is AddCardResponse) {
            isLoading.value = false;
            NavigatorKey.navigatorKey.currentState!
                .pushReplacementNamed(AppRoutes.routesCard);
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
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
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
                          WidgetCustomButton(
                            title: "Verify and Add",
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                Map<String, String> body = {
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
                                  'card[cvc]': cardCVV.text,
                                  'card[name]': cardName.text
                                };
                                BlocProvider.of<CreateTokenBloc>(context).add(
                                    CreateTokenUser(
                                        body: body,
                                        url:
                                            "https://api.stripe.com/v1/tokens"));
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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
