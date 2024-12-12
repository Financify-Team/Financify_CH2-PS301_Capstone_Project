part of 'operator_card_bloc.dart';

sealed class OperatorCardState extends Equatable {
  const OperatorCardState();

  @override
  List<Object> get props => [];
}

final class OperatorCardInitial extends OperatorCardState {}

final class OperatorCardLoading extends OperatorCardState {}

final class OperatorCardFailed extends OperatorCardState {
  final String e;

  const OperatorCardFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class OperatorCardSuccess extends OperatorCardState {
  final List<OperatorCardModel> operatorCards;

  const OperatorCardSuccess(this.operatorCards);

  @override
  List<Object> get props => [operatorCards];
}
