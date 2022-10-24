import 'package:flutter/material.dart';

import 'svg_icon.dart';

class SimpleTextIcon extends StatelessWidget {
  final String icon;
  final String text;

  const SimpleTextIcon({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgIcon(name: icon, size: 18),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
