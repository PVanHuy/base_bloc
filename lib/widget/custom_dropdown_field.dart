import 'package:somics_os/gen/assets.gen.dart';
import 'package:somics_os/main.dart';
import 'package:somics_os/theme/style/style_theme.dart';
import 'package:somics_os/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';

class CustomDropdownField extends StatefulWidget {
  const CustomDropdownField({
    required this.titleText,
    required this.controller,
    required this.items,
    super.key,
    this.hintText = '',
    this.isRequired = true,
    this.borderRadius = 8,
  });

  final String titleText;
  final TextEditingController controller;
  final List<String> items;
  final String hintText;
  final bool isRequired;
  final double borderRadius;

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.items.contains(widget.controller.text)
        ? widget.controller.text
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        crossAxisAlignment: .start,
        children: [
          if (widget.titleText.isNotEmpty)
            Padding(
              padding: padding(bottom: 12),
              child: Row(
                children: [
                  Text(
                    widget.titleText,
                    style: StyleThemeData.size14Weight700(),
                  ),
                  if (widget.isRequired) ...[
                    SizedBox(width: 4.w),
                    Text(
                      '*',
                      style: StyleThemeData.size12Weight700(
                        color: appTheme.errorColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<String>(
              initialValue: _selectedValue,
              isExpanded: true,
              menuMaxHeight: 220.h,
              alignment: AlignmentDirectional.centerStart,
              borderRadius: .circular(widget.borderRadius),
              icon: Assets.icons.arrowDown.svg(width: 16.w, height: 16.w),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: padding(horizontal: 12, vertical: 15),
                hintText: widget.hintText,
                hintStyle: StyleThemeData.size14Weight400(
                  color: appTheme.gray8FColor,
                ),
                fillColor: appTheme.whiteColor,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: .circular(widget.borderRadius),
                  borderSide: BorderSide(
                    width: 1.w,
                    color: appTheme.grayE6Color,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: .circular(widget.borderRadius),
                  borderSide: BorderSide(width: 1.w, color: appTheme.appColor),
                ),
              ),
              style: StyleThemeData.size14Weight400(color: appTheme.blackColor),
              dropdownColor: appTheme.whiteColor,
              items: widget.items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: Text(item, overflow: .ellipsis),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedValue = value);
                widget.controller.text = value;
              },
            ),
          ),
        ],
      ),
    );
  }
}
