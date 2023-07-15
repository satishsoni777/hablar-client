part of 'call_history_bloc.dart';

abstract class CallHistoryState extends Equatable {
  const CallHistoryState();

  @override
  List<Object> get props => [];
}

class CallHistoryInitial extends CallHistoryState {}

class CallHistoryLoading extends CallHistoryState {}

class CallHistorySuccess extends CallHistoryState {}

class CallHistoryFailure extends CallHistoryState {}
