import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.saffron,
      brightness: brightness,
      primary: isDark ? AppColors.royalGold : AppColors.deepGold,
      onPrimary: isDark ? AppColors.darkBg : AppColors.white,
      secondary: AppColors.saffron,
      onSecondary: AppColors.white,
      tertiary: isDark ? AppColors.goldSoft : AppColors.maroon,
      surface: isDark ? AppColors.darkSurface : AppColors.white,
      onSurface: isDark ? AppColors.darkTextPrimary : AppColors.deepMaroon,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? AppColors.darkBg : AppColors.cream,
      fontFamily: 'NotoSansTelugu',
      
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        foregroundColor: isDark ? AppColors.royalGold : AppColors.deepGold,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontFamily: 'NotoSansTelugu',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.royalGold : AppColors.deepGold,
          letterSpacing: 0.2,
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.royalGold : AppColors.deepGold,
        ),
      ),

      cardTheme: CardTheme(
        elevation: isDark ? 0 : 2,
        shadowColor: AppColors.deepGold.withOpacity(0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.goldBorder.withOpacity(0.4),
            width: 1,
          ),
        ),
        color: isDark ? AppColors.darkSurface : AppColors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceElevated : AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.goldBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.goldBorder.withOpacity(0.6),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.saffron, width: 1.8),
        ),
        prefixIconColor: AppColors.saffron,
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
          fontSize: 14,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.darkChip : AppColors.goldSoft,
        selectedColor: AppColors.saffron,
        labelStyle: TextStyle(
          fontFamily: 'NotoSansTelugu',
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.maroon,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide.none,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      tabBarTheme: TabBarTheme(
        labelColor: isDark ? AppColors.royalGold : AppColors.deepGold,
        unselectedLabelColor: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
        indicatorColor: AppColors.saffron,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(
          fontFamily: 'NotoSansTelugu',
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'NotoSansTelugu',
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.saffron,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'NotoSansTelugu',
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.darkBorder : AppColors.dividerGold.withOpacity(0.5),
        thickness: 1,
        space: 1,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        indicatorColor: AppColors.saffron.withOpacity(0.25),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          final isSelected = states.contains(MaterialState.selected);
          return TextStyle(
            fontFamily: 'NotoSansTelugu',
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? (isDark ? AppColors.royalGold : AppColors.deepGold)
                : (isDark ? AppColors.darkTextSecondary : Colors.grey.shade600),
          );
        }),
      ),
    );
  }
}
