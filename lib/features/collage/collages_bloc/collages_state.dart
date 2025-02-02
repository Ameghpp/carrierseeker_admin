part of 'collages_bloc.dart';

@immutable
sealed class CollagesState {}

final class CollagesInitialState extends CollagesState {}

final class CollagesLoadingState extends CollagesState {}

final class CollagesSuccessState extends CollagesState {}

final class CollagesGetSuccessState extends CollagesState {
  final List<Map<String, dynamic>> collages;

  CollagesGetSuccessState({required this.collages});
}

final class CollagesGetByIdSuccessState extends CollagesState {
  final Map<String, dynamic> collage;

  CollagesGetByIdSuccessState({required this.collage});
}

final class CollagesFailureState extends CollagesState {
  final String message;

  CollagesFailureState({this.message = apiErrorMessage});
}
