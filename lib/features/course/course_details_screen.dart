import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/custom_chip.dart';
import '../../common_widget/custom_dropdownmenu.dart';
import '../../util/format_function.dart';
import '../stream/stream_bloc/stream_bloc.dart';
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
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_courseData['photo_url'] != null)
                      Image.network(
                        _courseData['photo_url'],
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatValue(_courseData['course_name']),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatValue(_courseData['course_description']),
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      children: [
                        CustomChip(
                          onTap: () {},
                          name: 'Data',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                                child: AddEditStreamDropDownDialog(
                                  courseId: widget.courseId,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      children: List.generate(
                        _stream.length,
                        (index) => CustomChip(
                          onTap: () {},
                          name: formatValue(_stream[index]?['name']?['name']),
                        ),
                      ),
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

class AddEditStreamDropDownDialog extends StatefulWidget {
  final int courseId;
  const AddEditStreamDropDownDialog({
    super.key,
    required this.courseId,
  });

  @override
  State<AddEditStreamDropDownDialog> createState() =>
      _AddEditStreamDropDownDialogState();
}

class _AddEditStreamDropDownDialogState
    extends State<AddEditStreamDropDownDialog> {
  final TextEditingController _refCenterController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final StreamBloc _streamBloc = StreamBloc();
  Timer? _debounceStrem;
  List _streams = [];
  int? _selectedStream;
  Map<String, dynamic> streamParams = {
    'limit': 5,
    'query': null,
  };

  @override
  void initState() {
    _refCenterController.addListener(() {
      if (_debounceStrem?.isActive ?? false) _debounceStrem?.cancel();
      _debounceStrem = Timer(const Duration(seconds: 1), () {
        streamParams['query'] = _refCenterController.text.trim();
        getStreams();
      });
    });
    super.initState();
  }

  void getStreams() {
    _streamBloc.add(GetAllStreamEvent(params: streamParams));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _streamBloc,
      child: BlocConsumer<CoursesBloc, CoursesState>(
        listener: (context, courseState) {
          if (courseState is CoursesSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return BlocConsumer<StreamBloc, StreamState>(
            listener: (context, state) {
              if (state is StreamFailureState) {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    title: 'Failure',
                    description: state.message,
                    primaryButton: 'Retry',
                    onPrimaryPressed: () {
                      getStreams();
                    },
                  ),
                );
              } else if (state is StreamGetSuccessState) {
                _streams = state.streams;
                setState(() {});
              } else if (state is StreamSuccessState) {
                getStreams();
              }
            },
            builder: (context, state) {
              return CustomAlertDialog(
                title: 'Add Stream',
                isLoading: state is StreamLoadingState,
                content: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stream Name',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: const Color(0xFF2D2D2D),
                            ),
                      ),
                      const SizedBox(height: 5),
                      CustomDropDownMenu(
                        controller: _refCenterController,
                        hintText: "Select center",
                        onSelected: (selected) {
                          _selectedStream = selected;
                        },
                        dropdownMenuEntries: List.generate(
                          _streams.length,
                          (index) => DropdownMenuEntry(
                            value: _streams[index]['id'],
                            label: _streams[index]['name'],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                primaryButton: 'Save',
                onPrimaryPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _selectedStream != null) {
                    Map<String, dynamic> details = {
                      'course_id': widget.courseId,
                      'stream_id': _selectedStream,
                    };

                    BlocProvider.of<CoursesBloc>(context).add(
                      AddCourseStreamEvent(
                        courseStreamIds: details,
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
