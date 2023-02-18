import 'package:app_common_flutter/app_common_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sudoku/common/context_extension.dart';
import 'package:flutter_sudoku/theme/shape.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppbarBackButton(),
        title: const Text("数独教程"),
      ),
      body: IntroductionScreen(
        showDoneButton: true,
        showSkipButton: true,
        showNextButton: false,
        skip: const Text("跳过"),
        done: const Text("完成"),
        onSkip: () => context.pop(),
        onDone: () => context.pop(),
        pages: [
          PageViewModel(
            decoration: pageDecoration,
            title: "什么是数独",
            body: "数独是最受欢迎的益智游戏之一,它通过逻辑推理来完成。解题过程不需要计算或者特殊的数学技能，只需要开动你的大脑和集中注意力。每天玩一玩数独游戏，可以提高你的注意力和进一步开发你的大脑。",
            image: Image.asset("assets/image/sudoku_1.png", alignment: Alignment.bottomCenter, fit: BoxFit.cover),
          ),
          PageViewModel(
            decoration: pageDecoration,
            title: "数独的规则",
            body: "数独的解题过程就是在9*9的方格内填入1-9的数字, 要求每行每列和每组(粗线方框内的3*3的格子)的数字不能重复。",
            image: Image.asset("assets/image/sudoku_1.png"),
          ),
          PageViewModel(
            decoration: pageDecoration,
            title: "数独的玩法",
            body: "游戏可以试错三次，笔记功能可以让你预填，以便后面进行修改。",
            image: Image.asset("assets/image/sudoku_1.png"),
          ),
        ],
      ),
    );
  }
}
