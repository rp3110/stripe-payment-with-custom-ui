part of 'payment_intent_bloc.dart';

/// [PaymentIntentEvent] abstract class is used Event of bloc.
abstract class PaymentIntentEvent extends Equatable {
  const PaymentIntentEvent();

  @override
  List<Object> get props => [];
}

/// [PaymentIntentUser] abstract class is used PaymentIntent Event
class PaymentIntentUser extends PaymentIntentEvent {
  final String url;
  final Map<String, String> body;
  const PaymentIntentUser({
    required this.body,
    required this.url,
  });

  @override
  List<Object> get props => [
        url,
      ];
}
