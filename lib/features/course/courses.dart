import 'package:flutter/material.dart';
import 'package:flutter_application_1/common_widget/custom_search.dart';
import 'package:flutter_application_1/features/course/add_edit_course_dialog.dart';
import 'package:flutter_application_1/features/course/courses_bloc/courses_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_button.dart';
import '../../util/check_login.dart';
import 'custom_courses_card.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  final CoursesBloc _coursesBloc = CoursesBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _courses = [];

  @override
  void initState() {
    checkLogin(context);
    getCourses();
    super.initState();
  }

  void getCourses() {
    _coursesBloc.add(GetAllCoursesEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _coursesBloc,
      child: BlocConsumer<CoursesBloc, CoursesState>(
        listener: (context, state) {
          if (state is CoursesFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getCourses();
                  Navigator.pop(context);
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
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1320),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Courses",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: CustomSearch(
                          onSearch: (search) {
                            params['query'] = search;
                            getCourses();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomButton(
                        label: "Add Course",
                        iconData: Icons.add,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => BlocProvider.value(
                              value: _coursesBloc,
                              child: const AddEditCourseDialog(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (state is CoursesLoadingState)
                    const Center(child: CircularProgressIndicator()),
                  if (_courses.isEmpty && state is! CoursesLoadingState)
                    const Center(child: Text("No Course Found")),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: List.generate(
                      _courses.length,
                      (index) => CustomCourseCard(
                        image: _courses[index]['photo_url'],
                        name: _courses[index]['course_name'],
                        description: _courses[index]["course_description"],
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) => BlocProvider.value(
                              value: _coursesBloc,
                              child: AddEditCourseDialog(
                                courseDetails: _courses[index],
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              title: 'Delete Course?',
                              description:
                                  'Deletion will fail if there are records under this course',
                              primaryButton: 'Delete',
                              onPrimaryPressed: () {
                                _coursesBloc.add(
                                  DeleteCourseEvent(
                                    courseId: _courses[index]['id'],
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              secondaryButton: 'Cancel',
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
