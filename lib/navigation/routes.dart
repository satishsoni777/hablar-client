import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/signin/view/signin.dart';
import 'package:take_it_easy/modules/dialer/dialer.dart';
import 'package:take_it_easy/modules/home/home.dart';
import 'package:take_it_easy/modules/landing_page/landing_bloc/landing_page_bloc.dart';
import 'package:take_it_easy/modules/landing_page/landing_page.dart';
import 'package:take_it_easy/modules/video_call/video_call.dart';
import 'package:take_it_easy/modules/voice_call/voice_call.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/utils/string_utils.dart';

class Routes {
  static const root = '/';
  static const videoCall = '/video_call';
  static const voiceCall = '/voice_call';
  static const createStreamData = '/CreateStreamData';
  static const home = '/home';
  static const auth = '/login';
  static const landingPage = '/landing_page';
  static const dialer = '/dialer';

  static onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case root:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (c) {
              return BlocProvider<LandingPageBloc>(
                create: (c) => LandingPageBloc(),
                child: LandingPage(),
              );
            });
      case auth:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (c) {
              return Login();
            });
      case home:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (c) {
              return HomePage();
            });
      case auth:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (c) {
              return Login();
            });
      case dialer:
        return MaterialPageRoute(settings: routeSettings, builder: (c) => Dialer());
    }
  }

  static Map<String, Widget Function(BuildContext context)> getRoutes() => {
        Routes.voiceCall: (context) => VoiceCall(),
        Routes.videoCall: (context) => VideoCall(),
        Routes.auth: (C) => Login(),
        Routes.landingPage: (c) => BlocProvider<LandingPageBloc>(
              create: (c) => LandingPageBloc(),
              child: LandingPage(),
            )
      };

  static Future<String> get initialRoute async {
    final route = await DI.inject<SharedStorage>().getInitialRoute();
    if (isNullOrEmpty(route)) {
      return auth;
    } else
      return route;
  }

  static Widget? getLandingPage() {
    BlocProvider<LandingPageBloc>(
      create: (c) => LandingPageBloc(),
      child: LandingPage(),
    );
    return null;
  }
}
