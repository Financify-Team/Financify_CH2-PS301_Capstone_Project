part of 'topup_bloc.dart';

sealed class TopupState extends Equatable {
  const TopupState();

  @override
  List<Object> get props => [];
}

final class TopupInitial extends TopupState {}

final class TopupLoading extends TopupState {}

final class TopupFailed extends TopupState {
  final String e;

  const TopupFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class TopupSuccess extends TopupState {
  final String redirectUrl;

  const TopupSuccess(this.redirectUrl);

  @override
  List<Object> get props => [redirectUrl];
}