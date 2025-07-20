import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/constants-provider.dart';

class btrSvg extends StatelessWidget {
  final String image;
  final Color? color;
  const btrSvg({super.key,required this.image, this.color});

  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;
    return SvgPicture.asset(image,width: constants.iconSize,height: constants.iconSize,color: color ?? constants.iconColor);
  }
}
