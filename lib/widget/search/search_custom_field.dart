import 'package:somics_os/gen/assets.gen.dart';
import 'package:somics_os/main.dart';
import 'package:somics_os/theme/style/style_theme.dart';
import 'package:somics_os/widget/custom_text_field.dart';
import 'package:somics_os/widget/reponsive/extension.dart';
import 'package:somics_os/widget/search/clear_icon_text.dart';
import 'package:somics_os/widget/search/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchCustomField extends StatefulWidget {
  const SearchCustomField({
    super.key,
    required this.onGetSearchValue,
    this.hintText,
    this.paddingTextfield,
    this.getSearchStatus,
    this.backgroundColor,
    this.hintStyle,
    this.hasBorder = false,
    this.textStyle,
    this.initialText,
    this.prefixIcon,
    this.margin,
    this.focusNode,
    this.textController,
    this.radius,
    this.icon,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.leadingIcon,
    this.enableDebounce = true,
    this.showLine = false,
  });

  final EdgeInsets? paddingTextfield;
  final EdgeInsets? margin;
  final String? hintText;
  final void Function(String) onGetSearchValue;
  final void Function(bool)? getSearchStatus;
  final bool hasBorder;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final String? initialText;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextEditingController? textController;
  final double? radius;
  final Widget? icon;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final Widget? leadingIcon;
  final bool enableDebounce;
  final bool showLine;

  @override
  State<SearchCustomField> createState() => _SearchCustomFieldState();
}

class _SearchCustomFieldState extends State<SearchCustomField> {
  late final controller =
      widget.textController ?? TextEditingController(text: widget.initialText);
  late final _searchCtrl = SearchStreamController(
    onGetValue: widget.onGetSearchValue,
    updateSearchingStatus: widget.getSearchStatus,
    enableDebounce: widget.enableDebounce,
  );

  @override
  void dispose() {
    controller.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? .zero,
      child: CustomTextField(
        controller: controller,
        hintText: widget.hintText ?? 'search'.tr,
        borderRadius: widget.radius,
        showBorder: false,
        fillColor: widget.backgroundColor ?? appTheme.sliverColor,
        contentPadding: widget.paddingTextfield ?? padding(all: 12),
        focusNode: widget.focusNode,
        hintStyle:
            widget.hintStyle ??
            StyleThemeData.size14Weight400(color: appTheme.gray8FColor),
        textStyle: widget.textStyle ?? StyleThemeData.size14Weight400(),
        suffixIcon: Padding(
          padding: widget.suffixIconConstraints != null
              ? padding(right: 12)
              : .zero,
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) {
                return Column(
                  mainAxisSize: .min,
                  mainAxisAlignment: .center,
                  children: [
                    widget.prefixIcon ??
                        Assets.icons.searchNormal.svg(
                          width: 16.w,
                          height: 16.w,
                          colorFilter: .mode(appTheme.grayC0Color, .srcIn),
                        ),
                  ],
                );
              } else {
                return ClearIconText(
                  controller: controller,
                  handleAfterClear: () => _searchCtrl.insertNewText(''),
                  icon: widget.icon,
                );
              }
            },
          ),
        ),
        prefixIconConstraints: widget.prefixIconConstraints,
        prefixIcon: widget.leadingIcon,
        suffixIconConstraints: widget.suffixIconConstraints,
        showLine: widget.showLine,
        onChanged: _searchCtrl.insertNewText,
      ),
    );
  }
}
