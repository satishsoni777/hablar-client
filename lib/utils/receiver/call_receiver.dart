import 'package:flutter/foundation.dart';

abstract class CallReceiver {
  void send(Uint8List data);
  void close();
  void dispose();
}

class CallReceiverImpl extends CallReceiver {
  @override
  void send(Uint8List data) {
    // TODO: implement send
  }
  
  @override
  void close() {
    // TODO: implement close
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
  }
}
