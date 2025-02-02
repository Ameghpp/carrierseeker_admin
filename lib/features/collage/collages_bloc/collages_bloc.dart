import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../util/file_upload.dart';
import '../../../values/strings.dart';

part 'collages_event.dart';
part 'collages_state.dart';

class CollagesBloc extends Bloc<CollagesEvent, CollagesState> {
  CollagesBloc() : super(CollagesInitialState()) {
    on<CollagesEvent>((event, emit) async {
      try {
        emit(CollagesLoadingState());
        SupabaseQueryBuilder table = Supabase.instance.client.from('collages');
        SupabaseQueryBuilder collageInterestTable =
            Supabase.instance.client.from('university_courses');
        if (event is GetAllCollagesEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*');

          if (event.params['query'] != null) {
            query = query.ilike('name', '%${event.params['query']}%');
          }
          if (event.params['id'] != null) {
            query = query.eq('university_id', event.params['id']);
          }

          List<Map<String, dynamic>> collages =
              await query.order('name', ascending: true);

          emit(CollagesGetSuccessState(collages: collages));
        } else if (event is AddCollageEvent) {
          event.collageDetails['cover_image'] = await uploadFile(
            'collages/cover_image',
            event.collageDetails['cover_image_file'],
            event.collageDetails['cover_image_name'],
          );
          event.collageDetails.remove('cover_image_file');
          event.collageDetails.remove('cover_image_name');

          await table.insert(event.collageDetails);

          emit(CollagesSuccessState());
        } else if (event is EditCollageEvent) {
          if (event.collageDetails['cover_image_file'] != null) {
            event.collageDetails['cover_image'] = await uploadFile(
              'collage/cover_image',
              event.collageDetails['cover_image_file'],
              event.collageDetails['cover_image_name'],
            );
            event.collageDetails.remove('cover_image_file');
            event.collageDetails.remove('cover_image_name');
          }

          await table.update(event.collageDetails).eq('id', event.collageId);

          emit(CollagesSuccessState());
        } else if (event is DeleteCollageEvent) {
          await table.delete().eq('id', event.collageId);
          emit(CollagesSuccessState());
        } else if (event is GetCollagesByIdEvent) {
          Map<String, dynamic> collageData = await table
              .select('''*,courses:university_courses(*)''')
              .eq('id', event.collageId)
              .single();
          emit(CollagesGetByIdSuccessState(collage: collageData));
        } else if (event is AddCollageCourseEvent) {
          await collageInterestTable.insert(event.collageCourseIds);
          emit(CollagesSuccessState());
        } else if (event is DeleteCollageCourseEvent) {
          await collageInterestTable.delete().eq('id', event.collageCourseId);
          emit(CollagesSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(CollagesFailureState());
      }
    });
  }
}
