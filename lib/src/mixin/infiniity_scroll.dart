
import 'package:flutter/material.dart';

class InfinityScrollMixin {
  final scrollController = ScrollController();

  void setupScrollController(BuildContext context, Function() onScrollEnd) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 && scrollController.position.pixels >= 20) {
          onScrollEnd();
        }
      }
    });
  }
}