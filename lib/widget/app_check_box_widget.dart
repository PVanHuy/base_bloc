import 'package:somics_os/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class AppCheckBoxWidget extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final double size;

  const AppCheckBoxWidget({
    super.key,
    required this.isSelected,
    this.onTap,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(size / 2),
      child: (isSelected ? Assets.icons.tick : Assets.icons.emptyTick).svg(
        width: size,
        height: size,
      ),
    );
  }
}
