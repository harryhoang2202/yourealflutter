import 'dart:math';

import 'package:flutter/material.dart';

class SliverPersistentHeaderCustomDelegate
    extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SliverPersistentHeaderCustomDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: Transform.translate(
        offset: Offset(0, -shrinkOffset * 0.3),
        child: Transform.scale(
            scale: disappear(shrinkOffset * 0.2),
            child: Opacity(opacity: disappear(shrinkOffset), child: child)),
      ),
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / maxHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / maxHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderCustomDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
