import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_it_easy/components/loader_widget.dart';
import 'package:take_it_easy/modules/landing_page/landing_bloc/landing_page_bloc.dart';
import 'package:take_it_easy/navigation/routes.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    BlocProvider.of<LandingPageBloc>(context).add(TokenValidate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LandingPageBloc, LandingPageDateState>(
        listener: (curr, prev) {
          if (curr is LandingPageDateState) {
            final sate = curr as LandingPageDateState;
            if (sate.isValidate) {
              Navigator.pushReplacementNamed(context, Routes.home);
            } else {
              Navigator.pushReplacementNamed(context, Routes.auth);
            }
          }
        },
        buildWhen: (prev, curr) => false,
        builder: (context, state) {
          return ProgressLoader();
        },
      ),
    );
  }
}
