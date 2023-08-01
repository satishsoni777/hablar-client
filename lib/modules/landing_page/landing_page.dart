// ignore_for_file: unnecessary_type_check

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_it_easy/components/loader_widget.dart';
import 'package:take_it_easy/modules/landing_page/landing_bloc/landing_page_bloc.dart';
import 'package:take_it_easy/navigation/navigation_manager.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<LandingPageBloc>(context).add(TokenValidate());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LandingPageBloc, LandingPageDateState>(
        listener: (curr, prev) {
          if (prev is LandingPageDateState) {
            final sate = prev;
            if (sate.isValidate) {
              NavigationManager.instance.pushReplacementNamed(Routes.home);
            } else {
              NavigationManager.instance.pushReplacementNamed(Routes.auth);
            }
          }
        },
        // buildWhen: (prev, curr) => true,
        builder: (context, state) {
          return ProgressLoader();
        },
      ),
    );
  }
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }
}

const FirebaseOptions android = FirebaseOptions(
  apiKey: 'xxxxxxxxxxxxxxxxxxx',
  appId: 'xxxxxxxxxxxxxxxxxxx',
  messagingSenderId: 'xxxxxxxxxxxxxxxxxxx',
  projectId: 'xxxxxxxxxxxxxxxxxxx',
  databaseURL: 'xxxxxxxxxxxxxxxxxxx',
  storageBucket: 'xxxxxxxxxxxxxxxxxxx',
);

const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'xxxxxxxxxxxxxxxxxxx',
  appId: 'xxxxxxxxxxxxxxxxxxx',
  messagingSenderId: 'xxxxxxxxxxxxxxxxxxx',
  projectId: 'xxxxxxxxxxxxxxxxxxx',
  databaseURL: 'xxxxxxxxxxxxxxxxxxx',
  storageBucket: 'xxxxxxxxxxxxxxxxxxx',
  androidClientId: 'xxxxxxxxxxxxxxxxxxx',
  iosClientId: 'xxxxxxxxxxxxxxxxxxx',
  iosBundleId: 'xxxxxxxxxxxxxxxxxxx',
);
