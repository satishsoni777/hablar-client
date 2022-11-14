part of 'rtc_bloc.dart';

abstract class RtcState extends Equatable {
  const RtcState();
  
  @override
  List<Object> get props => [];
}

class RtcInitial extends RtcState {}

class RtcVoiceConnected extends RtcState{}