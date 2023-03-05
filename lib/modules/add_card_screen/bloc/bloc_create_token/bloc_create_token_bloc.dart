import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_custom_ui/modules/add_card_screen/model/model_create_token.dart';

import '../../../../api_service/api_provider.dart';
import '../../../../api_service/repository_auth.dart';

part 'bloc_create_token_event.dart';
part 'bloc_create_token_state.dart';

/// Notifies the [CreateTokenBloc] of a new [CreateTokenEvent] which triggers
/// [RepositoryCreateToken] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class CreateTokenBloc extends Bloc<CreateTokenEvent, CreateTokenState> {
  CreateTokenBloc({
    required RepositoryAuth repositoryCreateToken,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryCreateToken = repositoryCreateToken,
        mApiProvider = apiProvider,
        mClient = client,
        super(CreateTokenInitial()) {
    on<CreateTokenUser>(_onCreateTokenNewUser);
  }

  final RepositoryAuth mRepositoryCreateToken;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onCreateTokenNewUser] of a new [CreateTokenUser] which triggers
  void _onCreateTokenNewUser(
    CreateTokenUser event,
    Emitter<CreateTokenState> emit,
  ) async {
    emit(CreateTokenLoading());
    try {
      ModelCreateToken mModelUser =
          await mRepositoryCreateToken.callCreateTokenApi(event.url, event.body,
              await mApiProvider.getHeaderValue(), mApiProvider, mClient);
      print("mModelUser.id------------${mModelUser.id}");
      if (mModelUser.id != null) {
        emit(CreateTokenResponse(mModelUser: mModelUser));
      } else {
        emit(const CreateTokenFailure(mError: "INVALID CARD"));
      }
    } on SocketException {
      emit(const CreateTokenFailure(mError: "INVALID CARD"));
    }
  }
}
