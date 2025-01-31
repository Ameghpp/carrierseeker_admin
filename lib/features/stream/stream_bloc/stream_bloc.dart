import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../values/strings.dart';

part 'stream_event.dart';
part 'stream_state.dart';

class StreamBloc extends Bloc<StreamEvent, StreamState> {
  StreamBloc() : super(StreamInitialState()) {
    on<StreamEvent>((event, emit) async {
      try {
        emit(StreamLoadingState());
        SupabaseQueryBuilder table = Supabase.instance.client.from('streams');

        if (event is GetAllStreamEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*');

          if (event.params['query'] != null) {
            query = query.ilike('name', '%${event.params['query']}%');
          }

          List<Map<String, dynamic>> streams =
              await query.order('name', ascending: true);

          emit(StreamGetSuccessState(streams: streams));
        } else if (event is AddStreamEvent) {
          await table.insert(event.streamDetails);

          emit(StreamSuccessState());
          // } else if (event is EditStreamEvent) {
          //   await table.update(event.streamDetails).eq('id', event.streamId);

          //   emit(StreamSuccessState());
        } else if (event is DeleteStreamEvent) {
          await table.delete().eq('id', event.streamId);
          emit(StreamSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(StreamFailureState());
      }
    });
  }
}
