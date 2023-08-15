import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/call_history/call_history.dart';
import 'package:take_it_easy/modules/feedbacks/controller/feedback_controller.dart';
import 'package:take_it_easy/modules/feedbacks/conversational_feedbbacks.dart';
import 'package:take_it_easy/modules/feedbacks/services/feedback_service.dart';
import 'package:take_it_easy/modules/signin/view/signin.dart';
import 'package:take_it_easy/modules/calling/dialer.dart';
import 'package:take_it_easy/modules/home/home.dart';
import 'package:take_it_easy/modules/landing_page/landing_bloc/landing_page_bloc.dart';
import 'package:take_it_easy/modules/landing_page/landing_page.dart';
import 'package:take_it_easy/modules/static_page/static_page.dart';
import 'package:take_it_easy/rtc/signaling.i.dart';
import 'package:take_it_easy/storage/shared_storage.dart';
import 'package:take_it_easy/utils/string_utils.dart';
import 'package:take_it_easy/websocket/websocket.i.dart';

class Routes {
  Routes._();
  static const String root = '/';
  static const String videoCall = 'video_call';
  static const String voiceCall = 'voice_call';
  static const String createStreamData = 'CreateStreamData';
  static const String home = 'home';
  static const String auth = 'login';
  static const String landingPage = 'landing_page';
  static const String dialer = 'dialer';
  static const String staticPage = "static_page";
  static const String callHistory = "call_history";
  static const String feedbackList = "feedback_list";

  static onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case auth:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (BuildContext c) {
              return Login();
            });
      case home:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (BuildContext c) {
              return HomePage();
            });
      case auth:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (BuildContext c) {
              return Login();
            });

      case staticPage:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (BuildContext c) {
              return StaticPage(
                url: routeSettings.arguments.toString(),
              );
            });

      case callHistory:
        return MaterialPageRoute<dynamic>(builder: (BuildContext c) {
          return CallHistory();
        });
      case Routes.auth:
        return MaterialPageRoute<dynamic>(builder: (BuildContext c) {
          return Login();
        });
      case dialer:
        return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (BuildContext c) => Dialer(
                  signaling: DI.inject<SignalingI>(),
                  appWebSocket: DI.inject<AppWebSocket>(),
                ));
      case feedbackList:
        return MaterialPageRoute<dynamic>(builder: (BuildContext c) {
          return ChangeNotifierProvider<FeedbackController>(
              create: (c) => FeedbackController(FeedbackServiceImpl())..getFeedback(),
              builder: (BuildContext context, snapshot) {
                return ConversationalFeedback();
              });
        });
    }
  }

  static Map<String, Widget Function(BuildContext context)> getRoutes() => {
        Routes.home: (BuildContext C) => HomePage(),
        Routes.landingPage: (BuildContext c) => BlocProvider<LandingPageBloc>(
              create: (BuildContext c) => LandingPageBloc(),
              child: LandingPage(),
            )
      };

  static Future<String> get initialRoute async {
    final String route = await DI.inject<SharedStorage>().getInitialRoute();
    if (isNullOrEmpty(route)) {
      return auth;
    } else
      return route;
  }

  static Widget? getLandingPage() {
    return BlocProvider<LandingPageBloc>(
      create: (BuildContext c) => LandingPageBloc(),
      child: LandingPage(),
    );
  }
}
