part of 'landing_page_bloc.dart';

@immutable
abstract class LandingPageEvent {}

class TokenValidate extends LandingPageEvent {
  TokenValidate({this.context});
  final BuildContext? context;
}
