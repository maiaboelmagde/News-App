import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvgPicture extends StatelessWidget {
  const CustomSvgPicture({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.withColorFilter = true,
  });

  const CustomSvgPicture.withoutColor({
    super.key,
    required this.path,
    this.height,
    this.width,
  }) : withColorFilter = false;

  final String path;
  final bool withColorFilter;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: withColorFilter
          ? const ColorFilter.mode(Colors.red, BlendMode.srcIn)
          : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
    );
  }
}
