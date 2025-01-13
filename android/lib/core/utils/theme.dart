import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scanner/core/utils/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    scaffoldBackgroundColor: AppColors.lightGrey,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: AppColors.mainBlack,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.brown,
      ),
       
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.mainBlack,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.lightGrey,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: AppColors.darkGrey.withOpacity(0.5),
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.brown,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
