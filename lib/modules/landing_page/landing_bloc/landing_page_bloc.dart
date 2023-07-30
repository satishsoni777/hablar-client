import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/modules/landing_page/service/landing_repo.dart';
import 'package:take_it_easy/modules/signin/model/gmail_user_data.dart';
import 'package:take_it_easy/storage/shared_storage.dart';

part 'landing_page_event.dart';
part 'landing_page_state.dart';

class LandingPageBloc extends Bloc<LandingPageEvent, LandingPageDateState> {
  LandingPageBloc(
    this.repo, {
    required this.sharedStorage,
  }) : super(LandingPageDateState());
  final LandingRepo repo;
  final SharedStorage sharedStorage;
  @override
  Stream<LandingPageDateState> mapEventToState(
    LandingPageEvent event,
  ) async* {
    if (event is TokenValidate) {
      try {
        yield state.copyWith(isValidate: false, isLoading: true);
        final bool result = await repo.isSignIn();
        if (result) {
          final user = DI.inject<UserData>();
          final userData = await sharedStorage.getUserData();
          user.copy(userData);
        }
        yield state.copyWith(isLoading: false, isValidate: result);
      } catch (e) {
        yield state.copyWith(isLoading: false, isValidate: false);
      }
    }
  }
}
