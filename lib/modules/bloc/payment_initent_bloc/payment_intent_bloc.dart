import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../api_service/api_provider.dart';
import '../../../api_service/repository_auth.dart';
import '../../model/model_payment_intent.dart';

part 'payment_intent_event.dart';
part 'payment_intent_state.dart';

/// Notifies the [PaymentIntentBloc] of a new [PaymentIntentEvent] which triggers
/// [RepositoryPaymentIntent] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class PaymentIntentBloc extends Bloc<PaymentIntentEvent, PaymentIntentState> {
  PaymentIntentBloc({
    required RepositoryAuth repositoryPaymentIntent,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryPaymentIntent = repositoryPaymentIntent,
        mApiProvider = apiProvider,
        mClient = client,
        super(PaymentIntentInitial()) {
    on<PaymentIntentUser>(_onPaymentIntentNewUser);
  }

  final RepositoryAuth mRepositoryPaymentIntent;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onPaymentIntentNewUser] of a new [PaymentIntentUser] which triggers
  void _onPaymentIntentNewUser(
    PaymentIntentUser event,
    Emitter<PaymentIntentState> emit,
  ) async {
    emit(PaymentIntentLoading());
    try {
      ModelPaymentIntent mModelUser =
          await mRepositoryPaymentIntent.callPaymentIntentApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValue(),
              mApiProvider,
              mClient);
      if (mModelUser.id != null) {
        emit(PaymentIntentResponse(mModelUser: mModelUser));
      } else {
        emit(const PaymentIntentFailure(mError: "failed"));
      }
    } on SocketException {
      emit(const PaymentIntentFailure(mError: "failed"));
    }
  }
}
