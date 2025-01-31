part of 'interests_bloc.dart';

@immutable
sealed class InterestsState {}

final class InterestsInitialState extends InterestsState {}

final class InterestsLoadingState extends InterestsState {}

final class InterestsSuccessState extends InterestsState {}

final class InterestsGetSuccessState extends InterestsState {
  final List<Map<String, dynamic>> interests;

  InterestsGetSuccessState({required this.interests});
}

final class InterestsFailureState extends InterestsState {
  final String message;

  InterestsFailureState({this.message = apiErrorMessage});
}
