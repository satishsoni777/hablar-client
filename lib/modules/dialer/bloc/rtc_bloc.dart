import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'rtc_event.dart';
part 'rtc_state.dart';

class RtcBloc extends Bloc<RtcEvent, RtcState> {
  RtcBloc() : super(RtcInitial()) {
    on<RtcEvent>((event, emit) async{
      if (event is ConnectVoiceCall) {
        emit(RtcVoiceConnected());
      }
    });
  }
}
