import 'package:flutter/material.dart';
import 'package:quiz_maker/components/process_bar.dart';
import 'package:quiz_maker/controllers/questionController.dart';
import 'package:quiz_maker/models/Question.dart';
import 'package:quiz_maker/models/Quiz.dart';
import 'package:quiz_maker/screens/PLayQuiz/questioncard.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';

class PlayQuiz extends StatefulWidget {
  final Quiz quiz;
  final List<Question> listQuestion;
  const PlayQuiz({Key? key, required this.quiz, required this.listQuestion})
      : super(key: key);
  @override
  _PlayQuizState createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  List<Question> list = [];
  @override
  void initState() {
    // TODO: implement initState
    list = widget.listQuestion;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    QuestionController questionController = Get.put(QuestionController());
    return Scaffold(
        backgroundColor: Color(0xff1d2859),
        appBar: AppBar(
          backgroundColor: Color(0xff1d2859),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProcessBar(
                        listQues: widget.listQuestion,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text.rich(TextSpan(
                          text: "Question 1",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.white),
                          children: [
                            TextSpan(
                              text: "/ ${list.length}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(color: Colors.white),
                            )
                          ])),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 610,
                          child: PageView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) =>
                                  QuestionCard(list: list, index: index)))
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
