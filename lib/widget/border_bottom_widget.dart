import 'package:somics_os/main.dart';
import 'package:somics_os/widget/custom_button.dart';
import 'package:somics_os/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';

class BorderBottomWidget extends StatelessWidget {
  const BorderBottomWidget({
    required this.buttonText,
    this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String buttonText;
  final Function? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding(top: 12, horizontal: 16, bottom: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: appTheme.lavenderColor, width: 1.w),
        ),
      ),
      child: CustomButton(
        buttonText: buttonText,
        isLoading: isLoading,
        onPressed: onPressed,
      ),
    );
  }
}
