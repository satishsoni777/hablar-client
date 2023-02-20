
abstract class RtcUtil {
  void play(List<int> data);
  void init();
  void call();
  void sendData();
  void stop();
  void pause();
  void resume();
  void mute();
  void disconnect();
  void reconnect();
  void dispose();
  Function(dynamic)? streamChunkkData;
}