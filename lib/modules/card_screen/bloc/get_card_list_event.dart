part of 'get_card_list_bloc.dart';

/// [GetCardListEvent] abstract class is used Event of bloc.
abstract class GetCardListEvent extends Equatable {
  const GetCardListEvent();

  @override
  List<Object> get props => [];
}

/// [GetCardListUser] abstract class is used GetCardList Event
class GetCardListUser extends GetCardListEvent {
  final String url;

  const GetCardListUser({
    required this.url,
  });

  @override
  List<Object> get props => [
        url,
      ];
}
