part of 'payment_intent_bloc.dart';

/// [PaymentIntentState] abstract class is used PaymentIntent State
abstract class PaymentIntentState extends Equatable {
  const PaymentIntentState();

  @override
  List<Object> get props => [];
}

/// [PaymentIntentInitial] class is used PaymentIntent State Initial
class PaymentIntentInitial extends PaymentIntentState {}

/// [PaymentIntentLoading] class is used PaymentIntent State Loading
class PaymentIntentLoading extends PaymentIntentState {}

/// [PaymentIntentResponse] class is used PaymentIntent State Response
class PaymentIntentResponse extends PaymentIntentState {
  final ModelPaymentIntent mModelUser;

  const PaymentIntentResponse({required this.mModelUser});

  @override
  List<Object> get props => [mModelUser];
}

/// [PaymentIntentFailure] class is used PaymentIntent State Failure
class PaymentIntentFailure extends PaymentIntentState {
  final String mError;

  const PaymentIntentFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
