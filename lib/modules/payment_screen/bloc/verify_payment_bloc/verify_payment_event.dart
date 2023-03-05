part of 'verify_payment_bloc.dart';

/// [VerifyPaymentEvent] abstract class is used Event of bloc.
abstract class VerifyPaymentEvent extends Equatable {
  const VerifyPaymentEvent();

  @override
  List<Object> get props => [];
}

/// [VerifyPaymentUser] abstract class is used VerifyPayment Event
class VerifyPaymentUser extends VerifyPaymentEvent {
  final String url;
  const VerifyPaymentUser({
    required this.url,
  });

  @override
  List<Object> get props => [
        url,
      ];
}
