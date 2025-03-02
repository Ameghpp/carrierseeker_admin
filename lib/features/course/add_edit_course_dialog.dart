import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common_widget/custom_image_picker_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_text_formfield.dart';
import '../../util/value_validator.dart';
import 'courses_bloc/courses_bloc.dart';

class AddEditCourseDialog extends StatefulWidget {
  final Map? courseDetails;
  const AddEditCourseDialog({
    super.key,
    this.courseDetails,
  });

  @override
  State<AddEditCourseDialog> createState() => _AddEditCourseDialogState();
}

class _AddEditCourseDialogState extends State<AddEditCourseDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PlatformFile? file;

  @override
  void initState() {
    if (widget.courseDetails != null) {
      _nameController.text = widget.courseDetails!['course_name'];
      _descriptionController.text = widget.courseDetails!['course_description'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesBloc, CoursesState>(
      listener: (context, state) {
        if (state is CoursesSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return CustomAlertDialog(
          title: widget.courseDetails == null ? 'Add Course' : 'Edit Course',
          isLoading: state is CoursesLoadingState,
          content: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Photo',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: const Color(0xFF2D2D2D),
                      ),
                ),
                const SizedBox(height: 5),
                CustomImagePickerButton(
                  selectedImage: widget.courseDetails?["photo_url"],
                  borderRadius: 8,
                  height: 100,
                  width: 360,
                  onPick: (value) {
                    file = value;
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Name',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: const Color(0xFF2D2D2D),
                      ),
                ),
                const SizedBox(height: 5),
                CustomTextFormField(
                  isLoading: state is CoursesLoadingState,
                  labelText: 'Name',
                  controller: _nameController,
                  validator: alphabeticWithSpaceValidator,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: const Color(0xFF2D2D2D),
                      ),
                ),
                const SizedBox(height: 5),
                CustomTextFormField(
                  isLoading: state is CoursesLoadingState,
                  minLines: 3,
                  maxLines: 3,
                  labelText: 'Description',
                  controller: _descriptionController,
                  validator: notEmptyValidator,
                ),
              ],
            ),
          ),
          primaryButton: 'Save',
          onPrimaryPressed: () {
            if (_formKey.currentState!.validate() &&
                ((file != null) || widget.courseDetails != null)) {
              Map<String, dynamic> details = {
                'course_name': _nameController.text.trim(),
                'course_description': _descriptionController.text.trim(),
              };

              if (file != null) {
                details['image'] = file!.bytes;
                details['image_name'] = file!.name;
              }

              if (widget.courseDetails != null) {
                BlocProvider.of<CoursesBloc>(context).add(
                  EditCourseEvent(
                    courseId: widget.courseDetails!['id'],
                    courseDetails: details,
                  ),
                );
              } else {
                BlocProvider.of<CoursesBloc>(context).add(
                  AddCourseEvent(
                    courseDetails: details,
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
