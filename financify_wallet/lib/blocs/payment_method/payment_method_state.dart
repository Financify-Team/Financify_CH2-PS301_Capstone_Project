part of 'payment_method_bloc.dart';

sealed class PaymentMethodState extends Equatable {
  const PaymentMethodState();

  @override
  List<Object> get props => [];
}

final class PaymentMethodInitial extends PaymentMethodState {}

final class PaymentMethodLoading extends PaymentMethodState {}

final class PaymentMethodFailed extends PaymentMethodState {
  final String e;

  const PaymentMethodFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class PaymentMethodSuccess extends PaymentMethodState {
  final List<PaymentMethodModel> paymentMethods;

  const PaymentMethodSuccess(this.paymentMethods);

  @override
  List<Object> get props => [paymentMethods];
}
