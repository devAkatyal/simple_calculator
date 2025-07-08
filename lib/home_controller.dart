import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';

class HomeController extends GetxController {
  final equation = '0'.obs;
  final result = '0'.obs;
  String expression = '';
  late ScrollController equationScrollController;

  @override
  void onInit() {
    super.onInit();
    equationScrollController = ScrollController();
  }

  @override
  void onClose() {
    equationScrollController.dispose();
    super.onClose();
  }

  void scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (equationScrollController.hasClients) {
        equationScrollController.jumpTo(
          equationScrollController.position.maxScrollExtent,
        );
      }
    });
  }

  void onButtonPressed(String buttonText) {
    switch (buttonText) {
      case 'C':
        _clear();
        break;
      case '⌫': // Using a distinct character for backspace logic
        _backspace();
        break;
      case '=':
        _evaluate();
        break;
      default:
        _appendToExpression(buttonText);
    }
    scrollToEnd();
  }

  void _clear() {
    equation.value = '0';
    result.value = '0';
    expression = '';
  }

  void _backspace() {
    if (equation.value.isNotEmpty) {
      equation.value = equation.value.substring(0, equation.value.length - 1);
      if (equation.value.isEmpty) {
        equation.value = '0';
      }
    }
  }

  void _evaluate() {
    try {
      expression = equation.value;
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');

      // Pre-process percentages. Replaces "B%" with "(B/100)"
      // This handles cases like "A * B%" correctly.
      final percentRegex = RegExp(r'([\d\.]+)%');
      expression = expression.replaceAllMapped(percentRegex, (match) {
        final double? num = double.tryParse(match.group(1)!);
        if (num != null) {
          return '(${num / 100})';
        }
        return match.group(0)!; // Return original if not a valid number
      });

      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);

      if (eval.isNaN || eval.isInfinite) {
        result.value = "Can't divide by 0";
        return;
      }

      result.value = eval.toString();

      if (result.value.endsWith('.0')) {
        result.value = result.value.substring(0, result.value.length - 2);
      }
    } catch (e) {
      result.value = "0";
    }
  }

  void _appendToExpression(String text) {
    const operators = ['+', '-', '×', '÷', '%'];
    const digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'];

    if (digits.contains(text)) {
      final parts = equation.value.split(RegExp(r'[+\-×÷%]'));
      final lastNumber = parts.last;

      if (lastNumber.replaceAll('.', '').length >= 15) {
        // If last number has 15 or more digits, only allow operators
        if (!operators.contains(text)) {
          return;
        }
      }
      if (text == '.' && lastNumber.contains('.')) {
        return;
      }
    }

    if (equation.value == '0' && !operators.contains(text) && text != '.') {
      equation.value = text;
      return;
    }

    if (operators.contains(text)) {
      final lastChar =
          equation.value.isNotEmpty
              ? equation.value[equation.value.length - 1]
              : '';
      if (operators.contains(lastChar)) {
        equation.value =
            equation.value.substring(0, equation.value.length - 1) + text;
        return;
      }
    }

    equation.value += text;
  }
}
