import 'package:flutter/material.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/core/constants/app_text_styles.dart';

enum ButtonType { primary, secondary, outline }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? width;
  final double height;
  final bool disabled;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.width,
    this.height = 56,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final textStyle = _getTextStyle();
    final content = _buildContent(textStyle);

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: MaterialButton(
        onPressed: (disabled || isLoading) ? null : onPressed,
        style: buttonStyle,
        child: content,
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    switch (type) {
      case ButtonType.primary:
        return ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColors.disabled;
            }
            return AppColors.primary;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevation: MaterialStateProperty.all(0),
        );
      case ButtonType.secondary:
        return ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColors.disabled;
            }
            return AppColors.secondary;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevation: MaterialStateProperty.all(0),
        );
      case ButtonType.outline:
        return ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: disabled ? AppColors.disabled : AppColors.primary,
                width: 2,
              ),
            ),
          ),
          elevation: MaterialStateProperty.all(0),
        );
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = AppTextStyles.button;
    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
        return baseStyle.copyWith(color: Colors.white);
      case ButtonType.outline:
        return baseStyle.copyWith(
          color: disabled ? AppColors.disabled : AppColors.primary,
        );
    }
  }

  Widget _buildContent(TextStyle textStyle) {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == ButtonType.outline ? AppColors.primary : Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: textStyle.color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: textStyle,
          ),
        ],
      );
    }

    return Text(
      text,
      style: textStyle,
    );
  }
}
