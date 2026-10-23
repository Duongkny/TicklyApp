import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont {
  static TextTheme createTextTheme(
      BuildContext context, String bodyFontString, String displayFontString) {
    TextTheme baseTextTheme = Theme.of(context).textTheme;
    TextTheme bodyTextTheme =
        GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
    TextTheme displayTextTheme =
        GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
    TextTheme textTheme = displayTextTheme.copyWith(
      displayLarge: bodyTextTheme.displayLarge?.copyWith(
        fontSize: 57.sp,
        letterSpacing: -0.25,
      ),
      displayMedium: bodyTextTheme.displayMedium?.copyWith(
        fontSize: 45.sp,
        letterSpacing: 0,
      ),
      displaySmall: bodyTextTheme.displaySmall?.copyWith(
        fontSize: 36.sp,
        letterSpacing: 0,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: bodyTextTheme.headlineLarge?.copyWith(
        fontSize: 32.sp,
        letterSpacing: 0,
      ),
      headlineMedium: bodyTextTheme.headlineMedium?.copyWith(
        fontSize: 28.sp,
        letterSpacing: 0,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: bodyTextTheme.headlineSmall?.copyWith(
        fontSize: 24.sp,
        letterSpacing: 0,
      ),
      bodyLarge: bodyTextTheme.bodyLarge?.copyWith(
        fontSize: 16.sp,
        letterSpacing: 0.5,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: bodyTextTheme.bodyMedium?.copyWith(
        fontSize: 14.sp,
        letterSpacing: 0.25,
      ),
      bodySmall: bodyTextTheme.bodySmall?.copyWith(
        fontSize: 12.sp,
        letterSpacing: 0.4,
      ),
      labelLarge: bodyTextTheme.labelLarge?.copyWith(
        fontSize: 14.sp,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: bodyTextTheme.labelMedium?.copyWith(
        fontSize: 12.sp,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: bodyTextTheme.labelSmall?.copyWith(
        fontSize: 11.sp,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: bodyTextTheme.titleLarge?.copyWith(
        fontSize: 22.sp,
        letterSpacing: 0,
      ),
      titleMedium: bodyTextTheme.titleMedium?.copyWith(
        fontSize: 16.sp,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: bodyTextTheme.titleSmall?.copyWith(
        fontSize: 14.sp,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
      ),
    );
    return textTheme;
  }
}