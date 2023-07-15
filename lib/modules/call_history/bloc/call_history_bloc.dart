import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:take_it_easy/modules/call_history/service/call_history.dart';

part 'call_history_event.dart';
part 'call_history_state.dart';

class CallHistoryBloc extends Bloc<CallHistoryEvent, CallHistoryState> {
  CallHistoryBloc(this.callHistoryService) : super(CallHistoryInitial()) {
    on<CallHistoryEvent>((event, emit) {
      if (event is GetCallHistory) {
        emit(CallHistoryLoading());

        emit(CallHistorySuccess());

        emit(CallHistoryFailure());
      }
    });
  }
  final CallHistoryService callHistoryService;
}
