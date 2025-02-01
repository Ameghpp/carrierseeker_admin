import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/custom_chip.dart';
import '../../util/format_function.dart';
import 'add_edit_course_interest_dialog.dart';
import 'add_edit_course_stream_dialog.dart';
import 'courses_bloc/courses_bloc.dart';

class CourseDetailsScreen extends StatefulWidget {
  final int courseId;
  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final CoursesBloc _coursesBloc = CoursesBloc();

  Map<String, dynamic> _courseData = {};
  List _stream = [], _interest = [];

  @override
  void initState() {
    getCourses();
    super.initState();
  }

  void getCourses() {
    _coursesBloc.add(GetCoursesByIdEvent(courseId: widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
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
            } else if (state is CoursesGetByIdSuccessState) {
              _courseData = state.courses;
              _stream = state.courses['stream'];
              _interest = state.courses['interest'];
              Logger().w(_courseData);
              setState(() {});
            } else if (state is CoursesSuccessState) {
              getCourses();
            }
          },
          builder: (context, state) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1000,
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    if (state is CoursesLoadingState)
                      const LinearProgressIndicator(),
                    const SizedBox(
                      height: 20,
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(8),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_courseData['photo_url'] != null)
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: Image.network(
                                _courseData['photo_url'],
                                height: 400,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              formatValue(_courseData['course_name']),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              formatValue(_courseData['course_description']),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Interests",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                ),
                                CustomButton(
                                  label: "Add Interest",
                                  iconData: Icons.add,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => BlocProvider.value(
                                        value: _coursesBloc,
                                        child: AddEditCourseInterstDialog(
                                          courseId: widget.courseId,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            if (_interest.isNotEmpty)
                              const SizedBox(
                                height: 20,
                              ),
                            if (_interest.isNotEmpty)
                              Wrap(
                                children: List.generate(
                                  _interest.length,
                                  (index) => CustomChip(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => CustomAlertDialog(
                                          title: 'Delete Stream?',
                                          description:
                                              'Are you sure you want to delete ${_interest[index]?['name']?['name']}',
                                          primaryButton: 'Delete',
                                          onPrimaryPressed: () {
                                            _coursesBloc.add(
                                              DeleteCourseInterestEvent(
                                                courseInterestId:
                                                    _interest[index]['id'],
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                          secondaryButton: 'Cancel',
                                        ),
                                      );
                                    },
                                    name: formatValue(
                                        _interest[index]?['name']?['name']),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Streams",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                ),
                                CustomButton(
                                  label: "Add Stream",
                                  iconData: Icons.add,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => BlocProvider.value(
                                        value: _coursesBloc,
                                        child: AddEditCourseStreamDialog(
                                          courseId: widget.courseId,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            if (_stream.isNotEmpty)
                              const SizedBox(
                                height: 20,
                              ),
                            if (_stream.isNotEmpty)
                              Wrap(
                                children: List.generate(
                                  _stream.length,
                                  (index) => CustomChip(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => CustomAlertDialog(
                                          title: 'Delete Stream?',
                                          description:
                                              'Are you sure you want to delete ${_stream[index]?['name']?['name']}',
                                          primaryButton: 'Delete',
                                          onPrimaryPressed: () {
                                            _coursesBloc.add(
                                              DeleteCourseStreamEvent(
                                                courseStreamId: _stream[index]
                                                    ['id'],
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                          secondaryButton: 'Cancel',
                                        ),
                                      );
                                    },
                                    name: formatValue(
                                        _stream[index]?['name']?['name']),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
