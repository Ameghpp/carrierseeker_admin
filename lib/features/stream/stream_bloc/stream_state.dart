part of 'stream_bloc.dart';

@immutable
sealed class StreamState {}

final class StreamInitialState extends StreamState {}

final class StreamLoadingState extends StreamState {}

final class StreamSuccessState extends StreamState {}

final class StreamGetSuccessState extends StreamState {
  final List<Map<String, dynamic>> streams;

  StreamGetSuccessState({required this.streams});
}

final class StreamFailureState extends StreamState {
  final String message;

  StreamFailureState({this.message = apiErrorMessage});
}
