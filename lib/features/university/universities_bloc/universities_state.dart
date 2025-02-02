part of 'universities_bloc.dart';

@immutable
sealed class UniversitiesState {}

final class UniversitiesInitialState extends UniversitiesState {}

final class UniversitiesLoadingState extends UniversitiesState {}

final class UniversitiesSuccessState extends UniversitiesState {}

final class UniversitiesGetSuccessState extends UniversitiesState {
  final List<Map<String, dynamic>> universities;

  UniversitiesGetSuccessState({required this.universities});
}

final class UniversitiesGetByIdSuccessState extends UniversitiesState {
  final Map<String, dynamic> universities;

  UniversitiesGetByIdSuccessState({required this.universities});
}

final class UniversitiesFailureState extends UniversitiesState {
  final String message;

  UniversitiesFailureState({this.message = apiErrorMessage});
}
