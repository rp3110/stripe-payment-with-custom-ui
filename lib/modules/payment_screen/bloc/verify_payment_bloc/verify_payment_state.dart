part of 'verify_payment_bloc.dart';

/// [VerifyPaymentState] abstract class is used VerifyPayment State
abstract class VerifyPaymentState extends Equatable {
  const VerifyPaymentState();

  @override
  List<Object> get props => [];
}

/// [VerifyPaymentInitial] class is used VerifyPayment State Initial
class VerifyPaymentInitial extends VerifyPaymentState {}

/// [VerifyPaymentLoading] class is used VerifyPayment State Loading
class VerifyPaymentLoading extends VerifyPaymentState {}

/// [VerifyPaymentResponse] class is used VerifyPayment State Response
class VerifyPaymentResponse extends VerifyPaymentState {
  final ModelVerifyPaymentIntent mModelUser;

  const VerifyPaymentResponse({required this.mModelUser});

  @override
  List<Object> get props => [mModelUser];
}

/// [VerifyPaymentFailure] class is used VerifyPayment State Failure
class VerifyPaymentFailure extends VerifyPaymentState {
  final String mError;

  const VerifyPaymentFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
