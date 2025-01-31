part of 'courses_bloc.dart';

@immutable
sealed class CoursesState {}

final class CoursesInitialState extends CoursesState {}

final class CoursesLoadingState extends CoursesState {}

final class CoursesSuccessState extends CoursesState {}

final class CoursesGetSuccessState extends CoursesState {
  final List<Map<String, dynamic>> courses;

  CoursesGetSuccessState({required this.courses});
}

final class CoursesGetByIdSuccessState extends CoursesState {
  final Map<String, dynamic> courses;

  CoursesGetByIdSuccessState({required this.courses});
}

final class CoursesFailureState extends CoursesState {
  final String message;

  CoursesFailureState({this.message = apiErrorMessage});
}
