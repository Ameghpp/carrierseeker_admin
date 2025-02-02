import 'package:flutter/material.dart';
import 'package:flutter_application_1/common_widget/custom_text_formfield.dart';
import 'package:flutter_application_1/features/collage/collages_bloc/collages_bloc.dart';
import 'package:flutter_application_1/util/value_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_dropdownmenu.dart';

class AddEditCollageCourseDialog extends StatefulWidget {
  final Map<String, dynamic>? collageCourseDetails;
  final List universities;
  final int collageId;
  const AddEditCollageCourseDialog({
    super.key,
    required this.collageId,
    this.collageCourseDetails,
    required this.universities,
  });

  @override
  State<AddEditCollageCourseDialog> createState() =>
      _AddEditCollageCourseDialogState();
}

class _AddEditCollageCourseDialogState
    extends State<AddEditCollageCourseDialog> {
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _feeStartController = TextEditingController();
  final TextEditingController _feeEndController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List _universities = [];
  int? _selectedCourse;
  Map<String, dynamic> courseParams = {
    'query': null,
  };

  @override
  void initState() {
    _universities = widget.universities;
    if (widget.collageCourseDetails != null) {
      _selectedCourse = widget.collageCourseDetails!['courses']['id'];
      _courseController.text =
          widget.collageCourseDetails!['courses']?['courses']?['course_name'];
      _feeStartController.text =
          widget.collageCourseDetails!['fee_range_start'].toString();
      _feeEndController.text =
          widget.collageCourseDetails!['fee_range_end'].toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CollagesBloc, CollagesState>(
      listener: (context, collageState) {
        if (collageState is CollagesSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return CustomAlertDialog(
          title: 'Add Course',
          isLoading: state is CollagesLoadingState,
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
                  initialSelection: _selectedCourse,
                  controller: _courseController,
                  hintText: "Select Course",
                  onSelected: (selected) {
                    _selectedCourse = selected;
                    Logger().w(_selectedCourse);
                  },
                  dropdownMenuEntries: List.generate(
                    _universities.length,
                    (index) => DropdownMenuEntry(
                      value: _universities[index]['id'],
                      label: _universities[index]['courses']['course_name'],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Fee Start',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: const Color(0xFF2D2D2D),
                      ),
                ),
                const SizedBox(height: 5),
                CustomTextFormField(
                  labelText: "Enter Fee Start",
                  controller: _feeStartController,
                  validator: numericValidator,
                ),
                const SizedBox(height: 15),
                Text(
                  'Fee StaEndrt',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: const Color(0xFF2D2D2D),
                      ),
                ),
                const SizedBox(height: 5),
                CustomTextFormField(
                  labelText: "Enter Fee End",
                  controller: _feeEndController,
                  validator: numericValidator,
                ),
              ],
            ),
          ),
          primaryButton: 'Save',
          onPrimaryPressed: () {
            if (_formKey.currentState!.validate() && _selectedCourse != null) {
              Map<String, dynamic> details = {
                'collage_id': widget.collageId,
                'university_course_id': _selectedCourse,
                'fee_range_end': _feeEndController.text.trim(),
                'fee_range_start': _feeStartController.text.trim(),
              };
              Logger().w(details);

              if (widget.collageCourseDetails != null) {
                BlocProvider.of<CollagesBloc>(context).add(
                  EditCollageCourseEvent(
                    collageCourseId: widget.collageCourseDetails!['id'],
                    collageCourseDetails: details,
                  ),
                );
              } else {
                BlocProvider.of<CollagesBloc>(context).add(
                  AddCollageCourseEvent(
                    collageCourseDetails: details,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}
