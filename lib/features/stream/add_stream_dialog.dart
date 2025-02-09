import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_text_formfield.dart';
import '../../util/value_validator.dart';
import 'stream_bloc/stream_bloc.dart';

class AddEditStreamDialog extends StatefulWidget {
  const AddEditStreamDialog({
    super.key,
  });

  @override
  State<AddEditStreamDialog> createState() => _AddEditStreamDialogState();
}

class _AddEditStreamDialogState extends State<AddEditStreamDialog> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StreamBloc, StreamState>(
      listener: (context, state) {
        if (state is StreamSuccessState) {
          Navigator.pop(context);
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
                CustomTextFormField(
                  isLoading: state is StreamLoadingState,
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

              BlocProvider.of<StreamBloc>(context).add(
                AddStreamEvent(
                  streamDetails: details,
                ),
              );
            }
          },
        );
      },
    );
  }
}
