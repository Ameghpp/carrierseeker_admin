import 'package:flutter/material.dart';
import 'package:flutter_application_1/common_widget/custom_chip.dart';
import 'package:flutter_application_1/common_widget/custom_search.dart';
import 'package:flutter_application_1/features/interests/add_edit_interest_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_button.dart';
import '../../util/check_login.dart';
import 'interests_bloc/interests_bloc.dart';

class Interests extends StatefulWidget {
  const Interests({super.key});

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  final InterestsBloc _interestsBloc = InterestsBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _interests = [];

  @override
  void initState() {
    checkLogin(context);
    getInterests();
    super.initState();
  }

  void getInterests() {
    _interestsBloc.add(GetAllInterestsEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _interestsBloc,
      child: BlocConsumer<InterestsBloc, InterestsState>(
        listener: (context, state) {
          if (state is InterestsFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getInterests();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is InterestsGetSuccessState) {
            _interests = state.interests;
            Logger().w(_interests);
            setState(() {});
          } else if (state is InterestsSuccessState) {
            getInterests();
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
                          "Interests",
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
                            getInterests();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomButton(
                        label: "Add Interests",
                        iconData: Icons.add,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => BlocProvider.value(
                              value: _interestsBloc,
                              child: const AddEditInterestDialog(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (state is InterestsLoadingState)
                    const Center(child: CircularProgressIndicator()),
                  if (_interests.isEmpty && state is! InterestsLoadingState)
                    const Center(child: Text("No Interests Found")),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: List.generate(
                      _interests.length,
                      (index) => CustomChip(
                        name: _interests[index]['name'],
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              title: 'Delete Interests?',
                              description:
                                  'Are you sure you want to delete ${_interests[index]['name']}',
                              primaryButton: 'Delete',
                              onPrimaryPressed: () {
                                _interestsBloc.add(
                                  DeleteInterestsEvent(
                                    interestId: _interests[index]['id'],
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              secondaryButton: 'Cancel',
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
