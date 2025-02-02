import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../util/file_upload.dart';
import '../../../values/strings.dart';

part 'universities_event.dart';
part 'universities_state.dart';

class UniversitiesBloc extends Bloc<UniversitiesEvent, UniversitiesState> {
  UniversitiesBloc() : super(UniversitiesInitialState()) {
    on<UniversitiesEvent>((event, emit) async {
      try {
        emit(UniversitiesLoadingState());
        SupabaseQueryBuilder table =
            Supabase.instance.client.from('universities');
        SupabaseQueryBuilder universitieInterestTable =
            Supabase.instance.client.from('university_courses');
        if (event is GetAllUniversitiesEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*');

          if (event.params['query'] != null) {
            query = query.ilike('name', '%${event.params['query']}%');
          }

          List<Map<String, dynamic>> universities =
              await query.order('name', ascending: true);

          emit(UniversitiesGetSuccessState(universities: universities));
        } else if (event is AddUniversitieEvent) {
          event.universitieDetails['logo'] = await uploadFile(
            'universities/logo',
            event.universitieDetails['logo_file'],
            event.universitieDetails['logo_name'],
          );
          event.universitieDetails.remove('logo_file');
          event.universitieDetails.remove('logo_name');

          event.universitieDetails['cover_image'] = await uploadFile(
            'universities/cover_image',
            event.universitieDetails['cover_image_file'],
            event.universitieDetails['cover_image_name'],
          );
          event.universitieDetails.remove('cover_image_file');
          event.universitieDetails.remove('cover_image_name');

          await table.insert(event.universitieDetails);

          emit(UniversitiesSuccessState());
        } else if (event is EditUniversitieEvent) {
          if (event.universitieDetails['cover_image_file'] != null) {
            event.universitieDetails['cover_image'] = await uploadFile(
              'universitie/cover_image',
              event.universitieDetails['cover_image_file'],
              event.universitieDetails['cover_image_name'],
            );
            event.universitieDetails.remove('cover_image_file');
            event.universitieDetails.remove('cover_image_name');
          }

          if (event.universitieDetails['logo_file'] != null) {
            event.universitieDetails['logo'] = await uploadFile(
              'universitie/logo',
              event.universitieDetails['logo_file'],
              event.universitieDetails['logo_name'],
            );
            event.universitieDetails.remove('logo_file');
            event.universitieDetails.remove('logo_name');
          }

          await table
              .update(event.universitieDetails)
              .eq('id', event.universitieId);

          emit(UniversitiesSuccessState());
        } else if (event is DeleteUniversitieEvent) {
          await table.delete().eq('id', event.universitieId);
          emit(UniversitiesSuccessState());
        } else if (event is GetUniversitiesByIdEvent) {
          Map<String, dynamic> universitieData = await table
              .select(
                  '''*,courses:university_courses(*,courses:course_id(*))''')
              .eq('id', event.universitieId)
              .single();
          emit(UniversitiesGetByIdSuccessState(universities: universitieData));
        } else if (event is AddUniversitieCourseEvent) {
          await universitieInterestTable.insert(event.universitieCourseDetails);
          emit(UniversitiesSuccessState());
        } else if (event is EditUniversitieCourseEvent) {
          await universitieInterestTable
              .update(event.universitieCourseDetails)
              .eq('id', event.universitieCourseId);
          emit(UniversitiesSuccessState());
        } else if (event is DeleteUniversitieCourseEvent) {
          await universitieInterestTable
              .delete()
              .eq('id', event.universitieCourseId);
          emit(UniversitiesSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(UniversitiesFailureState());
      }
    });
  }
}
