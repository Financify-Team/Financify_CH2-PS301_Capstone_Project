part of 'tip_bloc.dart';

sealed class TipEvent extends Equatable {
  const TipEvent();

  @override
  List<Object> get props => [];
}

class TipGet extends TipEvent{}
