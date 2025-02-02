import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common_widget/custom_image_picker_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_text_formfield.dart';
import '../../util/value_validator.dart';
import 'universities_bloc/universities_bloc.dart';

class AddEditUniversitieDialog extends StatefulWidget {
  final Map? universitieDetails;
  const AddEditUniversitieDialog({
    super.key,
    this.universitieDetails,
  });

  @override
  State<AddEditUniversitieDialog> createState() =>
      _AddEditUniversitieDialogState();
}

class _AddEditUniversitieDialogState extends State<AddEditUniversitieDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PlatformFile? coverImage, logo;

  @override
  void initState() {
    if (widget.universitieDetails != null) {
      _nameController.text = widget.universitieDetails!['name'];
      _stateController.text = widget.universitieDetails!['state'];
      _districtController.text = widget.universitieDetails!['district'];
      _placeController.text = widget.universitieDetails!['place'];
      _addressController.text = widget.universitieDetails!['address'];
      _pincodeController.text = widget.universitieDetails!['pincode'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UniversitiesBloc, UniversitiesState>(
      listener: (context, state) {
        if (state is UniversitiesSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return CustomAlertDialog(
          title: widget.universitieDetails == null
              ? 'Add Universitie'
              : 'Edit Universitie',
          isLoading: state is UniversitiesLoadingState,
          content: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    'Logo',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFF2D2D2D),
                        ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: CustomImagePickerButton(
                      selectedImage: widget.universitieDetails?["logo"],
                      borderRadius: 8,
                      height: 100,
                      width: 100,
                      onPick: (value) {
                        logo = value;
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Cover Image',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFF2D2D2D),
                        ),
                  ),
                  const SizedBox(height: 5),
                  CustomImagePickerButton(
                    selectedImage: widget.universitieDetails?["cover_image"],
                    borderRadius: 8,
                    height: 100,
                    width: 360,
                    onPick: (value) {
                      coverImage = value;
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
                    labelText: 'Enter Name',
                    controller: _nameController,
                    validator: alphabeticWithSpaceValidator,
                    prefixIconData: Icons.shopping_bag,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'state',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFF2D2D2D),
                        ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    labelText: 'Enter State',
                    controller: _stateController,
                    validator: alphabeticWithSpaceValidator,
                    prefixIconData: Icons.shopping_bag,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'District',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFF2D2D2D),
                        ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    labelText: 'Enter District',
                    controller: _districtController,
                    validator: alphabeticWithSpaceValidator,
                    prefixIconData: Icons.shopping_bag,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Place',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFF2D2D2D),
                        ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    labelText: 'Enter Place',
                    controller: _placeController,
                    validator: alphabeticWithSpaceValidator,
                    prefixIconData: Icons.shopping_bag,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Pincode',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFF2D2D2D),
                        ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    labelText: 'Enter Pincode',
                    controller: _pincodeController,
                    validator: pincodeValidator,
                    prefixIconData: Icons.shopping_bag,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Address',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFF2D2D2D),
                        ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    labelText: 'Enter Address',
                    controller: _addressController,
                    validator: alphabeticWithSpaceValidator,
                    prefixIconData: Icons.shopping_bag,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
          primaryButton: 'Save',
          onPrimaryPressed: () {
            if (_formKey.currentState!.validate() &&
                ((logo != null && coverImage != null) ||
                    widget.universitieDetails != null)) {
              Map<String, dynamic> details = {
                'name': _nameController.text.trim(),
                'state': _stateController.text.trim(),
                'district': _districtController.text.trim(),
                'place': _placeController.text.trim(),
                'pincode': _pincodeController.text.trim(),
                'address': _addressController.text.trim(),
              };

              if (logo != null) {
                details['logo_file'] = logo!.bytes;
                details['logo_name'] = logo!.name;
              }
              if (coverImage != null) {
                details['cover_image_file'] = coverImage!.bytes;
                details['cover_image_name'] = coverImage!.name;
              }

              if (widget.universitieDetails != null) {
                BlocProvider.of<UniversitiesBloc>(context).add(
                  EditUniversitieEvent(
                    universitieId: widget.universitieDetails!['id'],
                    universitieDetails: details,
                  ),
                );
              } else {
                BlocProvider.of<UniversitiesBloc>(context).add(
                  AddUniversitieEvent(
                    universitieDetails: details,
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
