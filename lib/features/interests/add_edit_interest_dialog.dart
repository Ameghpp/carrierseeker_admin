import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_text_formfield.dart';
import '../../util/value_validator.dart';
import 'interests_bloc/interests_bloc.dart';

class AddEditInterestDialog extends StatefulWidget {
  const AddEditInterestDialog({
    super.key,
  });

  @override
  State<AddEditInterestDialog> createState() => _AddEditInterestDialogState();
}

class _AddEditInterestDialogState extends State<AddEditInterestDialog> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InterestsBloc, InterestsState>(
      listener: (context, state) {
        if (state is InterestsSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return CustomAlertDialog(
          title: 'Add Interest',
          isLoading: state is InterestsLoadingState,
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
                CustomTextFormField(
                  isLoading: state is InterestsLoadingState,
                  labelText: 'Name',
                  controller: _nameController,
                  validator: alphabeticWithSpaceValidator,
                  prefixIconData: Icons.shopping_bag,
                ),
              ],
            ),
          ),
          primaryButton: 'Save',
          onPrimaryPressed: () {
            if (_formKey.currentState!.validate()) {
              Map<String, dynamic> details = {
                'name': _nameController.text.trim(),
              };

              BlocProvider.of<InterestsBloc>(context).add(
                AddInterestsEvent(
                  interestDetails: details,
                ),
              );
            }
          },
        );
      },
    );
  }
}
