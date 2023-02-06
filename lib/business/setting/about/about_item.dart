import 'package:flutter/material.dart';
import 'package:flutter_sudoku/business/setting/about/about_detail_screen.dart';
import 'package:flutter_sudoku/common/context_extension.dart';

class AboutItem extends StatelessWidget {
  const AboutItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => context.goto(const AboutDetailScreen()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            Text('关于数独', style: TextStyle(fontSize: 14)),
            IconTheme(data: IconThemeData(color: Colors.grey), child: Icon(Icons.keyboard_arrow_right))
          ],
        ),
      ),
    );
  }
}
