part of 'create_customer_bloc.dart';

/// [CreateCustomerEvent] abstract class is used Event of bloc.
abstract class CreateCustomerEvent extends Equatable {
  const CreateCustomerEvent();

  @override
  List<Object> get props => [];
}

/// [CreateCustomerUser] abstract class is used CreateCustomer Event
class CreateCustomerUser extends CreateCustomerEvent {
  final String url;

  const CreateCustomerUser({
    required this.url,
  });

  @override
  List<Object> get props => [
        url,
      ];
}
