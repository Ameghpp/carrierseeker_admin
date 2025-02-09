import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_dropdownmenu.dart';
import '../stream/stream_bloc/stream_bloc.dart';
import 'courses_bloc/courses_bloc.dart';

class AddEditCourseStreamDialog extends StatefulWidget {
  final int courseId;
  const AddEditCourseStreamDialog({
    super.key,
    required this.courseId,
  });

  @override
  State<AddEditCourseStreamDialog> createState() =>
      _AddEditCourseStreamDialogState();
}

class _AddEditCourseStreamDialogState extends State<AddEditCourseStreamDialog> {
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
        builder: (context, courseState) {
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
                Logger().w(_streams);
                setState(() {});
              } else if (state is StreamSuccessState) {
                getStreams();
              }
            },
            builder: (context, state) {
              return CustomAlertDialog(
                title: 'Add Stream',
                isLoading: state is StreamLoadingState ||
                    courseState is CoursesLoadingState,
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
                        isLoading: state is StreamLoadingState ||
                            courseState is CoursesLoadingState,
                        controller: _refCenterController,
                        hintText: "Select Stream",
                        onSelected: (selected) {
                          _selectedStream = selected;
                          Logger().w(_selectedStream);
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
                    Logger().w(details);

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
