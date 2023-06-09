import 'package:_imagineering_pack/extensions/extensions.dart';
import 'package:_imagineering_pack/setup/setup.dart';
import 'package:_imagineering_pack/widgets/widget_overlay_actions.dart';
import 'package:_imagineering_pack/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:agoralive/src/firestore_resources/constants.dart';
import 'package:agoralive/src/firestore_resources/instances.dart';
import 'package:agoralive/src/presentation/widgets/widget_fab_ani.dart';

import '../widgets/widget_popup_container.dart';
import '../widgets/widget_row_value.dart';
import '../widgets/widgets.dart';
import 'bloc/gallery_bloc.dart';
import 'widgets/widget_form_create.dart';

GalleryBloc get _bloc => Get.find<GalleryBloc>();

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _bloc.add(const FetchGalleryEvent(page: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: WidgetFABAni(
        shouldShow: true,
        animationDuration: const Duration(milliseconds: 250),
        fab: FloatingActionButton(
          heroTag: 'WidgetFormCreateLangs',
          backgroundColor: appColorPrimary,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                barrierDismissible: true,
                pageBuilder: (BuildContext context, _, __) {
                  return const WidgetFormCreateLangs();
                }));
          },
        ),
      ),
      body: BlocBuilder<GalleryBloc, GalleryState>(
          bloc: _bloc,
          builder: (context, state) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gallery",
                          style: w600TextStyle(fontSize: 28),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "${state.count} rows",
                          style: w400TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                kSpacingHeight32,
                Row(
                  children: [
                    SizedBox(
                      width: 280.0,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Type some thing...",
                          prefixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appColorPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Page:',
                      style: w400TextStyle(),
                    ),
                    kSpacingWidth4,
                    IconButton(
                      onPressed: state.page == 1
                          ? null
                          : () {
                              _bloc
                                  .add(FetchGalleryEvent(page: state.page - 1));
                            },
                      icon: Icon(
                        Icons.chevron_left_rounded,
                        color: state.page == 1 ? appColorElement : appColorText,
                      ),
                    ),
                    Text(
                      ' ${state.page} ',
                      style: w500TextStyle(),
                    ),
                    IconButton(
                      onPressed: state.page * state.limit >= state.count
                          ? null
                          : () {
                              _bloc
                                  .add(FetchGalleryEvent(page: state.page + 1));
                            },
                      icon: Icon(
                        Icons.chevron_right_rounded,
                        color: state.page * state.limit >= state.count
                            ? appColorElement
                            : appColorText,
                      ),
                    ),
                    kSpacingWidth12,
                    WidgetOverlayActions(
                      builder: (Widget child,
                          Size size,
                          Offset childPosition,
                          Offset? pointerPosition,
                          double animationValue,
                          Function hide) {
                        return Positioned(
                          right: MediaQuery.of(context).size.width -
                              childPosition.dx -
                              size.width,
                          top: childPosition.dy + size.height + 8,
                          child: WidgetPopupContainer(
                            alignmentTail: Alignment.topRight,
                            child: Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Material(
                                color: Colors.transparent,
                                child: Column(
                                  children: List.generate(
                                    5,
                                    (index) => InkWell(
                                      onTap: () {
                                        hide();
                                        _bloc.add(FetchGalleryEvent(
                                            page: 1, limit: (index + 1) * 10));
                                      },
                                      child: Ink(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        child: Row(
                                          children: [
                                            Text(
                                              '${(index + 1) * 10} items',
                                              style: w400TextStyle(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'Limit:',
                            style: w400TextStyle(),
                          ),
                          kSpacingWidth4,
                          Text(
                            '${state.limit} items',
                            style: w500TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                kSpacingHeight32,
                Expanded(
                  child: Column(
                    children: [
                      WidgetRowHeader(
                        child: Row(
                          children: const [
                            WidgetRowValue.label(flex: 1, value: kdb_mime),
                            WidgetRowValue.label(flex: 1, value: kdb_size),
                            WidgetRowValue.label(flex: 2, value: kdb_path),
                            WidgetRowValue.label(flex: 3, value: kdb_fileName),
                            WidgetRowValue.label(flex: 4, value: kdb_url),
                            WidgetRowValue.label(flex: 1, value: ''),
                          ],
                        ),
                      ),
                      kSpacingHeight20,
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: searchController,
                            builder: (context, value, child) {
                              String keyword = value.text;
                              List<QueryDocumentSnapshot<Map>> items =
                                  List.from((state.items ?? []).where((e) =>
                                      e
                                          .data()[kdb_languageName]
                                          .toString()
                                          .isContainsASCII(keyword) ||
                                      e
                                          .data()[kdb_languageCode]
                                          .toString()
                                          .isContainsASCII(keyword)));
                              return ListView.separated(
                                itemCount: items.length,
                                separatorBuilder: (context, index) => Container(
                                  height: .6,
                                  color: Colors.grey.shade200,
                                ),
                                itemBuilder: (_, index) {
                                  var e = items[index];

                                  return WidgetRowItem(
                                    key: ValueKey(e),
                                    child: Row(
                                      children: [
                                        WidgetRowValue(
                                          flex: 1,
                                          value: e.data()[kdb_mime],
                                        ),
                                        WidgetRowValue(
                                          flex: 1,
                                          value:
                                              '${e.data()[kdb_size] ~/ 1000}Kb',
                                        ),
                                        WidgetRowValue(
                                          flex: 2,
                                          value: e.data()[kdb_path],
                                        ),
                                        WidgetRowValue(
                                          flex: 3,
                                          value: e.data()[kdb_fileName],
                                        ),
                                        WidgetRowValue(
                                          flex: 4,
                                          value: e.data()[kdb_url],
                                        ),
                                        WidgetRowValue(
                                          flex: 1,
                                          value: WidgetDeleteButton(
                                            callback: () async {
                                              refByUrl(e.data()[kdb_url])
                                                  .delete();
                                              await colGallery
                                                  .doc('${e.data()[kdb_id]}')
                                                  .delete();
                                              _bloc.add(
                                                  const FetchGalleryEvent());
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
