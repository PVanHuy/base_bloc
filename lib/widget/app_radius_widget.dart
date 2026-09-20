import 'package:somics_os/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class AppRadiusWidget extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final double size;

  const AppRadiusWidget({
    super.key,
    required this.isSelected,
    this.onTap,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(50),
      child: (isSelected ? Assets.icons.radiusActive : Assets.icons.radius).svg(
        width: size,
        height: size,
      ),
    );
  }
}
