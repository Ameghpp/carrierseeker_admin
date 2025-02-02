import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../values/strings.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitialState()) {
    on<DashboardEvent>((event, emit) async {
      try {
        emit(DashboardLoadingState());

        if (event is GetAllDashboardEvent) {
          Map<String, dynamic> dashboard = {};
          final data =
              await Supabase.instance.client.rpc("get_counts").select();
          dashboard = data[0];

          emit(DashboardGetSuccessState(dashboard: dashboard));
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(DashboardFailureState());
      }
    });
  }
}
