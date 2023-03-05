import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stripe_custom_ui/modules/add_card_screen/model/model_add_card.dart';
import 'package:stripe_custom_ui/modules/add_card_screen/model/model_create_token.dart';
import 'package:stripe_custom_ui/modules/card_screen/model/model_get_card_list.dart';
import 'package:stripe_custom_ui/modules/pay_using_card/model/model_pay_using_card.dart';
import 'package:stripe_custom_ui/modules/payment_screen/model/model_confirm_payment_intent.dart';

import '../modules/model/model_customer.dart';
import '../modules/model/model_payment_intent.dart';
import '../modules/payment_screen/model/model_verify_payment.dart';
import 'api_provider.dart';

/// This class used to API and bloc connection
class RepositoryAuth {
  static final RepositoryAuth _repository = RepositoryAuth._internal();

  factory RepositoryAuth() {
    return _repository;
  }

  RepositoryAuth._internal();

  /// This method used for get Api
  /// Return type of this method [ModelGetCardList]
  Future<dynamic> callGetCardListApi(String url, Map<String, String> header,
      ApiProvider mApiProvider, http.Client client) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelGetCardList result = ModelGetCardList.fromJson(jsonDecode(response));
    return result;
  }

  /// This method used for get Api
  /// Return type of this method [ModelVerifyPaymentIntent]
  Future<ModelVerifyPaymentIntent> callVerifyPaymentApi(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelVerifyPaymentIntent result = ModelVerifyPaymentIntent();
    try {
      result = ModelVerifyPaymentIntent.fromJson(jsonDecode(response));
    } catch (e) {
      print("e------------------____$e");
    }
    return result;
  }

  /// This method used to get Api
  /// Return type of this method [ModelLogout]
  Future<ModelCustomer> callCreateCustomerApi(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    final response = await mApiProvider.callPostMethod(client, url, {}, header);
    ModelCustomer result = ModelCustomer.fromJson(jsonDecode(response));
    return result;
  }

  /// This method used to post Api
  /// Return type of this method [ModelCreateToken]
  Future<ModelCreateToken> callCreateTokenApi(
      String url,
      Map<String, String> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    print("body-------------$body");

    final response =
        await mApiProvider.callPostMethodWithEncoded(client, url, body, header);
    ModelCreateToken result = ModelCreateToken.fromJson(jsonDecode(response));
    return result;
  }

  /// This method used to post Api
  /// Return type of this method [ModelCreateToken]
  Future<ModelPaymentIntent> callPaymentIntentApi(
      String url,
      Map<String, String> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    print("body-------------$body");

    final response =
        await mApiProvider.callPostMethodWithEncoded(client, url, body, header);
    ModelPaymentIntent result =
        ModelPaymentIntent.fromJson(jsonDecode(response));
    return result;
  }

  /// This method used to post Api
  /// Return type of this method [ModelCreateToken]
  Future<ModelConfirmPaymentIntent> callMakePaymentApi(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    final response =
        await mApiProvider.callPostMethodWithEncoded(client, url, {}, header);
    print("response-------------_$response");
    ModelConfirmPaymentIntent result =
        ModelConfirmPaymentIntent.fromJson(jsonDecode(response));
    return result;
  }

  /// This method used to post Api
  /// Return type of this method [ModelPayUsingCard]
  Future<ModelPayUsingCard> callPayUsingCardApi(
      String url,
      Map<String, String> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    final response =
        await mApiProvider.callPostMethodWithEncoded(client, url, body, header);
    ModelPayUsingCard result = ModelPayUsingCard.fromJson(jsonDecode(response));
    return result;
  }

  /// This method used to post Api
  /// Return type of this method [ModelAddCard]
  Future<ModelAddCard> callAddCardApi(
      String url,
      Map<String, String> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    final response =
        await mApiProvider.callPostMethodWithEncoded(client, url, body, header);
    ModelAddCard result = ModelAddCard.fromJson(jsonDecode(response));
    return result;
  }
}
