import 'package:flutter/material.dart';
import 'package:flutter_application_1/common_widget/custom_button.dart';
import 'package:flutter_application_1/features/university/add_edit_university_dialog.dart';
import 'package:flutter_application_1/features/university/university_detail_screen.dart';
import 'package:flutter_application_1/util/format_function.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_search.dart';
import '../../util/check_login.dart';
import 'custom_university_card.dart';
import 'universities_bloc/universities_bloc.dart';

class Universities extends StatefulWidget {
  const Universities({super.key});

  @override
  State<Universities> createState() => _UniversitiesState();
}

class _UniversitiesState extends State<Universities> {
  final UniversitiesBloc _universitiesBloc = UniversitiesBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _universities = [];

  @override
  void initState() {
    checkLogin(context);
    getUniversities();
    super.initState();
  }

  void getUniversities() {
    _universitiesBloc.add(GetAllUniversitiesEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _universitiesBloc,
      child: BlocConsumer<UniversitiesBloc, UniversitiesState>(
        listener: (context, state) {
          if (state is UniversitiesFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getUniversities();
                  Navigator.pop(context);
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
                          "Universities",
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
                            getUniversities();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomButton(
                        label: "Add Universitie",
                        iconData: Icons.add,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => BlocProvider.value(
                              value: _universitiesBloc,
                              child: const AddEditUniversitieDialog(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (state is UniversitiesLoadingState)
                    const Center(child: CircularProgressIndicator()),
                  if (_universities.isEmpty &&
                      state is! UniversitiesLoadingState)
                    const Center(child: Text("No Universitie Found")),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: List.generate(
                      _universities.length,
                      (index) => CustomUniversityCard(
                        address: formatAddress(_universities[index]),
                        coverImageUrl: _universities[index]['cover_image'],
                        name: formatValue(_universities[index]['name']),
                        logoUrl: _universities[index]["logo"],
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) => BlocProvider.value(
                              value: _universitiesBloc,
                              child: AddEditUniversitieDialog(
                                universitieDetails: _universities[index],
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              title: 'Delete Universitie?',
                              description:
                                  'Deletion will fail if there are records under this universitie',
                              primaryButton: 'Delete',
                              onPrimaryPressed: () {
                                _universitiesBloc.add(
                                  DeleteUniversitieEvent(
                                    universitieId: _universities[index]['id'],
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              secondaryButton: 'Cancel',
                            ),
                          );
                        },
                        onDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UniversitieDetailsScreen(
                                universitieId: _universities[index]['id'],
                              ),
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
