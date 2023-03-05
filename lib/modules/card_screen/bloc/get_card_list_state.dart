part of 'get_card_list_bloc.dart';

/// [GetCardListState] abstract class is used GetCardList State
abstract class GetCardListState extends Equatable {
  const GetCardListState();

  @override
  List<Object> get props => [];
}

/// [GetCardListInitial] class is used GetCardList State Initial
class GetCardListInitial extends GetCardListState {}

/// [GetCardListLoading] class is used GetCardList State Loading
class GetCardListLoading extends GetCardListState {}

/// [GetCardListResponse] class is used GetCardList State Response
class GetCardListResponse extends GetCardListState {
  final ModelGetCardList mModelUser;

  const GetCardListResponse({required this.mModelUser});

  @override
  List<Object> get props => [mModelUser];
}

/// [GetCardListFailure] class is used GetCardList State Failure
class GetCardListFailure extends GetCardListState {
  final String mError;

  const GetCardListFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
