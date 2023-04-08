extension SocketEvents on Events {
  Events eventType(Map<String, dynamic> message) {
    if (message.isEmpty || message == null) return Events.NONE;
    String event = message["event"];
    switch (event.toString().toUpperCase()) {
      case "LEAVE_ROOM":
        return Events.LEAVE_ROOM;
    }
    return message["event"];
  }
}

enum Events {
  LEAVE_ROOM,
  NONE
}
