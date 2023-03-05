part of 'make_payment_bloc.dart';

/// [MakePaymentEvent] abstract class is used Event of bloc.
abstract class MakePaymentEvent extends Equatable {
  const MakePaymentEvent();

  @override
  List<Object> get props => [];
}

/// [MakePaymentUser] abstract class is used MakePayment Event
class MakePaymentUser extends MakePaymentEvent {
  final String url;
  const MakePaymentUser({
    required this.url,
  });

  @override
  List<Object> get props => [
        url,
      ];
}
