import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/collage/collages_bloc/collages_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_dropdownmenu.dart';
import '../../common_widget/custom_image_picker_button.dart';
import '../../common_widget/custom_text_formfield.dart';
import '../../util/value_validator.dart';
import '../university/universities_bloc/universities_bloc.dart';

class AddEditCollageDialog extends StatefulWidget {
  final Map? collageDetails;
  final int? universitieId;

  const AddEditCollageDialog({
    super.key,
    this.collageDetails,
    this.universitieId,
  });

  @override
  State<AddEditCollageDialog> createState() => _AddEditCollageDialogState();
}

class _AddEditCollageDialogState extends State<AddEditCollageDialog> {
  final TextEditingController _universitieController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UniversitiesBloc _universitieBloc = UniversitiesBloc();

  PlatformFile? coverImage;
  List _universities = [];
  int? _selectedUniversitie;
  Map<String, dynamic> universitieParams = {
    'query': null,
  };

  @override
  void initState() {
    getUniversities();
    if (widget.collageDetails != null &&
        widget.collageDetails!['university'] != null) {
      _universitieController.text =
          widget.collageDetails!['university']['name'];
      _nameController.text = widget.collageDetails!['name'];
      _stateController.text = widget.collageDetails!['state'];
      _districtController.text = widget.collageDetails!['district'];
      _placeController.text = widget.collageDetails!['place'];
      _descriptionController.text = widget.collageDetails!['description'];
      _pincodeController.text = widget.collageDetails!['pincode'];
      _selectedUniversitie = widget.collageDetails!['university_id'];
    }
    if (widget.universitieId != null) {
      _selectedUniversitie = widget.universitieId;
    }
    super.initState();
  }

  void getUniversities() {
    _universitieBloc.add(GetAllUniversitiesEvent(params: universitieParams));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _universitieBloc,
      child: BlocConsumer<CollagesBloc, CollagesState>(
        listener: (context, collageState) {
          if (collageState is CollagesSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, collageState) {
          return BlocConsumer<UniversitiesBloc, UniversitiesState>(
            listener: (context, state) {
              if (state is UniversitiesFailureState) {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    title: 'Failure',
                    description: state.message,
                    primaryButton: 'Retry',
                    onPrimaryPressed: () {
                      getUniversities();
                    },
                  ),
                );
              } else if (state is UniversitiesGetSuccessState) {
                _universities = state.universities;
                Logger().w(_universities);
                setState(() {});
              } else if (state is UniversitiesSuccessState) {
                getUniversities();
              }
            },
            builder: (context, state) {
              return CustomAlertDialog(
                title: 'Add Universitie',
                isLoading: state is UniversitiesLoadingState ||
                    collageState is CollagesLoadingState,
                content: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        if (widget.universitieId == null)
                          Text(
                            'Universitie Name',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: const Color(0xFF2D2D2D),
                                ),
                          ),
                        if (widget.universitieId == null)
                          const SizedBox(height: 5),
                        if (widget.universitieId == null)
                          CustomDropDownMenu(
                            initialSelection: _selectedUniversitie,
                            controller: _universitieController,
                            hintText: "Select Universitie",
                            onSelected: (selected) {
                              _selectedUniversitie = selected;
                              Logger().w(_selectedUniversitie);
                            },
                            dropdownMenuEntries: List.generate(
                              _universities.length,
                              (index) => DropdownMenuEntry(
                                value: _universities[index]['id'],
                                label: _universities[index]['name'],
                              ),
                            ),
                          ),
                        if (widget.universitieId == null)
                          const SizedBox(height: 15),
                        Text(
                          'Cover Image',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: const Color(0xFF2D2D2D),
                                  ),
                        ),
                        const SizedBox(height: 5),
                        CustomImagePickerButton(
                          selectedImage: widget.collageDetails?["cover_page"],
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
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: const Color(0xFF2D2D2D),
                                  ),
                        ),
                        const SizedBox(height: 5),
                        CustomTextFormField(
                          labelText: 'Enter Name',
                          controller: _nameController,
                          validator: alphabeticWithSpaceValidator,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'state',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: const Color(0xFF2D2D2D),
                                  ),
                        ),
                        const SizedBox(height: 5),
                        CustomTextFormField(
                          labelText: 'Enter State',
                          controller: _stateController,
                          validator: alphabeticWithSpaceValidator,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'District',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: const Color(0xFF2D2D2D),
                                  ),
                        ),
                        const SizedBox(height: 5),
                        CustomTextFormField(
                          labelText: 'Enter District',
                          controller: _districtController,
                          validator: alphabeticWithSpaceValidator,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Place',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: const Color(0xFF2D2D2D),
                                  ),
                        ),
                        const SizedBox(height: 5),
                        CustomTextFormField(
                          labelText: 'Enter Place',
                          controller: _placeController,
                          validator: alphabeticWithSpaceValidator,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Pincode',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: const Color(0xFF2D2D2D),
                                  ),
                        ),
                        const SizedBox(height: 5),
                        CustomTextFormField(
                          labelText: 'Enter Pincode',
                          controller: _pincodeController,
                          validator: pincodeValidator,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Description',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: const Color(0xFF2D2D2D),
                                  ),
                        ),
                        const SizedBox(height: 5),
                        CustomTextFormField(
                          minLines: 3,
                          maxLines: 3,
                          labelText: 'Enter Description',
                          controller: _descriptionController,
                          validator: alphabeticWithSpaceValidator,
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
                      ((coverImage != null) || widget.collageDetails != null) &&
                      ((_selectedUniversitie != null))) {
                    Map<String, dynamic> details = {
                      'university_id': _selectedUniversitie,
                      'name': _nameController.text.trim(),
                      'state': _stateController.text.trim(),
                      'district': _districtController.text.trim(),
                      'place': _placeController.text.trim(),
                      'pincode': _pincodeController.text.trim(),
                      'description': _descriptionController.text.trim(),
                    };

                    if (coverImage != null) {
                      details['cover_image_file'] = coverImage!.bytes;
                      details['cover_image_name'] = coverImage!.name;
                    }

                    if (widget.collageDetails != null) {
                      BlocProvider.of<CollagesBloc>(context).add(
                        EditCollageEvent(
                          collageId: widget.collageDetails!['id'],
                          collageDetails: details,
                        ),
                      );
                    } else {
                      BlocProvider.of<CollagesBloc>(context).add(
                        AddCollageEvent(
                          collageDetails: details,
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
