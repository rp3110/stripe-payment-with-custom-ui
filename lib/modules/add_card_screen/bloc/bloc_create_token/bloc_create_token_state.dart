part of 'bloc_create_token_bloc.dart';

/// [CreateTokenState] abstract class is used CreateToken State
abstract class CreateTokenState extends Equatable {
  const CreateTokenState();

  @override
  List<Object> get props => [];
}

/// [CreateTokenInitial] class is used CreateToken State Initial
class CreateTokenInitial extends CreateTokenState {}

/// [CreateTokenLoading] class is used CreateToken State Loading
class CreateTokenLoading extends CreateTokenState {}

/// [CreateTokenResponse] class is used CreateToken State Response
class CreateTokenResponse extends CreateTokenState {
  final ModelCreateToken mModelUser;

  const CreateTokenResponse({required this.mModelUser});

  @override
  List<Object> get props => [mModelUser];
}

/// [CreateTokenFailure] class is used CreateToken State Failure
class CreateTokenFailure extends CreateTokenState {
  final String mError;

  const CreateTokenFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
