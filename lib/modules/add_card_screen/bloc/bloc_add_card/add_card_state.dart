part of 'add_card_bloc.dart';

/// [AddCardState] abstract class is used AddCard State
abstract class AddCardState extends Equatable {
  const AddCardState();

  @override
  List<Object> get props => [];
}

/// [AddCardInitial] class is used AddCard State Initial
class AddCardInitial extends AddCardState {}

/// [AddCardLoading] class is used AddCard State Loading
class AddCardLoading extends AddCardState {}

/// [AddCardResponse] class is used AddCard State Response
class AddCardResponse extends AddCardState {
  final ModelAddCard mModelUser;

  const AddCardResponse({required this.mModelUser});

  @override
  List<Object> get props => [mModelUser];
}

/// [AddCardFailure] class is used AddCard State Failure
class AddCardFailure extends AddCardState {
  final String mError;

  const AddCardFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
