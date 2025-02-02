part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitialState extends DashboardState {}

final class DashboardLoadingState extends DashboardState {}

final class DashboardSuccessState extends DashboardState {}

final class DashboardGetSuccessState extends DashboardState {
  final Map<String, dynamic> dashboard;

  DashboardGetSuccessState({required this.dashboard});
}

final class DashboardFailureState extends DashboardState {
  final String message;

  DashboardFailureState({this.message = apiErrorMessage});
}
