import 'package:flutter/material.dart';
import 'package:quiz_maker/screens/PLayQuiz/entercodeandplay.dart';
class PlayQuizScreen extends StatefulWidget {
  const PlayQuizScreen({Key? key}) : super(key: key);

  @override
  _PlayQuizScreenState createState() => _PlayQuizScreenState();
}

class _PlayQuizScreenState extends State<PlayQuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: EnterCodeScreen(),
    );
  }
}