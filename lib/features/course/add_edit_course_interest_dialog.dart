import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/interests/interests_bloc/interests_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_dropdownmenu.dart';
import 'courses_bloc/courses_bloc.dart';

class AddEditCourseInterstDialog extends StatefulWidget {
  final int courseId;
  const AddEditCourseInterstDialog({
    super.key,
    required this.courseId,
  });

  @override
  State<AddEditCourseInterstDialog> createState() =>
      _AddEditCourseInterstDialogState();
}

class _AddEditCourseInterstDialogState
    extends State<AddEditCourseInterstDialog> {
  final TextEditingController _refCenterController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final InterestsBloc _interestBloc = InterestsBloc();
  Timer? _debounceStrem;
  List _interests = [];
  int? _selectedInterest;
  Map<String, dynamic> interestParams = {
    'limit': 5,
    'query': null,
  };

  @override
  void initState() {
    _refCenterController.addListener(() {
      if (_debounceStrem?.isActive ?? false) _debounceStrem?.cancel();
      _debounceStrem = Timer(const Duration(seconds: 1), () {
        interestParams['query'] = _refCenterController.text.trim();
        getInterests();
      });
    });
    super.initState();
  }

  void getInterests() {
    _interestBloc.add(GetAllInterestsEvent(params: interestParams));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _interestBloc,
      child: BlocConsumer<CoursesBloc, CoursesState>(
        listener: (context, courseState) {
          if (courseState is CoursesSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, courseState) {
          return BlocConsumer<InterestsBloc, InterestsState>(
            listener: (context, state) {
              if (state is InterestsFailureState) {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    title: 'Failure',
                    description: state.message,
                    primaryButton: 'Retry',
                    onPrimaryPressed: () {
                      getInterests();
                    },
                  ),
                );
              } else if (state is InterestsGetSuccessState) {
                _interests = state.interests;
                Logger().w(_interests);
                setState(() {});
              } else if (state is InterestsSuccessState) {
                getInterests();
              }
            },
            builder: (context, state) {
              return CustomAlertDialog(
                title: 'Add Interest',
                isLoading: state is InterestsLoadingState ||
                    courseState is CoursesLoadingState,
                content: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Interest Name',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: const Color(0xFF2D2D2D),
                            ),
                      ),
                      const SizedBox(height: 5),
                      CustomDropDownMenu(
                        controller: _refCenterController,
                        hintText: "Select Interest",
                        onSelected: (selected) {
                          _selectedInterest = selected;
                          Logger().w(_selectedInterest);
                        },
                        dropdownMenuEntries: List.generate(
                          _interests.length,
                          (index) => DropdownMenuEntry(
                            value: _interests[index]['id'],
                            label: _interests[index]['name'],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                primaryButton: 'Save',
                onPrimaryPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _selectedInterest != null) {
                    Map<String, dynamic> details = {
                      'course_id': widget.courseId,
                      'interest_id': _selectedInterest,
                    };
                    Logger().w(details);
                    BlocProvider.of<CoursesBloc>(context).add(
                      AddCourseInterestEvent(
                        courseInterestIds: details,
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
