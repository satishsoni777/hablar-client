bool isNullOrEmpty(String? str) {
  return str == null || str.length == 0;
}

bool isNullOrEmptyList(List<dynamic>? list) {
  return list == null || list.length == 0;
}

class BaseUrl {
  static const local = "http://localhost:8083";
  static const prod = "";
  static const render = "https://teasy-server.onrender.com/";
  static const aws = "http://13.127.178.129:8083/";
  static const awsWWUrl = "wss://13.127.178.129:8083";
  static const stage = "";
}
