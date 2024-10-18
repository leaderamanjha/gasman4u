import 'package:flutter/material.dart';
import 'package:gasman4u/core/utils/pref_utils.dart';
import 'package:gasman4u/core/utils/size_utils.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

class ThemeHelper {
  var _appTheme = PrefUtils().getThemeData();

  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  void changeTheme(String _newTheme) {
    PrefUtils().setThemeData(_newTheme);
    Get.forceAppUpdate();
  }

  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.onPrimaryContainer,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: colorScheme.primary,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    ).copyWith(
      textTheme: GoogleFonts.interTextTheme(
        TextThemes.textTheme(colorScheme),
      ),
    );
  }

  LightCodeColors themeColor() => _getThemeColors();

  ThemeData themeData() => _getThemeData();
}

class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
            color: appTheme.whiteA700,
            fontSize: 16.fSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400),
        bodySmall: TextStyle(
          color: colorScheme.primaryContainer,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        displayMedium: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 40,
          fontWeight: FontWeight.w800,
        ),
      );
}

class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0xFF000000),
    secondaryContainer: Color(0XFF9CA4AD),
    onPrimary: Color(0xFF8E8E8E),
    onPrimaryContainer: Color(0XFFFFFFFF),
  );
}

class LightCodeColors {
  // BlueGrey
  Color get blueGray400 => const Color(0XFF8E8E8E8E);
  Color get blueGray40001 => const Color(0XFF888888);
  Color get blueGray600 => const Color(0XFF556676);

  //Gray
  Color get gray100 => const Color(0XFFF7F7F7);

  //
  Color get whiteA700 => Color(0XFFFFFFFF);
}
