import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../api_service/api_provider.dart';
import '../../../api_service/repository_auth.dart';
import '../model/model_get_card_list.dart';

part 'get_card_list_event.dart';
part 'get_card_list_state.dart';

/// Notifies the [GetCardListBloc] of a new [GetCardListEvent] which triggers
/// [RepositoryGetCardList] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class GetCardListBloc extends Bloc<GetCardListEvent, GetCardListState> {
  GetCardListBloc({
    required RepositoryAuth repositoryGetCardList,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryGetCardList = repositoryGetCardList,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetCardListInitial()) {
    on<GetCardListUser>(_onGetCardListNewUser);
  }

  final RepositoryAuth mRepositoryGetCardList;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onGetCardListNewUser] of a new [GetCardListUser] which triggers
  void _onGetCardListNewUser(
    GetCardListUser event,
    Emitter<GetCardListState> emit,
  ) async {
    emit(GetCardListLoading());
    try {
      ModelGetCardList mModelUser =
          await mRepositoryGetCardList.callGetCardListApi(event.url,
              await mApiProvider.getHeaderValue(), mApiProvider, mClient);
      print("mModelUser.id------------${mModelUser.object}");
      if (mModelUser.object != null) {
        emit(GetCardListResponse(mModelUser: mModelUser));
      } else {
        emit(const GetCardListFailure(mError: "failed"));
      }
    } on SocketException {
      emit(const GetCardListFailure(mError: "failed"));
    }
  }
}
