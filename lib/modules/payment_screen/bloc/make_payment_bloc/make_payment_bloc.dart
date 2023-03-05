import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_custom_ui/modules/payment_screen/model/model_confirm_payment_intent.dart';

import '../../../../api_service/api_provider.dart';
import '../../../../api_service/repository_auth.dart';

part 'make_payment_event.dart';
part 'make_payment_state.dart';

/// Notifies the [MakePaymentBloc] of a new [MakePaymentEvent] which triggers
/// [RepositoryMakePayment] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class MakePaymentBloc extends Bloc<MakePaymentEvent, MakePaymentState> {
  MakePaymentBloc({
    required RepositoryAuth repositoryMakePayment,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryMakePayment = repositoryMakePayment,
        mApiProvider = apiProvider,
        mClient = client,
        super(MakePaymentInitial()) {
    on<MakePaymentUser>(_onMakePaymentNewUser);
  }

  final RepositoryAuth mRepositoryMakePayment;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onMakePaymentNewUser] of a new [MakePaymentUser] which triggers
  void _onMakePaymentNewUser(
    MakePaymentUser event,
    Emitter<MakePaymentState> emit,
  ) async {
    emit(MakePaymentLoading());
    try {
      ModelConfirmPaymentIntent mModelUser =
          await mRepositoryMakePayment.callMakePaymentApi(event.url,
              await mApiProvider.getHeaderValue(), mApiProvider, mClient);
      print("mModelUser.id------------${mModelUser.id}");
      if ((mModelUser.status != null)) {
        emit(MakePaymentResponse(mModelUser: mModelUser));
      } else {
        emit(const MakePaymentFailure(mError: "failed"));
      }
    } on SocketException {
      emit(const MakePaymentFailure(mError: "failed"));
    }
  }
}
