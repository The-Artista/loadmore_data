import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loadmore_data/src/mixin/infiniity_scroll.dart';

class Hola<T> extends StatefulWidget with InfinityScrollMixin {
  Hola({
    super.key,
    required this.oninit,
    required this.builder,
    this.initPage = 1,
  });

  final OnInit<T> oninit;
  final int? initPage;
  final ItemBuilder<T> builder;

  @override
  State<Hola<T>> createState() => _HolaState<T>();
}

class _HolaState<T> extends State<Hola<T>> {
  Iterable<T> hola = [];

  @override
  initState() {
    widget.setupScrollController(context, () async {
      // print("object");
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      hola = widget.oninit();
    });
    return ListView.builder(
      controller: widget.scrollController,
      itemCount: hola.length,
      itemBuilder: (context, index) {
        if (hola.length - 3 == index) {
          final gg = [];
          List.generate(120, (index) => gg.add(index));
          final dfsd =hola.toList().addAll(gg as Iterable<T>);
          hola = dfsd as Iterable<T>;
        }
        return widget.builder(context, hola.elementAt(index));
      },
    );
  }
}

typedef Iterable<T> OnInit<T>();
typedef Widget ItemBuilder<T>(BuildContext context, T itemData);
