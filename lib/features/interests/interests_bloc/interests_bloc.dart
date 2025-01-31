import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../values/strings.dart';

part 'interests_event.dart';
part 'interests_state.dart';

class InterestsBloc extends Bloc<InterestsEvent, InterestsState> {
  InterestsBloc() : super(InterestsInitialState()) {
    on<InterestsEvent>((event, emit) async {
      try {
        emit(InterestsLoadingState());
        SupabaseQueryBuilder table = Supabase.instance.client.from('interests');

        if (event is GetAllInterestsEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*');

          if (event.params['query'] != null) {
            query = query.ilike('name', '%${event.params['query']}%');
          }
          if (event.params['limit'] != null) {
            await query.limit(event.params['limit']);
          }

          List<Map<String, dynamic>> interests =
              await query.order('name', ascending: true);

          emit(InterestsGetSuccessState(interests: interests));
        } else if (event is AddInterestsEvent) {
          await table.insert(event.interestDetails);

          emit(InterestsSuccessState());
          // } else if (event is EditInterestsEvent) {
          //   await table.update(event.interestDetails).eq('id', event.interestId);

          //   emit(InterestsSuccessState());
        } else if (event is DeleteInterestsEvent) {
          await table.delete().eq('id', event.interestId);
          emit(InterestsSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(InterestsFailureState());
      }
    });
  }
}
