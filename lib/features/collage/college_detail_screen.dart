import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/collage/add_edit_collage_course.dart';
import 'package:flutter_application_1/features/collage/collages_bloc/collages_bloc.dart';
import 'package:flutter_application_1/features/course/course_details_screen.dart';
import 'package:flutter_application_1/features/university/custom_university_course_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_button.dart';
import '../../util/format_function.dart';

class CollageDetailsScreen extends StatefulWidget {
  final int collageId;
  const CollageDetailsScreen({super.key, required this.collageId});

  @override
  State<CollageDetailsScreen> createState() => _CollageDetailsScreenState();
}

class _CollageDetailsScreenState extends State<CollageDetailsScreen> {
  final CollagesBloc _collagesBloc = CollagesBloc();

  Map<String, dynamic> _collageData = {};
  List _course = [];

  @override
  void initState() {
    getCollages();
    super.initState();
  }

  void getCollages() {
    _collagesBloc.add(GetCollagesByIdEvent(collageId: widget.collageId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: _collagesBloc,
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
            } else if (collageState is CollagesGetByIdSuccessState) {
              _collageData = collageState.collage;
              _course = _collageData['courses'];
              Logger().w(_collageData);
              setState(() {});
            } else if (collageState is CollagesSuccessState) {
              getCollages();
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
                    if (state is CollagesLoadingState)
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
                          if (_collageData['cover_page'] != null)
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: Image.network(
                                _collageData['cover_page'],
                                height: 400,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatValue(_collageData['name']),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Colors.black,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatAddress(_collageData),
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
                                        value: _collagesBloc,
                                        child: AddEditCollageCourseDialog(
                                          universities: _collageData[
                                              'university_courses'],
                                          collageId: widget.collageId,
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
                                runSpacing: 20,
                                spacing: 20,
                                children: List.generate(
                                  _course.length,
                                  (index) => CustomUniversityCourseCard(
                                    name: formatValue(_course[index]?['courses']
                                        ?['courses']?['course_name']),
                                    description: formatValue(_course[index]
                                            ?['courses']?['courses']
                                        ?['course_description']),
                                    image: formatValue(_course[index]
                                        ?['courses']?['courses']?['photo_url']),
                                    onEdit: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            BlocProvider.value(
                                          value: _collagesBloc,
                                          child: AddEditCollageCourseDialog(
                                            universities: _collageData[
                                                'university_courses'],
                                            collageId: widget.collageId,
                                            collageCourseDetails:
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
                                            feeRange: _course[index],
                                            syllabus: _course[index]
                                                ?['syllabus'],
                                            courseId: _course[index]?['courses']
                                                ?['courses']?['id'],
                                          ),
                                        ),
                                      );
                                    },
                                    onDelete: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => CustomAlertDialog(
                                          title: 'Delete Course?',
                                          description:
                                              'Are you sure you want to delete ${_course[index]?['courses']?['courses']?['course_name']}',
                                          primaryButton: 'Delete',
                                          onPrimaryPressed: () {
                                            _collagesBloc.add(
                                              DeleteCollageCourseEvent(
                                                collageCourseId: _course[index]
                                                    ['id'],
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
        ),
      ),
    );
  }
}
