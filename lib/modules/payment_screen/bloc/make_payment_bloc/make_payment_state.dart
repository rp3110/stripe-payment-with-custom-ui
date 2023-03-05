part of 'make_payment_bloc.dart';

/// [MakePaymentState] abstract class is used MakePayment State
abstract class MakePaymentState extends Equatable {
  const MakePaymentState();

  @override
  List<Object> get props => [];
}

/// [MakePaymentInitial] class is used MakePayment State Initial
class MakePaymentInitial extends MakePaymentState {}

/// [MakePaymentLoading] class is used MakePayment State Loading
class MakePaymentLoading extends MakePaymentState {}

/// [MakePaymentResponse] class is used MakePayment State Response
class MakePaymentResponse extends MakePaymentState {
  final ModelConfirmPaymentIntent mModelUser;

  const MakePaymentResponse({required this.mModelUser});

  @override
  List<Object> get props => [mModelUser];
}

/// [MakePaymentFailure] class is used MakePayment State Failure
class MakePaymentFailure extends MakePaymentState {
  final String mError;

  const MakePaymentFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
