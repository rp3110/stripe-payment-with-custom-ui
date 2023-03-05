part of 'add_card_bloc.dart';

/// [AddCardEvent] abstract class is used Event of bloc.
abstract class AddCardEvent extends Equatable {
  const AddCardEvent();

  @override
  List<Object> get props => [];
}

/// [AddCardUser] abstract class is used AddCard Event
class AddCardUser extends AddCardEvent {
  final String url;
  final Map<String, String> body;
  const AddCardUser({
    required this.body,
    required this.url,
  });

  @override
  List<Object> get props => [
        url,
      ];
}
