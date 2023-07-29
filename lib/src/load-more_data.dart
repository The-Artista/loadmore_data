import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loadmore_data/src/mixin/infiniity_scroll.dart';

class Hola<T> extends StatefulWidget with InfinityScrollMixin {
  Hola({
    super.key,
    required this.oninit,
    required this.builder,
    required this.onLoad,
    this.initPage = 1,
  });

  final OnInit<T> oninit;
  final OnLoad<T> onLoad;
  final int? initPage;
  final ItemBuilder<T> builder;

  @override
  State<Hola<T>> createState() => _HolaState<T>();
}

class _HolaState<T> extends State<Hola<T>> {
  final sss = ScrollController();
  bool isLoading = false;
  late ValueNotifier<Iterable<T>> data = ValueNotifier([]);
  int index = 0;
  bool isInitData = false;
  bool isNoData = false;

  Future<void> initData() async {
    data.value = await widget.oninit();
    setState(() {
      isInitData = true;
    });
  }

  @override
  initState() {
    initData();
    index = widget.initPage ?? 0;
    sss.addListener(() async {
      if (isNoData == false) {
        if(sss.position.pixels == sss.position.maxScrollExtent){
          print("end of the list");
          setState(() {
            isLoading = true;
          });
          final newData = await widget.onLoad(index++);
          if(newData == null || newData.isEmpty){
            setState(() {
              isNoData = true;
            });
          }else{
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
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: sss,
      children: [
        if (isInitData == false) Text("init data"),
        ValueListenableBuilder(
          valueListenable: data,
          builder: (context, value, child) {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: value.length,
              itemBuilder: (context, index) {
                return widget.builder(context, value.elementAt(index));
              },
            );
          },
        ),
        if (isLoading) Text("loading"),
        if (isNoData) Text("no more Data")
      ],
    );
  }
}

typedef FutureOr<Iterable<T>> OnInit<T>();
typedef FutureOr<Iterable<T>?> OnLoad<T>(int index);
typedef Widget ItemBuilder<T>(BuildContext context, T itemData);
