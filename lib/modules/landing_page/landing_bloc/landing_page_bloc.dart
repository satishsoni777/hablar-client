import 'dart:async';

// import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/landing_page/service/landing_repo.dart';
import 'package:take_it_easy/navigation/routes.dart';
import 'package:take_it_easy/resources/app_keys.dart';

part 'landing_page_event.dart';
part 'landing_page_state.dart';

class LandingPageBloc extends Bloc<LandingPageEvent, LandingPageDateState> {
  LandingPageBloc() : super(LandingPageDateState());
  final repo = DI.inject<LandingRepo>();
  @override
  Stream<LandingPageDateState> mapEventToState(
    LandingPageEvent event,
  ) async* {
    if (event is TokenValidate) {
      try {
        yield state.copyWith(isValidate: false, isLoading: true);
        final result = await repo.isSignIn();
        yield state.copyWith(isLoading: false, isValidate: result);
      } catch (e) {
        yield state.copyWith(isLoading: false, isValidate: false);
      }
    }
    // TODO: implement mapEventToState
  }
}
