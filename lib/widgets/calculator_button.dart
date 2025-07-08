import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_calculator/themes/app_theme.dart';

class CalculatorButton extends StatefulWidget {
  const CalculatorButton({
    super.key,
    this.text,
    this.icon,
    required this.color,
    this.textColor,
    this.isSpecial = false,
    required this.onPressed,
  });

  final String? text;
  final IconData? icon;
  final Color color;
  final Color? textColor;
  final bool isSpecial;
  final VoidCallback onPressed;

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeExtension = Theme.of(context).extension<AppThemeExtension>()!;
    final buttonTextColor =
        widget.textColor ?? Theme.of(context).textTheme.headlineMedium?.color;
    final scale = _isPressed ? 0.9 : 1.0;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: themeExtension.shadowColor,
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            gradient:
                widget.isSpecial
                    ? null
                    : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: themeExtension.buttonGradient,
                    ),
            color: widget.isSpecial ? widget.color : null,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child:
                widget.text != null
                    ? Text(
                      widget.text!,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontSize: 32, color: buttonTextColor),
                    )
                    : Icon(widget.icon, color: buttonTextColor, size: 28),
          ),
        ),
      ),
    );
  }
}
