import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../util/file_upload.dart';
import '../../../values/strings.dart';

part 'courses_event.dart';
part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  CoursesBloc() : super(CoursesInitialState()) {
    on<CoursesEvent>((event, emit) async {
      try {
        emit(CoursesLoadingState());
        SupabaseQueryBuilder table = Supabase.instance.client.from('courses');

        if (event is GetAllCoursesEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*');

          if (event.params['query'] != null) {
            query = query.ilike('course_name', '%${event.params['query']}%');
          }

          List<Map<String, dynamic>> courses =
              await query.order('course_name', ascending: true);

          emit(CoursesGetSuccessState(courses: courses));
        } else if (event is AddCourseEvent) {
          event.courseDetails['photo_url'] = await uploadFile(
            'course/photo',
            event.courseDetails['image'],
            event.courseDetails['image_name'],
          );
          event.courseDetails.remove('image');
          event.courseDetails.remove('image_name');

          await table.insert(event.courseDetails);

          emit(CoursesSuccessState());
        } else if (event is EditCourseEvent) {
          await table.update(event.courseDetails).eq('id', event.courseId);

          emit(CoursesSuccessState());
        } else if (event is DeleteCourseEvent) {
          await table.delete().eq('id', event.courseId);
          emit(CoursesSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(CoursesFailureState());
      }
    });
  }
}
