part of 'interests_bloc.dart';

@immutable
sealed class InterestsEvent {}

class GetAllInterestsEvent extends InterestsEvent {
  final Map<String, dynamic> params;

  GetAllInterestsEvent({required this.params});
}

class AddInterestsEvent extends InterestsEvent {
  final Map<String, dynamic> interestDetails;

  AddInterestsEvent({required this.interestDetails});
}

// class EditInterestsEvent extends InterestsEvent {
//   final Map<String, dynamic> interestDetails;
//   final int interestId;

//   EditInterestsEvent({
//     required this.interestDetails,
//     required this.interestId,
//   });
// }

class DeleteInterestsEvent extends InterestsEvent {
  final int interestId;

  DeleteInterestsEvent({required this.interestId});
}
