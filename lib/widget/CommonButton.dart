import 'package:flutter/material.dart';
import 'package:HyCharge/Utils/commoncolors.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double borderRadius;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  const CommonButton({
    super.key,
    required this.title,
    this.titleColor,
    required this.onPressed,
    this.isLoading = false,
    this.height = 50,
    this.borderRadius = 20,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    this.backgroundColor = const Color(0xFF142D78),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: backgroundColor,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: CommonColors.white,
                ),
              )
            : Text(
                title,
                style: TextStyle(
                  fontSize: fontSize,
                  color:titleColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}