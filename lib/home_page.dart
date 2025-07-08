import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_calculator/controllers/theme_controller.dart';
import 'package:simple_calculator/themes/app_colors.dart';
import 'package:simple_calculator/themes/app_theme.dart';
import 'package:simple_calculator/widgets/calculator_button.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  final bool debugMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutGrid(
          columnSizes: [1.fr],
          rowSizes: [auto, 3.fr, 7.fr],
          children: [
            _buildDebugContainer(
              _buildThemeSwitcher(context),
              Colors.orange,
            ).withGridPlacement(rowStart: 0),
            _buildDebugContainer(
              _buildDisplay(context),
              Colors.red,
            ).withGridPlacement(rowStart: 1),
            _buildDebugContainer(
              _buildButtons(context),
              Colors.blue,
            ).withGridPlacement(rowStart: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugContainer(Widget child, Color color) {
    if (!debugMode) return child;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: child,
    );
  }

  Widget _buildThemeSwitcher(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final themeExtension = Theme.of(context).extension<AppThemeExtension>()!;

    return Container(
      color: themeExtension.containerColor,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16),
      child: Obx(
        () => IconButton(
          icon: Icon(
            themeController.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          onPressed: themeController.toggleTheme,
        ),
      ),
    );
  }

  Widget _buildDisplay(BuildContext context) {
    return Container(
      color: Theme.of(context).extension<AppThemeExtension>()!.containerColor,
      child: LayoutGrid(
        columnSizes: [1.fr],
        rowSizes: [1.fr, auto, 8.px, auto],
        children: [
          _buildDebugContainer(
            Container(
              height: 72, // Approx 3 lines of text
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.bottomRight,
              child: Obx(() {
                final formatter = NumberFormat.decimalPattern('en_US');
                // Format only the numbers in the equation, not operators
                final formattedEquation = controller.equation.value
                    .replaceAllMapped(RegExp(r'(\d+\.\d+e[+-]\d+|\d+\.?\d*)'), (
                      match,
                    ) {
                      try {
                        final number = double.parse(match.group(1)!);
                        return formatter.format(number);
                      } on FormatException {
                        return match.group(0)!;
                      }
                    });

                // Scroll to end is now handled in the controller
                // controller.scrollToEnd();

                return SingleChildScrollView(
                  controller: controller.equationScrollController,
                  child: Text(
                    formattedEquation,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: 16),
                  ),
                );
              }),
            ),
            Colors.green,
          ).withGridPlacement(rowStart: 1),
          _buildDebugContainer(
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              alignment: Alignment.bottomRight,
              child: Obx(() {
                final isError = controller.result.value == "Can't divide by 0";
                if (isError) {
                  return Text(
                    controller.result.value,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                    ),
                  );
                }

                final numberString = controller.result.value;
                String resultText;

                if (numberString.contains('e')) {
                  try {
                    final number = double.parse(numberString);
                    resultText = number
                        .toStringAsExponential(9)
                        .replaceFirst('e', 'E');
                  } on FormatException {
                    resultText = numberString; // Fallback
                  }
                } else {
                  try {
                    final number = double.parse(numberString);
                    // Count digits in the integer part only
                    final integerPart = number.truncate().toString();
                    final digitCount =
                        integerPart.replaceAll(RegExp(r'[\.-]'), '').length;

                    if (digitCount > 15) {
                      resultText = number
                          .toStringAsExponential(9)
                          .replaceFirst('e', 'E');
                    } else {
                      final formatter = NumberFormat.decimalPattern('en_US');
                      resultText = formatter.format(number);
                    }
                  } on FormatException {
                    resultText = numberString; // Fallback if parsing fails
                  }
                }

                return FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    resultText,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 56, // Base size, FittedBox will scale it down
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 1,
                    softWrap: false,
                  ),
                );
              }),
            ),
            Colors.yellow,
          ).withGridPlacement(rowStart: 3),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final themeExtension = Theme.of(context).extension<AppThemeExtension>()!;
    final numberKeyTextColor =
        !Get.find<ThemeController>().isDarkMode
            ? AppColors.lightNumberKeyText
            : null;

    return Container(
      color: themeExtension.keypadColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: LayoutGrid(
          columnSizes: [1.fr, 1.fr, 1.fr, 1.fr],
          rowSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
          columnGap: 16,
          rowGap: 16,
          children: [
            _buildButton(
              context,
              text: 'C',
              col: 0,
              row: 0,
              color: themeExtension.specialButtonColor,
              isSpecial: true,
            ),
            _buildButton(
              context,
              text: '%',
              col: 1,
              row: 0,
              color: themeExtension.topButtonColor,
            ),
            _buildButton(
              context,
              text: '×',
              col: 2,
              row: 0,
              color: themeExtension.topButtonColor,
            ),
            _buildButton(
              context,
              text: '÷',
              col: 3,
              row: 0,
              color: themeExtension.operatorColor,
            ),
            _buildButton(
              context,
              text: '7',
              col: 0,
              row: 1,
              color: themeExtension.numberColor,
              textColor: numberKeyTextColor,
            ),
            _buildButton(
              context,
              text: '8',
              col: 1,
              row: 1,
              color: themeExtension.numberColor,
              textColor: numberKeyTextColor,
            ),
            _buildButton(
              context,
              text: '9',
              col: 2,
              row: 1,
              color: themeExtension.numberColor,
              textColor: numberKeyTextColor,
            ),
            _buildButton(
              context,
              text: '+',
              col: 3,
              row: 1,
              color: themeExtension.operatorColor,
            ),
            _buildButton(
              context,
              text: '4',
              col: 0,
              row: 2,
              color: themeExtension.numberColor,
              textColor: numberKeyTextColor,
            ),
            _buildButton(
              context,
              text: '5',
              col: 1,
              row: 2,
              color: themeExtension.numberColor,
              textColor: numberKeyTextColor,
            ),
            _buildButton(
              context,
              text: '6',
              col: 2,
              row: 2,
              color: themeExtension.numberColor,
              textColor: numberKeyTextColor,
            ),
            _buildButton(
              context,
              text: '-',
              col: 3,
              row: 2,
              color: themeExtension.operatorColor,
            ),
            _buildButton(
              context,
              text: '1',
              col: 0,
              row: 3,
              color: themeExtension.numberColor,
              textColor: numberKeyTextColor,
            ),
            _buildButton(
              context,
              text: '2',
              col: 1,
              row: 3,
              color: themeExtension.numberColor,
              textColor: numberKeyTextColor,
            ),
            _buildButton(
              context,
              text: '3',
              col: 2,
              row: 3,
              color: themeExtension.numberColor,
              textColor: numberKeyTextColor,
            ),
            _buildButton(
              context,
              text: '=',
              col: 3,
              row: 3,
              rowSpan: 2,
              color: themeExtension.specialButtonColor,
              isSpecial: true,
            ),
            _buildButton(
              context,
              text: '.',
              col: 0,
              row: 4,
              color: themeExtension.numberColor,
              textColor: numberKeyTextColor,
            ),
            _buildButton(
              context,
              text: '0',
              col: 1,
              row: 4,
              color: themeExtension.numberColor,
              textColor: numberKeyTextColor,
            ),
            _buildButton(
              context,
              icon: Icons.backspace_outlined,
              col: 2,
              row: 4,
              color: themeExtension.numberColor,
              textColor: numberKeyTextColor,
            ),
          ],
        ),
      ),
    );
  }

  GridPlacement _buildButton(
    BuildContext context, {
    String? text,
    IconData? icon,
    required int col,
    required int row,
    int colSpan = 1,
    int rowSpan = 1,
    required Color color,
    Color? textColor,
    bool isSpecial = false,
  }) {
    return GridPlacement(
      columnStart: col,
      rowStart: row,
      columnSpan: colSpan,
      rowSpan: rowSpan,
      child: _buildDebugContainer(
        CalculatorButton(
          text: text,
          icon: icon,
          color: color,
          textColor: textColor,
          isSpecial: isSpecial,
          onPressed: () {
            if (text != null) {
              controller.onButtonPressed(text);
            } else if (icon == Icons.backspace_outlined) {
              controller.onButtonPressed('⌫');
            }
          },
        ),
        Colors.purple,
      ),
    );
  }
}
