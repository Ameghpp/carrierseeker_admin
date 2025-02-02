import 'package:flutter/material.dart';
import 'package:flutter_application_1/common_widget/custom_text_formfield.dart';
import 'package:flutter_application_1/features/university/universities_bloc/universities_bloc.dart';
import 'package:flutter_application_1/util/value_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_dropdownmenu.dart';
import '../course/courses_bloc/courses_bloc.dart';

class AddEditUniversityCourseDialog extends StatefulWidget {
  final Map<String, dynamic>? universitieCourseDetails;
  final int universitieId;
  const AddEditUniversityCourseDialog({
    super.key,
    required this.universitieId,
    this.universitieCourseDetails,
  });

  @override
  State<AddEditUniversityCourseDialog> createState() =>
      _AddEditUniversityCourseDialogState();
}

class _AddEditUniversityCourseDialogState
    extends State<AddEditUniversityCourseDialog> {
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _syllubusController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CoursesBloc _courseBloc = CoursesBloc();

  List _courses = [];
  int? _selectedCourse;
  Map<String, dynamic> courseParams = {
    'query': null,
  };

  @override
  void initState() {
    getCourses();
    if (widget.universitieCourseDetails != null &&
        widget.universitieCourseDetails!['courses'] != null) {
      _courseController.text =
          widget.universitieCourseDetails!['courses']?['course_name'];
      _syllubusController.text = widget.universitieCourseDetails!['syllabus'];
    }
    super.initState();
  }

  void getCourses() {
    _courseBloc.add(GetAllCoursesEvent(params: courseParams));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _courseBloc,
      child: BlocConsumer<UniversitiesBloc, UniversitiesState>(
        listener: (context, universitieState) {
          if (universitieState is UniversitiesSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, universitieState) {
          return BlocConsumer<CoursesBloc, CoursesState>(
            listener: (context, state) {
              if (state is CoursesFailureState) {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    title: 'Failure',
                    description: state.message,
                    primaryButton: 'Retry',
                    onPrimaryPressed: () {
                      getCourses();
                    },
                  ),
                );
              } else if (state is CoursesGetSuccessState) {
                _courses = state.courses;
                Logger().w(_courses);
                setState(() {});
              } else if (state is CoursesSuccessState) {
                getCourses();
              }
            },
            builder: (context, state) {
              return CustomAlertDialog(
                title: 'Add Course',
                isLoading: state is CoursesLoadingState ||
                    universitieState is UniversitiesLoadingState,
                content: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Course Name',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: const Color(0xFF2D2D2D),
                            ),
                      ),
                      const SizedBox(height: 5),
                      CustomDropDownMenu(
                        controller: _courseController,
                        hintText: "Select Course",
                        onSelected: (selected) {
                          _selectedCourse = selected;
                          Logger().w(_selectedCourse);
                        },
                        dropdownMenuEntries: List.generate(
                          _courses.length,
                          (index) => DropdownMenuEntry(
                            value: _courses[index]['id'],
                            label: _courses[index]['course_name'],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Syllabus',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: const Color(0xFF2D2D2D),
                            ),
                      ),
                      const SizedBox(height: 5),
                      CustomTextFormField(
                        minLines: 3,
                        maxLines: 3,
                        labelText: "Enter Syllabus",
                        controller: _syllubusController,
                        validator: notEmptyValidator,
                      ),
                    ],
                  ),
                ),
                primaryButton: 'Save',
                onPrimaryPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _selectedCourse != null) {
                    Map<String, dynamic> details = {
                      'university_id': widget.universitieId,
                      'course_id': _selectedCourse,
                      'syllabus': _syllubusController.text.trim(),
                    };
                    Logger().w(details);

                    if (widget.universitieCourseDetails != null) {
                      BlocProvider.of<UniversitiesBloc>(context).add(
                        EditUniversitieCourseEvent(
                          universitieCourseId:
                              widget.universitieCourseDetails!['id'],
                          universitieCourseDetails: details,
                        ),
                      );
                    } else {
                      BlocProvider.of<UniversitiesBloc>(context).add(
                        AddUniversitieCourseEvent(
                          universitieCourseDetails: details,
                        ),
                      );
                    }
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
