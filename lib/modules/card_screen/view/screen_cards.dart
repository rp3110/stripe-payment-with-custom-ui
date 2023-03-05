import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_custom_ui/modules/bloc/payment_initent_bloc/payment_intent_bloc.dart';
import 'package:stripe_custom_ui/utils/app_routes.dart';
import 'package:stripe_custom_ui/utils/multi_value_listenable_builder.dart';
import 'package:stripe_custom_ui/utils/navigator_key.dart';

import '../../../api_service/preference_helper.dart';
import '../../../common/widget/modal_progress_hud.dart';
import '../bloc/get_card_list_bloc.dart';

class ScreenCards extends StatefulWidget {
  const ScreenCards({Key? key}) : super(key: key);

  @override
  State<ScreenCards> createState() => _ScreenCardsState();
}

class _ScreenCardsState extends State<ScreenCards> {
  ValueNotifier<String> isSelected = ValueNotifier<String>("");
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    String? id = PreferenceHelper.getString("id");
    BlocProvider.of<GetCardListBloc>(context).add(GetCardListUser(
        url: "https://api.stripe.com/v1/customers/$id/sources?object=card"));
    super.initState();
  }

  /// Used to store the body of the request.
  late Map<String, String> body;

  /// It returns a widget based on the card type.
  ///
  /// Args:
  ///   cardType (String): The type of card you want to display.
  Widget getCardType(String cardType) {
    String img = "";
    Icon? icon;
    switch (cardType) {
      case "MasterCard":
        img = 'mastercard.png';
        break;
      case "Visa":
        img = 'visa.png';
        break;
      case "Verve":
        img = 'verve.png';
        break;
      case "American Express":
        img = 'american_express.png';
        break;
      case "Discover":
        img = 'discover.png';
        break;
      case "Dinners Club":
        img = 'dinners_club.png';
        break;
      case "JCB":
        img = 'jcb.png';
        break;
      default:
        icon = const Icon(
          Icons.credit_card,
          size: 20.0,
          color: Color(0xFFB8B5C3),
        );
        break;
    }
    Widget widget;
    if (img.isNotEmpty) {
      widget = Image.asset(
        'assets/images/$img',
        height: 20,
        width: 40.0,
        fit: BoxFit.cover,
      );
    } else {
      widget = icon as Widget;
    }
    return widget;
  }

  Widget widgetCard(
      {required String cardNumber,
      required String expiryDate,
      required String cardHolderName,
      required bool isSelected,
      required String cardType}) {
    return Stack(
      children: [
        Container(
          height: 150,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(20),
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "**** **** **** $cardNumber",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                expiryDate,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cardHolderName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  getCardType(cardType)
                ],
              ),
            ],
          ),
        ),
        isSelected
            ? const Positioned(
                top: 15,
                right: 10,
                child: Icon(
                  Icons.radio_button_checked,
                  color: Colors.white,
                ),
              )
            : const SizedBox()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentIntentBloc, PaymentIntentState>(
      listener: (context, state) {
        if (state is PaymentIntentLoading) {
          isLoading.value = true;
        } else {
          isLoading.value = false;
          if (state is PaymentIntentResponse) {
            NavigatorKey.navigatorKey.currentState!.pushReplacementNamed(
                AppRoutes.routePayment,
                arguments: state.mModelUser.id.toString());
          } else if (state is PaymentIntentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.black,
                content: Text(
                  "Payment Intent failed",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                )));
          }
        }
      },
      child: MultiValueListenableBuilder(
          valueListenables: [isSelected, isLoading],
          builder: (context, lst, child) {
            return Scaffold(
                extendBody: true,
                appBar: AppBar(
                  title: const Text("Your cards"),
                ),
                bottomNavigationBar: isSelected.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 15),
                        child: InkWell(
                          onTap: () {
                            BlocProvider.of<PaymentIntentBloc>(context).add(
                                PaymentIntentUser(
                                    body: body,
                                    url:
                                        "https://api.stripe.com/v1/payment_intents"));
                          },
                          child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Text(
                                "PAY",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15),
                              )),
                        ),
                      )
                    : const SizedBox(),
                body: ModalProgressHUD(
                  inAsyncCall: isLoading.value,
                  color: Colors.transparent,
                  progressIndicator: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.transparent),
                  child: BlocConsumer<GetCardListBloc, GetCardListState>(
                    listener: (context, state) {
                      if (state is GetCardListFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.black,
                            content: Text(state.mError.toString())));
                      }
                    },
                    builder: (context, state) {
                      if (state is GetCardListLoading) {
                        return Container(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      }
                      if (state is GetCardListResponse) {
                        return state.mModelUser.data!.isNotEmpty
                            ? ListView.separated(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 16, right: 16, bottom: 80),
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      if (isSelected.value !=
                                          state.mModelUser.data![index].id) {
                                        isSelected.value = state
                                            .mModelUser.data![index].id
                                            .toString();
                                      } else {
                                        isSelected.value = "";
                                      }
                                      String? id =
                                          PreferenceHelper.getString("id");

                                      ///TODO: Change customer
                                      body = {
                                        'payment_method_types[]': 'card',
                                        'amount': '10000',
                                        'currency': 'inr',
                                        'customer': id!,
                                        'payment_method': state
                                            .mModelUser.data![index].id
                                            .toString()
                                      };
                                    },
                                    child: widgetCard(
                                        cardType: state
                                            .mModelUser.data![index].brand!,
                                        isSelected: isSelected.value ==
                                            state.mModelUser.data![index].id
                                                .toString(),
                                        cardNumber: state
                                            .mModelUser.data![index].last4
                                            .toString(),
                                        cardHolderName: state
                                                .mModelUser.data![index].name ??
                                            "",
                                        expiryDate:
                                            "${state.mModelUser.data![index].expMonth.toString()}/${state.mModelUser.data![index].expYear.toString()}"),
                                  );
                                },
                                itemCount: state.mModelUser.data!.length)
                            : const Align(
                                alignment: Alignment.center,
                                child: Text(
                                    "No cards available,please add a card.",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700)),
                              );
                      }
                      return const SizedBox();
                    },
                  ),
                ));
          }),
    );
  }
}
