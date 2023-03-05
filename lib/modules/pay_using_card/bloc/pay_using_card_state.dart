part of 'pay_using_card_bloc.dart';

/// [PayUsingCardState] abstract class is used PayUsingCard State
abstract class PayUsingCardState extends Equatable {
  const PayUsingCardState();

  @override
  List<Object> get props => [];
}

/// [PayUsingCardInitial] class is used PayUsingCard State Initial
class PayUsingCardInitial extends PayUsingCardState {}

/// [PayUsingCardLoading] class is used PayUsingCard State Loading
class PayUsingCardLoading extends PayUsingCardState {}

/// [PayUsingCardResponse] class is used PayUsingCard State Response
class PayUsingCardResponse extends PayUsingCardState {
  final ModelPayUsingCard mModelUser;

  const PayUsingCardResponse({required this.mModelUser});

  @override
  List<Object> get props => [mModelUser];
}

/// [PayUsingCardFailure] class is used PayUsingCard State Failure
class PayUsingCardFailure extends PayUsingCardState {
  final String mError;

  const PayUsingCardFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
