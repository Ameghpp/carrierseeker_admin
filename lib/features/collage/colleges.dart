import 'package:flutter/material.dart';
import 'package:flutter_application_1/common_widget/custom_search.dart';
import 'package:flutter_application_1/features/collage/add_edit_collage_dialog.dart';
import 'package:flutter_application_1/features/collage/college_detail_screen.dart';
import 'package:flutter_application_1/features/collage/custom_collage_card.dart';
import 'package:flutter_application_1/util/format_function.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_button.dart';
import '../../util/check_login.dart';
import 'collages_bloc/collages_bloc.dart';

class Collages extends StatefulWidget {
  const Collages({super.key});

  @override
  State<Collages> createState() => _CollagesState();
}

class _CollagesState extends State<Collages> {
  final CollagesBloc _collagesBloc = CollagesBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _collages = [];

  @override
  void initState() {
    checkLogin(context);
    getCollages();
    super.initState();
  }

  void getCollages() {
    _collagesBloc.add(GetAllCollagesEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _collagesBloc,
      child: BlocConsumer<CollagesBloc, CollagesState>(
        listener: (context, state) {
          if (state is CollagesFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getCollages();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is CollagesGetSuccessState) {
            _collages = state.collages;
            Logger().w(_collages);
            setState(() {});
          } else if (state is CollagesSuccessState) {
            getCollages();
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
                          "Collages",
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
                            getCollages();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomButton(
                        label: "Add Collage",
                        iconData: Icons.add,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => BlocProvider.value(
                              value: _collagesBloc,
                              child: const AddEditCollageDialog(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (state is CollagesLoadingState)
                    const Center(child: CircularProgressIndicator()),
                  if (_collages.isEmpty && state is! CollagesLoadingState)
                    const Center(child: Text("No Collage Found")),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: List.generate(
                      _collages.length,
                      (index) => CustomCollageCard(
                        coverImageUrl: _collages[index]['cover_page'],
                        name: _collages[index]['name'],
                        address: formatAddress(_collages[index]),
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) => BlocProvider.value(
                              value: _collagesBloc,
                              child: AddEditCollageDialog(
                                collageDetails: _collages[index],
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              title: 'Delete Collage?',
                              description:
                                  'Deletion will fail if there are records under this collage',
                              primaryButton: 'Delete',
                              onPrimaryPressed: () {
                                _collagesBloc.add(
                                  DeleteCollageEvent(
                                    collageId: _collages[index]['id'],
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
                              builder: (context) => CollageDetailsScreen(
                                collageId: _collages[index]['id'],
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
