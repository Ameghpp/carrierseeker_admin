part of 'courses_bloc.dart';

@immutable
sealed class CoursesEvent {}

class GetAllCoursesEvent extends CoursesEvent {
  final Map<String, dynamic> params;

  GetAllCoursesEvent({required this.params});
}

class GetCoursesByIdEvent extends CoursesEvent {
  final int courseId;

  GetCoursesByIdEvent({required this.courseId});
}

class AddCourseEvent extends CoursesEvent {
  final Map<String, dynamic> courseDetails;

  AddCourseEvent({required this.courseDetails});
}

class EditCourseEvent extends CoursesEvent {
  final Map<String, dynamic> courseDetails;
  final int courseId;

  EditCourseEvent({
    required this.courseDetails,
    required this.courseId,
  });
}

class DeleteCourseEvent extends CoursesEvent {
  final int courseId;

  DeleteCourseEvent({required this.courseId});
}

class AddCourseStreamEvent extends CoursesEvent {
  final Map<String, dynamic> courseStreamIds;

  AddCourseStreamEvent({
    required this.courseStreamIds,
  });
}

class DeleteCourseStreamEvent extends CoursesEvent {
  final int courseStreamId;

  DeleteCourseStreamEvent({required this.courseStreamId});
}

class AddCourseInterestEvent extends CoursesEvent {
  final Map<String, dynamic> courseInterestIds;

  AddCourseInterestEvent({
    required this.courseInterestIds,
  });
}

class DeleteCourseInterestEvent extends CoursesEvent {
  final int courseInterestId;

  DeleteCourseInterestEvent({required this.courseInterestId});
}
