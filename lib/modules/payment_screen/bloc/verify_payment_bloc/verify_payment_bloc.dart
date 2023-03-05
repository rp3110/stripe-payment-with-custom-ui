import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../api_service/api_provider.dart';
import '../../../../api_service/repository_auth.dart';
import '../../model/model_verify_payment.dart';

part 'verify_payment_event.dart';
part 'verify_payment_state.dart';

/// Notifies the [VerifyPaymentBloc] of a new [VerifyPaymentEvent] which triggers
/// [RepositoryVerifyPayment] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class VerifyPaymentBloc extends Bloc<VerifyPaymentEvent, VerifyPaymentState> {
  VerifyPaymentBloc({
    required RepositoryAuth repositoryVerifyPayment,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryVerifyPayment = repositoryVerifyPayment,
        mApiProvider = apiProvider,
        mClient = client,
        super(VerifyPaymentInitial()) {
    on<VerifyPaymentUser>(_onVerifyPaymentNewUser);
  }

  final RepositoryAuth mRepositoryVerifyPayment;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onVerifyPaymentNewUser] of a new [VerifyPaymentUser] which triggers
  void _onVerifyPaymentNewUser(
    VerifyPaymentUser event,
    Emitter<VerifyPaymentState> emit,
  ) async {
    emit(VerifyPaymentLoading());
    try {
      ModelVerifyPaymentIntent mModelUser =
          await mRepositoryVerifyPayment.callVerifyPaymentApi(event.url,
              await mApiProvider.getHeaderValue(), mApiProvider, mClient);
      if (mModelUser.lastPaymentError == null) {
        emit(VerifyPaymentResponse(mModelUser: mModelUser));
      } else {
        print("fail--------------------------------------444444");
        emit(VerifyPaymentFailure(
            mError: mModelUser.lastPaymentError!.message.toString()));
      }
    } on SocketException catch (e) {
      emit(VerifyPaymentFailure(mError: "Payment failed $e"));
    }
  }
}
