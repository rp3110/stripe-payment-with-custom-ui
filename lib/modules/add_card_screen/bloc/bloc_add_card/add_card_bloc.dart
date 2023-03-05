import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_custom_ui/modules/add_card_screen/model/model_add_card.dart';

import '../../../../api_service/api_provider.dart';
import '../../../../api_service/repository_auth.dart';

part 'add_card_event.dart';
part 'add_card_state.dart';

/// Notifies the [AddCardBloc] of a new [AddCardEvent] which triggers
/// [RepositoryAddCard] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class AddCardBloc extends Bloc<AddCardEvent, AddCardState> {
  AddCardBloc({
    required RepositoryAuth repositoryAddCard,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryAddCard = repositoryAddCard,
        mApiProvider = apiProvider,
        mClient = client,
        super(AddCardInitial()) {
    on<AddCardUser>(_onAddCardNewUser);
  }

  final RepositoryAuth mRepositoryAddCard;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onAddCardNewUser] of a new [AddCardUser] which triggers
  void _onAddCardNewUser(
    AddCardUser event,
    Emitter<AddCardState> emit,
  ) async {
    emit(AddCardLoading());
    try {
      ModelAddCard mModelUser = await mRepositoryAddCard.callAddCardApi(
          event.url,
          event.body,
          await mApiProvider.getHeaderValue(),
          mApiProvider,
          mClient);
      print("mModelUser.id------------${mModelUser.id}");
      if (mModelUser.id != null) {
        emit(AddCardResponse(mModelUser: mModelUser));
      } else {
        emit(const AddCardFailure(mError: "Invalid Card"));
      }
    } on SocketException {
      emit(const AddCardFailure(mError: "Invalid Card"));
    }
  }
}
