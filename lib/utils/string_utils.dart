bool isNullOrEmpty(String str) {
  return str == null || str.length == 0;
}

class BaseUrl {
  static const local = "http://localhost:8082";
  static const prod = "";
  static const render = "https://teasy-server.onrender.com/";
  static const aws = "http://13.127.178.129:8083";
  static const stage = "";
}
