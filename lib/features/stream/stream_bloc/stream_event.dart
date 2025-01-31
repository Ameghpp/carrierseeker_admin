part of 'stream_bloc.dart';

@immutable
sealed class StreamEvent {}

class GetAllStreamEvent extends StreamEvent {
  final Map<String, dynamic> params;

  GetAllStreamEvent({required this.params});
}

class AddStreamEvent extends StreamEvent {
  final Map<String, dynamic> streamDetails;

  AddStreamEvent({required this.streamDetails});
}

// class EditStreamEvent extends StreamEvent {
//   final Map<String, dynamic> streamDetails;
//   final int streamId;

//   EditStreamEvent({
//     required this.streamDetails,
//     required this.streamId,
//   });
// }

class DeleteStreamEvent extends StreamEvent {
  final int streamId;

  DeleteStreamEvent({required this.streamId});
}
