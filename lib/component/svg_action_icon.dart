import 'package:flutter/material.dart';

import 'svg_icon.dart';

class SvgActionIcon extends StatelessWidget {
  final String name;
  final GestureTapCallback onTap;

  const SvgActionIcon({super.key, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: SvgIcon(name: name, color: Colors.white),
    );
  }
}
