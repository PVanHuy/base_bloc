import 'package:somics_os/gen/assets.gen.dart';
import 'package:somics_os/widget/image_asset_custom.dart';
import 'package:somics_os/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';

class AppRadioView extends StatelessWidget {
  final bool isSelected;
  final double? activeSize;
  final double? size;
  final Color? backgroundColor;

  const AppRadioView({
    super.key,
    this.isSelected = false,
    this.activeSize,
    this.size,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ImageAssetCustom(
      imagePath: isSelected
          ? Assets.icons.radiusActive.path
          : Assets.icons.radiusEmpty.path,
      size: size ?? 24.w,
    );
  }
}
