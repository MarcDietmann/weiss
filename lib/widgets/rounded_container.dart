
import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final bool? noClip;
  final Color? color;
  final Widget? child;
  final double? height;
  final double? width;
  const RoundedContainer({
    Key? key,
    this.color,
    this.child,
    this.height,
    this.width,
    this.noClip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      child: child,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color??Colors.grey.shade200,
        borderRadius: (noClip == true)
            ? const BorderRadius.all(
          const Radius.circular(16),
        )
            : null,
      ),
    );
    return (noClip == true)
        ? container
        : ClipRRect(
        borderRadius: const BorderRadius.all(
          const Radius.circular(16),
        ),
        child: container);
  }
}