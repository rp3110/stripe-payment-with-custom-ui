part of 'create_customer_bloc.dart';

/// [CreateCustomerState] abstract class is used CreateCustomer State
abstract class CreateCustomerState extends Equatable {
  const CreateCustomerState();

  @override
  List<Object> get props => [];
}

/// [CreateCustomerInitial] class is used CreateCustomer State Initial
class CreateCustomerInitial extends CreateCustomerState {}

/// [CreateCustomerLoading] class is used CreateCustomer State Loading
class CreateCustomerLoading extends CreateCustomerState {}

/// [CreateCustomerResponse] class is used CreateCustomer State Response
class CreateCustomerResponse extends CreateCustomerState {
  final ModelCustomer mModelUser;

  const CreateCustomerResponse({required this.mModelUser});

  @override
  List<Object> get props => [mModelUser];
}

/// [CreateCustomerFailure] class is used CreateCustomer State Failure
class CreateCustomerFailure extends CreateCustomerState {
  final String mError;

  const CreateCustomerFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
