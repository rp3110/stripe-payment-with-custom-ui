import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_custom_ui/modules/pay_using_card/model/model_pay_using_card.dart';

import '../../../api_service/api_provider.dart';
import '../../../api_service/repository_auth.dart';

part 'pay_using_card_event.dart';
part 'pay_using_card_state.dart';

/// Notifies the [PayUsingCardBloc] of a new [PayUsingCardEvent] which triggers
/// [RepositoryPayUsingCard] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class PayUsingCardBloc extends Bloc<PayUsingCardEvent, PayUsingCardState> {
  PayUsingCardBloc({
    required RepositoryAuth repositoryPayUsingCard,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryPayUsingCard = repositoryPayUsingCard,
        mApiProvider = apiProvider,
        mClient = client,
        super(PayUsingCardInitial()) {
    on<PayUsingCardUser>(_onPayUsingCardNewUser);
  }

  final RepositoryAuth mRepositoryPayUsingCard;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onPayUsingCardNewUser] of a new [PayUsingCardUser] which triggers
  void _onPayUsingCardNewUser(
    PayUsingCardUser event,
    Emitter<PayUsingCardState> emit,
  ) async {
    emit(PayUsingCardLoading());
    try {
      ModelPayUsingCard mModelUser =
          await mRepositoryPayUsingCard.callPayUsingCardApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValue(),
              mApiProvider,
              mClient);
      print("mModelUser.id------------${mModelUser.id}");
      if (mModelUser.id != null) {
        emit(PayUsingCardResponse(mModelUser: mModelUser));
      } else {
        emit(const PayUsingCardFailure(mError: "failed"));
      }
    } on SocketException {
      emit(const PayUsingCardFailure(mError: "failed"));
    }
  }
}
