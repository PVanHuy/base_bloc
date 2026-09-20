import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract final class Assets {
  static const _Icons icons = _Icons();
  static const _Images images = _Images();
}

class _AssetReference {
  const _AssetReference(this.path);

  final String path;
}

class _SvgAsset extends _AssetReference {
  const _SvgAsset(super.path);

  Widget svg({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    ColorFilter? colorFilter,
  }) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      colorFilter: colorFilter,
    );
  }
}

class _ImageAsset extends _AssetReference {
  const _ImageAsset(super.path);

  Widget image({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return SvgPicture.asset(path, width: width, height: height, fit: fit);
  }
}

class _Icons {
  const _Icons();

  _SvgAsset get arrowDown => const _SvgAsset('assets/ui/arrow_down.svg');
  _SvgAsset get arrowLeft => const _SvgAsset('assets/ui/arrow_left.svg');
  _SvgAsset get arrowLeftOther => const _SvgAsset('assets/ui/arrow_left.svg');
  _SvgAsset get arrowRightOther => const _SvgAsset('assets/ui/arrow_right.svg');
  _SvgAsset get callOther => const _SvgAsset('assets/ui/call.svg');
  _SvgAsset get closeCircle => const _SvgAsset('assets/ui/close.svg');
  _SvgAsset get emptyTick => const _SvgAsset('assets/ui/empty.svg');
  _SvgAsset get radius => const _SvgAsset('assets/ui/empty.svg');
  _SvgAsset get radiusActive => const _SvgAsset('assets/ui/selected.svg');
  _SvgAsset get radiusEmpty => const _SvgAsset('assets/ui/empty.svg');
  _SvgAsset get searchNormal => const _SvgAsset('assets/ui/search.svg');
  _SvgAsset get tick => const _SvgAsset('assets/ui/selected.svg');
  _SvgAsset get vietnamCircle => const _SvgAsset('assets/ui/language.svg');
  _SvgAsset get warningOther => const _SvgAsset('assets/ui/warning.svg');
}

class _Images {
  const _Images();

  _ImageAsset get emptyData => const _ImageAsset('assets/ui/placeholder.svg');
  _ImageAsset get noUrl => const _ImageAsset('assets/ui/placeholder.svg');
  _ImageAsset get placeholder => const _ImageAsset('assets/ui/placeholder.svg');
}
