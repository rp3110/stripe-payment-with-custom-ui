part of 'bloc_create_token_bloc.dart';

/// [CreateTokenEvent] abstract class is used Event of bloc.
abstract class CreateTokenEvent extends Equatable {
  const CreateTokenEvent();

  @override
  List<Object> get props => [];
}

/// [CreateTokenUser] abstract class is used CreateToken Event
class CreateTokenUser extends CreateTokenEvent {
  final String url;
  final Map<String, String> body;
  const CreateTokenUser({
    required this.body,
    required this.url,
  });

  @override
  List<Object> get props => [
        url,
      ];
}
