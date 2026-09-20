import 'package:flutter/material.dart';

enum Languages {
  en,
  vi;

  Locale get locale {
    return switch (this) {
      Languages.en => const Locale('en', 'US'),
      Languages.vi => const Locale('vi', 'VN'),
    };
  }

  String get title {
    return switch (this) {
      Languages.en => 'English',
      Languages.vi => 'Tiếng Việt',
    };
  }

  String get flagAsset => 'assets/ui/language.svg';
}
