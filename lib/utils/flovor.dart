import 'package:take_it_easy/utils/string_utils.dart';

enum Enviroment {
  LOCALHOST,
  PROD,
  DEV,
  RENDER,
  STAGE
}

class Flavor {
  // ignore: unused_element
  factory Flavor._() => _instance;

  Flavor.internal();

  static final Flavor _instance = Flavor.internal();

  static String? _baseUrl;
  void setFlavor(Enviroment enviroment) {
    switch (enviroment) {
      case Enviroment.LOCALHOST:
        _baseUrl = BaseUrl.local;
        break;
      case Enviroment.PROD:
        _baseUrl = BaseUrl.local;
        break;
      case Enviroment.DEV:
        _baseUrl = BaseUrl.local;
        break;
      case Enviroment.RENDER:
        _baseUrl = BaseUrl.render;
        break;
      case Enviroment.STAGE:
        _baseUrl = BaseUrl.stage;
    }
  }

  String get baseUrl {
    return _baseUrl!;
  }
}
