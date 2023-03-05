import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../api_service/api_provider.dart';
import '../../../api_service/repository_auth.dart';
import '../../model/model_customer.dart';

part 'create_customer_event.dart';
part 'create_customer_state.dart';

/// Notifies the [CreateCustomerBloc] of a new [CreateCustomerEvent] which triggers
/// [RepositoryCreateCustomer] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class CreateCustomerBloc
    extends Bloc<CreateCustomerEvent, CreateCustomerState> {
  CreateCustomerBloc({
    required RepositoryAuth repositoryCreateCustomer,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryCreateCustomer = repositoryCreateCustomer,
        mApiProvider = apiProvider,
        mClient = client,
        super(CreateCustomerInitial()) {
    on<CreateCustomerUser>(_onCreateCustomerNewUser);
  }

  final RepositoryAuth mRepositoryCreateCustomer;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onCreateCustomerNewUser] of a new [CreateCustomerUser] which triggers
  void _onCreateCustomerNewUser(
    CreateCustomerUser event,
    Emitter<CreateCustomerState> emit,
  ) async {
    emit(CreateCustomerLoading());
    try {
      ModelCustomer mModelUser =
          await mRepositoryCreateCustomer.callCreateCustomerApi(event.url,
              await mApiProvider.getHeaderValue(), mApiProvider, mClient);
      print("mModelUser.id------------${mModelUser.id}");
      if (mModelUser.id != null) {
        emit(CreateCustomerResponse(mModelUser: mModelUser));
      } else {
        emit(const CreateCustomerFailure(mError: "failed"));
      }
    } on SocketException {
      emit(const CreateCustomerFailure(mError: "failed"));
    }
  }
}
