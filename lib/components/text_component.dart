import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/constants-provider.dart';
class btrText extends StatelessWidget {
 final String text;
 final int? fontSize;
 final Color? color;
 const btrText({super.key, required this.text,this.fontSize,this.color});
  @override
  Widget build(BuildContext context) {
    final constants = context.watch<ConstantsProvider>().constants;
    return Text(text,style: TextStyle(color: color ?? constants.fontColor, fontSize: fontSize?.toDouble() ?? constants.fontSize));}
}
