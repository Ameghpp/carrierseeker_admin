part of 'collages_bloc.dart';

@immutable
sealed class CollagesEvent {}

class GetAllCollagesEvent extends CollagesEvent {
  final Map<String, dynamic> params;

  GetAllCollagesEvent({required this.params});
}

class GetCollagesByIdEvent extends CollagesEvent {
  final int collageId;

  GetCollagesByIdEvent({required this.collageId});
}

class AddCollageEvent extends CollagesEvent {
  final Map<String, dynamic> collageDetails;

  AddCollageEvent({required this.collageDetails});
}

class EditCollageEvent extends CollagesEvent {
  final Map<String, dynamic> collageDetails;
  final int collageId;

  EditCollageEvent({
    required this.collageDetails,
    required this.collageId,
  });
}

class DeleteCollageEvent extends CollagesEvent {
  final int collageId;

  DeleteCollageEvent({required this.collageId});
}

class AddCollageCourseEvent extends CollagesEvent {
  final Map<String, dynamic> collageCourseIds;

  AddCollageCourseEvent({
    required this.collageCourseIds,
  });
}

class DeleteCollageCourseEvent extends CollagesEvent {
  final int collageCourseId;

  DeleteCollageCourseEvent({required this.collageCourseId});
}
