part of 'pay_using_card_bloc.dart';

/// [PayUsingCardEvent] abstract class is used Event of bloc.
abstract class PayUsingCardEvent extends Equatable {
  const PayUsingCardEvent();

  @override
  List<Object> get props => [];
}

/// [PayUsingCardUser] abstract class is used PayUsingCard Event
class PayUsingCardUser extends PayUsingCardEvent {
  final String url;
  final Map<String, String> body;
  const PayUsingCardUser({
    required this.body,
    required this.url,
  });

  @override
  List<Object> get props => [
        url,
      ];
}
