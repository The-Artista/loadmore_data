import 'dart:async';

import 'package:flutter/material.dart';

/// [LoadMoreListData] is the main, and and only widget you need to
/// archive pagination
class LoadMoreListData<T> extends StatefulWidget {
  /// [LoadMoreListData] is the main, and and only widget you need to
  /// archive pagination
  const LoadMoreListData({
    super.key,
    required this.onInit,
    required this.builder,
    required this.onLoad,
    this.padding,
    this.onInitialLoading,
    this.onLoadMoreLoading,
    this.topWidget,
    this.bottomWidget,
    this.onNoData,
    this.itemPadding,
    this.initPage = 1,
  });

  ///  [onInit] is a required argument for the [LoadMoreListData] widget.
  ///  It takes a function that will return [OnInit]
  /// [OnInit] can be `FutureOr<Iterable<T>>`
  /// This function will call on `initState` of [LoadMoreListData]'s life cycle
  final OnInit<T> onInit;

  /// [onLoad] is a required argument for the [LoadMoreListData] widget.
  /// It takes a function that will return [OnLoad]
  /// [OnLoad] can be `FutureOr<Iterable<T>>`
  /// This function will call when the user reached to
  /// the end of the list of data
  final OnLoad<T> onLoad;

  /// [onInitialLoading] is a widget that will display until
  /// the initial data is loaded
  final Widget? onInitialLoading;

  /// [onLoadMoreLoading] is a widget at end of the list that will display
  /// when waiting for a response on a pagination API request
  final Widget? onLoadMoreLoading;

  /// [onNoData] is a widget that will have no more data to display
  final Widget? onNoData;

  /// you can pass an additional widget that will display on top of the list
  final Widget? topWidget;

  /// you can pass an additional widget that will display on the bottom of
  /// the list
  final Widget? bottomWidget;

  /// [initPage] will take a [int] value representing the initial
  /// circle of requests.
  final int? initPage;

  /// padding for [LoadMoreListData] widget
  final EdgeInsetsGeometry? padding;

  /// padding for [LoadMoreListData] widget's items

  final EdgeInsetsGeometry? itemPadding;

  /// builder will [BuildContext] and `itemData` as a single item.
  /// and it will expect a widget that will represent a single item
  final ItemBuilder<T> builder;

  @override
  State<LoadMoreListData<T>> createState() => _LoadMoreListDataState<T>();
}

class _LoadMoreListDataState<T> extends State<LoadMoreListData<T>> {
  final scrollController = ScrollController();
  bool isLoading = false;
  late ValueNotifier<Iterable<T>> data = ValueNotifier([]);
  int index = 0;
  bool isInitData = false;
  bool isNoData = false;

  Future<void> initData() async {
    data.value = await widget.onInit();
    setState(() {
      isInitData = true;
    });
  }

  @override
  void initState() {
    initData();
    setState(() {
      index = widget.initPage != null ? widget.initPage! + 1 : 2;
    });
    scrollController.addListener(() async {
      if (isNoData == false) {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          setState(() {
            isLoading = true;
          });
          final newData = await widget.onLoad(index++);
          if (newData == null || newData.isEmpty) {
            setState(() {
              isNoData = true;
            });
          } else {
            setState(() {
              index = index++;
            });
            data.value = [...data.value, ...newData];
          }
          setState(() {
            isLoading = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      children: [
        if (isInitData == false) widget.onInitialLoading ?? const SizedBox(),
        widget.topWidget ?? const SizedBox(),
        ValueListenableBuilder(
          valueListenable: data,
          builder: (context, value, child) {
            return ListView.builder(
              padding: widget.padding,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: widget.itemPadding ?? EdgeInsets.zero,
                  child: widget.builder(context, value.elementAt(index)),
                );
              },
            );
          },
        ),
        if (isLoading) widget.onLoadMoreLoading ?? const SizedBox(),
        if (isNoData) widget.onNoData ?? const SizedBox(),
        widget.bottomWidget ?? const SizedBox(),
      ],
    );
  }
}

/// type def for `onInit` argument of [LoadMoreListData]
typedef OnInit<T> = FutureOr<Iterable<T>> Function();

/// type def for `OnLoad` argument of [LoadMoreListData]
typedef OnLoad<T> = FutureOr<Iterable<T>?> Function(int index);

/// type def for `builder` argument of [LoadMoreListData]
typedef ItemBuilder<T> = Widget Function(BuildContext context, T itemData);
