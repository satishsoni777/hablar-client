part of 'landing_page_bloc.dart';

abstract class LandinPageState {}

@immutable
class LandingPageDateState {
  LandingPageDateState({this.isValidate = false, this.isLoading = false});
  final bool isValidate;
  final bool isLoading;
  LandingPageDateState copyWith({bool? isLoading, bool? isValidate}) {
    return LandingPageDateState(isValidate: isValidate!, isLoading: isLoading ?? this.isLoading);
  }

  @override
  // TODO: implement props
  List<Object> get props => [
        isValidate
      ];
}
