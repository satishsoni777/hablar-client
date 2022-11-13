import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_it_easy/components/loader_widget.dart';
import 'package:take_it_easy/modules/authentication/view/auth.dart';
import 'package:take_it_easy/modules/home/home.dart';
import 'package:take_it_easy/modules/landing_page/landing_bloc/landing_page_bloc.dart';

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
        listener: (curr, prev) {},
        buildWhen: (prev, curr) => curr is LandingPageDateState,
        builder: (context, state) {
          if (state.isLoading) return ProgressLoader();
          if (state.isValidate)
            return HomePage();
          else
            return Authentication();
        },
      ),
    );
  }
}
