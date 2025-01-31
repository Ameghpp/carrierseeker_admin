import 'package:flutter/material.dart';
import 'package:flutter_application_1/common_widget/custom_chip.dart';
import 'package:flutter_application_1/common_widget/custom_search.dart';
import 'package:flutter_application_1/features/stream/add_stream_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_button.dart';
import '../../util/check_login.dart';
import 'stream_bloc/stream_bloc.dart';

class Streams extends StatefulWidget {
  const Streams({super.key});

  @override
  State<Streams> createState() => _StreamsState();
}

class _StreamsState extends State<Streams> {
  final StreamBloc _streamsBloc = StreamBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _streams = [];

  @override
  void initState() {
    checkLogin(context);
    getStream();
    super.initState();
  }

  void getStream() {
    _streamsBloc.add(GetAllStreamEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _streamsBloc,
      child: BlocConsumer<StreamBloc, StreamState>(
        listener: (context, state) {
          if (state is StreamFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getStream();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is StreamGetSuccessState) {
            _streams = state.streams;
            Logger().w(_streams);
            setState(() {});
          } else if (state is StreamSuccessState) {
            getStream();
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
                          "Stream",
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
                            getStream();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomButton(
                        label: "Add Stream",
                        iconData: Icons.add,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => BlocProvider.value(
                              value: _streamsBloc,
                              child: const AddEditStreamDialog(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (state is StreamLoadingState)
                    const Center(child: CircularProgressIndicator()),
                  if (_streams.isEmpty && state is! StreamLoadingState)
                    const Center(child: Text("No Stream Found")),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: List.generate(
                      _streams.length,
                      (index) => CustomChip(
                        name: _streams[index]['name'],
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              title: 'Delete Stream?',
                              description:
                                  'Are you sure you want to delete ${_streams[index]['name']}',
                              primaryButton: 'Delete',
                              onPrimaryPressed: () {
                                _streamsBloc.add(
                                  DeleteStreamEvent(
                                    streamId: _streams[index]['id'],
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
