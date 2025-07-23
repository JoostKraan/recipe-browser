import 'dart:ui';
import 'package:flutter/material.dart';
class Constants{

  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color specialColor;
  final Color errorColor;
  final Color successColor;
  final Color fontColor;
  final Color iconColor;
  final double iconSize;
  final double fontSize;

  final String mapurl;

  final bool isDarkMode;

  Constants(this.isDarkMode)

      : primaryColor = isDarkMode ? const Color(0xFF626F47) : const Color(
      0xFF626F47),
        secondaryColor = isDarkMode ? const Color(0xFFA4B465) : const Color(0xFFA4B465),
        accentColor = const Color(0xFFFFCF50),
        specialColor = const Color(0xFFFEFAE0),
        errorColor = const Color(0xFFEF476F),
        successColor = const Color(0xFF009B72),
        fontColor =  isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xD10E1314)  ,
        iconColor =  isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xD10E1314),
        iconSize = 25,
        fontSize = 25,
        mapurl = isDarkMode ? "https://tile.jawg.io/jawg-dark/{z}/{x}/{y}{r}.png?access-token=ME95gmQBq6fVpZys7OtD6VJLMx706vzQRALB4oZiea5VnbQ7rfH9xjiOIu5wyy5b"
                      : "https://tile.jawg.io/jawg-light/{z}/{x}/{y}{r}.png?access-token=ME95gmQBq6fVpZys7OtD6VJLMx706vzQRALB4oZiea5VnbQ7rfH9xjiOIu5wyy5b";
}
