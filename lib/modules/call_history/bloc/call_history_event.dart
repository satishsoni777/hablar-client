part of 'call_history_bloc.dart';

abstract class CallHistoryEvent extends Equatable {
  const CallHistoryEvent();

  @override
  List<Object> get props => [];
}

class GetCallHistory extends CallHistoryEvent {}
