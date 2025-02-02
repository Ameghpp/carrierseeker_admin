part of 'universities_bloc.dart';

@immutable
sealed class UniversitiesEvent {}

class GetAllUniversitiesEvent extends UniversitiesEvent {
  final Map<String, dynamic> params;

  GetAllUniversitiesEvent({required this.params});
}

class GetUniversitiesByIdEvent extends UniversitiesEvent {
  final int universitieId;

  GetUniversitiesByIdEvent({required this.universitieId});
}

class AddUniversitieEvent extends UniversitiesEvent {
  final Map<String, dynamic> universitieDetails;

  AddUniversitieEvent({required this.universitieDetails});
}

class EditUniversitieEvent extends UniversitiesEvent {
  final Map<String, dynamic> universitieDetails;
  final int universitieId;

  EditUniversitieEvent({
    required this.universitieDetails,
    required this.universitieId,
  });
}

class DeleteUniversitieEvent extends UniversitiesEvent {
  final int universitieId;

  DeleteUniversitieEvent({required this.universitieId});
}

class AddUniversitieCourseEvent extends UniversitiesEvent {
  final Map<String, dynamic> universitieCourseDetails;

  AddUniversitieCourseEvent({
    required this.universitieCourseDetails,
  });
}

class EditUniversitieCourseEvent extends UniversitiesEvent {
  final Map<String, dynamic> universitieCourseDetails;
  final int universitieCourseId;

  EditUniversitieCourseEvent({
    required this.universitieCourseDetails,
    required this.universitieCourseId,
  });
}

class DeleteUniversitieCourseEvent extends UniversitiesEvent {
  final int universitieCourseId;

  DeleteUniversitieCourseEvent({required this.universitieCourseId});
}
