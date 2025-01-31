part of 'courses_bloc.dart';

@immutable
sealed class CoursesEvent {}

class GetAllCoursesEvent extends CoursesEvent {
  final Map<String, dynamic> params;

  GetAllCoursesEvent({required this.params});
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
