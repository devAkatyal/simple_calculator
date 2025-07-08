import 'package:flutter/material.dart';
import 'app_colors.dart';

// Custom Theme Extension for specific component colors
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.operatorColor,
    required this.topButtonColor,
    required this.numberColor,
    required this.specialButtonColor,
    required this.buttonGradient,
    required this.keypadColor,
    required this.containerColor,
    required this.shadowColor,
  });

  final Color operatorColor;
  final Color topButtonColor;
  final Color numberColor;
  final Color specialButtonColor;
  final List<Color> buttonGradient;
  final Color keypadColor;
  final Color containerColor;
  final Color shadowColor;

  @override
  AppThemeExtension copyWith({
    Color? operatorColor,
    Color? topButtonColor,
    Color? numberColor,
    Color? specialButtonColor,
    List<Color>? buttonGradient,
    Color? keypadColor,
    Color? containerColor,
    Color? shadowColor,
  }) {
    return AppThemeExtension(
      operatorColor: operatorColor ?? this.operatorColor,
      topButtonColor: topButtonColor ?? this.topButtonColor,
      numberColor: numberColor ?? this.numberColor,
      specialButtonColor: specialButtonColor ?? this.specialButtonColor,
      buttonGradient: buttonGradient ?? this.buttonGradient,
      keypadColor: keypadColor ?? this.keypadColor,
      containerColor: containerColor ?? this.containerColor,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      operatorColor: Color.lerp(operatorColor, other.operatorColor, t)!,
      topButtonColor: Color.lerp(topButtonColor, other.topButtonColor, t)!,
      numberColor: Color.lerp(numberColor, other.numberColor, t)!,
      specialButtonColor:
          Color.lerp(specialButtonColor, other.specialButtonColor, t)!,
      keypadColor: Color.lerp(keypadColor, other.keypadColor, t)!,
      containerColor: Color.lerp(containerColor, other.containerColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      buttonGradient: [
        Color.lerp(buttonGradient[0], other.buttonGradient[0], t)!,
        Color.lerp(buttonGradient[1], other.buttonGradient[1], t)!,
      ],
    );
  }
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.lightBackground,
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Poppins',
          bodyColor: AppColors.lightEquationText,
          displayColor: AppColors.lightResultText,
        )
        .copyWith(
          headlineMedium: ThemeData.light().textTheme.headlineMedium?.copyWith(
            color: AppColors.lightButtonText,
          ),
        ),
    extensions: <ThemeExtension<dynamic>>[
      AppThemeExtension(
        operatorColor: Colors.blue, // Placeholder
        topButtonColor: Colors.grey, // Placeholder
        numberColor: Colors.white, // Placeholder
        specialButtonColor: AppColors.lightSpecialButton,
        keypadColor: AppColors.lightKeypad,
        containerColor: AppColors.lightContainer,
        shadowColor: AppColors.lightShadow,
        buttonGradient: const [
          AppColors.lightButtonGradientStart,
          AppColors.lightButtonGradientEnd,
        ],
      ),
    ],
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.darkBackground,
    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: 'Poppins',
      bodyColor: AppColors.darkResultText,
      displayColor: AppColors.darkResultText,
    ),
    extensions: <ThemeExtension<dynamic>>[
      const AppThemeExtension(
        operatorColor: AppColors.darkOperator,
        topButtonColor: AppColors.darkTopButton,
        numberColor: AppColors.darkNumber,
        specialButtonColor: AppColors.darkSpecialButton,
        keypadColor: AppColors.darkKeypad,
        containerColor: AppColors.darkContainer,
        shadowColor: AppColors.darkShadow,
        buttonGradient: [
          AppColors.darkButtonGradientStart,
          AppColors.darkButtonGradientEnd,
        ],
      ),
    ],
  );
}
