import 'package:somics_os/widget/image_asset_custom.dart';
import 'package:flutter/material.dart';

class BackgorundImageWidget extends StatelessWidget {
  const BackgorundImageWidget({
    super.key,
    required this.imagePath,
    required this.child,
    this.fit = .cover,
    this.alignment = .center,
  });

  final String imagePath;
  final Widget child;
  final BoxFit fit;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .expand,
      children: [
        Positioned.fill(
          child: ImageAssetCustom(
            imagePath: imagePath,
            boxFit: fit,
            alignment: alignment,
          ),
        ),
        child,
      ],
    );
  }
}
