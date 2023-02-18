import 'package:app_common_flutter/app_common_flutter.dart';
import 'package:flutter/material.dart';

class SudokuAboutScreen extends StatelessWidget {
  const SudokuAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppbarBackButton(),
        title: const Text("关于数独"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          const Text(
            "数独游戏",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            height: 120,
            width: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/image/logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: Text("此版本为${AppConfig.get("version")}", textAlign: TextAlign.center),
          ),
          const Text(
            '''数独是最受欢迎的益智游戏之一,它通过逻辑推理来完成. 解题过程不需要计算或者特殊的数学技能,只需要开动你的大脑和集中注意力. 每天玩一玩数独游戏，可以提高你的注意力和进一步开发你的大脑. 数独的解题过程就是在9*9的方格内填入1-9的数字,要求每行每列和每组(粗线方框内的3*3的格子)的数字不能重复.
          ''',
            style: TextStyle(height: 1.5),
          )
        ],
      ),
    );
  }
}
