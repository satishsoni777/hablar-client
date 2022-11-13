import 'package:take_it_easy/utils/string_utils.dart';

enum Enviroment{LOCALHOST,PROD,DEV}

class Flavor{
    factory Flavor() => _instance;

  Flavor.internal();

  static final Flavor _instance = Flavor.internal();

  static String? _baseUrl;
  void setFlavor(Enviroment enviroment){
    switch(enviroment){
      case Enviroment.LOCALHOST:
      _baseUrl=BaseUrl.local;
    }
  }
  String get  baseUrl {
    return _baseUrl!;
  }
}
