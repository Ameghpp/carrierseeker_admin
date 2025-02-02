import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/collage/collages_bloc/collages_bloc.dart';
import 'package:flutter_application_1/features/course/course_details_screen.dart';
import 'package:flutter_application_1/features/university/add_edit_university_course.dart';
import 'package:flutter_application_1/features/university/custom_university_course_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/custom_chip.dart';
import '../../util/format_function.dart';
import 'universities_bloc/universities_bloc.dart';

class UniversitieDetailsScreen extends StatefulWidget {
  final int universitieId;
  const UniversitieDetailsScreen({super.key, required this.universitieId});

  @override
  State<UniversitieDetailsScreen> createState() =>
      _UniversitieDetailsScreenState();
}

class _UniversitieDetailsScreenState extends State<UniversitieDetailsScreen> {
  final UniversitiesBloc _universitiesBloc = UniversitiesBloc();
  final CollagesBloc _collagesBloc = CollagesBloc();

  Map<String, dynamic> _universitieData = {};
  List _course = [], _collages = [];

  @override
  void initState() {
    getUniversities();
    super.initState();
  }

  void getUniversities() {
    _universitiesBloc
        .add(GetUniversitiesByIdEvent(universitieId: widget.universitieId));
  }

  void getCollages() {
    _collagesBloc
        .add(GetAllCollagesEvent(params: {'id': widget.universitieId}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: _universitiesBloc,
          ),
          BlocProvider.value(
            value: _collagesBloc,
          ),
        ],
        child: BlocConsumer<CollagesBloc, CollagesState>(
          listener: (context, collageState) {
            if (collageState is CollagesFailureState) {
              showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                  title: 'Failure',
                  description: collageState.message,
                  primaryButton: 'Try Again',
                  onPrimaryPressed: () {
                    getCollages();
                    Navigator.pop(context);
                  },
                ),
              );
              //todo
            } else if (collageState is CollagesGetSuccessState) {
              _collages = collageState.collages;
              Logger().w(_collages);
              setState(() {});
            } else if (collageState is CollagesSuccessState) {
              getCollages();
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
                      primaryButton: 'Try Again',
                      onPrimaryPressed: () {
                        getUniversities();
                        Navigator.pop(context);
                      },
                    ),
                  );
                } else if (state is UniversitiesGetByIdSuccessState) {
                  _universitieData = state.universities;
                  _course = state.universities['courses'];
                  Logger().w(_universitieData);
                  setState(() {});
                } else if (state is UniversitiesSuccessState) {
                  getUniversities();
                }
              },
              builder: (context, state) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1000,
                    ),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        if (state is UniversitiesLoadingState)
                          const LinearProgressIndicator(),
                        const SizedBox(
                          height: 20,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(8),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_universitieData['cover_image'] != null)
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  child: Image.network(
                                    _universitieData['cover_image'],
                                    height: 400,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Row(
                                  children: [
                                    if (_universitieData['logo'] != null)
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            _universitieData['logo']),
                                        backgroundColor: Colors.grey[200],
                                      ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formatValue(_universitieData['name']),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          formatAddress(_universitieData),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[700],
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Collages",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: Colors.black,
                                            ),
                                      ),
                                    ),
                                    CustomButton(
                                      label: "Add Collage",
                                      iconData: Icons.add,
                                      onPressed: () {
                                        // showDialog(
                                        //   context: context,
                                        //   builder: (_) => BlocProvider.value(
                                        //     value: _universitiesBloc,
                                        //     child: AddEditUniversitieInterstDialog(
                                        //       universitieId: widget.universitieId,
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                    ),
                                  ],
                                ),
                                if (_collages.isNotEmpty)
                                  const SizedBox(
                                    height: 20,
                                  ),
                                if (_collages.isNotEmpty)
                                  Wrap(
                                    children: List.generate(
                                      _collages.length,
                                      (index) => CustomChip(
                                        onTap: () {
                                          // showDialog(
                                          //   context: context,
                                          //   builder: (context) => CustomAlertDialog(
                                          //     title: 'Delete Course?',
                                          //     description:
                                          //         'Are you sure you want to delete ${_collages[index]?['name']?['name']}',
                                          //     primaryButton: 'Delete',
                                          //     onPrimaryPressed: () {
                                          //       _universitiesBloc.add(
                                          //         DeleteUniversitieInterestEvent(
                                          //           universitieInterestId:
                                          //               _collages[index]['id'],
                                          //         ),
                                          //       );
                                          //       Navigator.pop(context);
                                          //     },
                                          //     secondaryButton: 'Cancel',
                                          //   ),
                                          // );
                                        },
                                        name: formatValue(
                                            _collages[index]?['name']?['name']),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Courses",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: Colors.black,
                                            ),
                                      ),
                                    ),
                                    CustomButton(
                                      label: "Add Course",
                                      iconData: Icons.add,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => BlocProvider.value(
                                            value: _universitiesBloc,
                                            child:
                                                AddEditUniversityCourseDialog(
                                              universitieId:
                                                  widget.universitieId,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                if (_course.isNotEmpty)
                                  const SizedBox(
                                    height: 20,
                                  ),
                                if (_course.isNotEmpty)
                                  Wrap(
                                    children: List.generate(
                                      _course.length,
                                      (index) => CustomUniversityCourseCard(
                                        name: formatValue(_course[index]
                                            ?['courses']?['course_name']),
                                        description: formatValue(_course[index]
                                                ?['courses']
                                            ?['course_description']),
                                        image: formatValue(_course[index]
                                            ?['courses']?['photo_url']),
                                        onEdit: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                BlocProvider.value(
                                              value: _universitiesBloc,
                                              child:
                                                  AddEditUniversityCourseDialog(
                                                universitieId:
                                                    widget.universitieId,
                                                universitieCourseDetails:
                                                    _course[index],
                                              ),
                                            ),
                                          );
                                        },
                                        onDetail: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CourseDetailsScreen(
                                                syllabus: _course[index]
                                                    ?['syllabus'],
                                                courseId: _course[index]
                                                    ?['courses']?['id'],
                                              ),
                                            ),
                                          );
                                        },
                                        onDelete: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CustomAlertDialog(
                                              title: 'Delete Course?',
                                              description:
                                                  'Are you sure you want to delete ${_course[index]?['courses']?['course_name']}',
                                              primaryButton: 'Delete',
                                              onPrimaryPressed: () {
                                                _universitiesBloc.add(
                                                  DeleteUniversitieCourseEvent(
                                                    universitieCourseId:
                                                        _course[index]['id'],
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
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
