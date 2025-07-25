import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/constants_provider.dart';

class BtrSvg extends StatelessWidget {
  final String image;
  final Color? color;
  final double? size;
  const BtrSvg({super.key,required this.image, this.color,this.size});

  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;
    return SvgPicture.asset(image,width: size ?? constants.iconSize,height: size ?? constants.iconSize,color: color ?? constants.iconColor);
  }
}
