part of 'transfer_bloc.dart';

sealed class TransferState extends Equatable {
  const TransferState();

  @override
  List<Object> get props => [];
}

final class TransferInitial extends TransferState {}

final class TransferLoading extends TransferState {}

final class TransferFailed extends TransferState {
  final String e;

  const TransferFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class TransferSuccess extends TransferState {}
