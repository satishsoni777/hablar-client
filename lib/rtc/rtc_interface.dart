abstract class RtcInterface<T>{
  Future<T> makeVoiceCall();
  Future<T> initialize();
  Future<T> getCallDuration();
  void dispose();
  void enableAudio();
  void disconnect();
}