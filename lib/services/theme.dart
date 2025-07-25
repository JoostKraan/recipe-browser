import 'dart:ui';

import 'package:flutter/material.dart';

 class Constants {
  final Color primaryColor;
  final Color secondaryColor;
  final Color cardColor;
  final Color accentColor;
  final Color specialColor;
  final Color errorColor;
  final Color successColor;
  final Color fontColor;
  final Color iconColor;
  final Color selectedTileColor;
  final Color unselectedTileColor;
  final double iconSize;
  final double fontSize;
  final bool isDarkMode;

Constants(this.isDarkMode)
      : primaryColor = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5),
        secondaryColor = isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFFFD166),
        cardColor = isDarkMode ? const Color(0xFF2E3A2F) : const Color(0xFFFFFFFF),
        accentColor = const Color(0xFF06D6A0),
        specialColor = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFDF6EC),
        errorColor = const Color(0xFFEF476F),
        successColor = const Color(0xFF06D6A0),
        fontColor = isDarkMode ? Colors.white : const Color(0xFF2E2E2E),
        iconColor = isDarkMode ? Colors.white70 : const Color(0xFF555555),
        selectedTileColor = isDarkMode
            ? const Color(0xFF3A4A3E)
            : const Color(0xFFE8F5E9),
        unselectedTileColor = isDarkMode
            ? const Color(0xFF2C2C2C)
            : const Color(0xFFF8F8F8),
        iconSize = 25,
        fontSize = 20;
}


