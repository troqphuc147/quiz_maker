import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quiz_maker/models/Question.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_maker/models/Quiz.dart';
import 'package:quiz_maker/screens/createQuiz/addquestions.dart';
import 'package:quiz_maker/services/auth.dart';
import 'package:quiz_maker/services/database.dart';
import 'package:quiz_maker/services/storage.dart';

class CreateQuizHome extends StatefulWidget {
  const CreateQuizHome({Key? key}) : super(key: key);

  @override
  _CreateQuizHomeState createState() => _CreateQuizHomeState();
}

class _CreateQuizHomeState extends State<CreateQuizHome> {
  List<Question> listQuestion = <Question>[];
  late String code = '';
  late String title = '';
  late XFile imageFile;
  bool uploadImage = false;
  final ImagePicker picker = ImagePicker();
  AuthService authService = AuthService();
  Storage storage = Storage();
  late String uid = '';
  late DatabaseService databaseService = DatabaseService(uid: uid);

  @override
  void initState() {
    // TODO: implement initState
    uid = authService.getCurrentUser!.uid;
    databaseService = DatabaseService(uid: uid);
    super.initState();
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile = await picker.pickImage(
        source: source,
      );
      setState(() {
        imageFile = pickedFile!;
        uploadImage = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: [
                    GestureDetector(
                      child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width - 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blue, width: 2),
                          ),
                          child: uploadImage
                              ? Container(
                                  child: Image.file(
                                    File(imageFile.path),
                                    height: 200,
                                    width:
                                        MediaQuery.of(context).size.width - 10,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                  'Upload image of quiz',
                                  style: TextStyle(
                                      color: Colors.blue[900], fontSize: 25),
                                ))),
                      onTap: () {
                        _onImageButtonPressed(ImageSource.gallery,
                            context: context);
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 1,
                        decoration: InputDecoration(
                            hintText: 'Enter title of quiz',
                            hintStyle:
                                TextStyle(color: Colors.black38, fontSize: 20)),
                        onChanged: (val) {
                          title = val;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 1,
                        decoration: InputDecoration(
                            hintText: 'Enter code of quiz',
                            hintStyle:
                                TextStyle(color: Colors.black38, fontSize: 20)),
                        onChanged: (val) {
                          code = val;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                );
              },
              childCount: 1,
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.blue[100],
                child: Column(
                  children: [
                    Row(
                      children: [
                        MaterialButton(
                          onPressed: () {},
                          child: Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              padding: EdgeInsets.all(1),
                              height: 60,
                              width: MediaQuery.of(context).size.width - 80,
                              decoration: BoxDecoration(
                                  color: Colors.blue[700],
                                  border: Border.all(
                                      color: Colors.white, width: 2)),
                              child: Text(
                                'Question ' +
                                    (index + 1 ).toString() +
                                    ' :' +
                                    listQuestion[index].question.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                listQuestion.removeAt(index);
                              });
                            },
                            icon: Icon(Icons.clear))
                      ],
                    ),
                  ],
                ),
              );
            },
            childCount: listQuestion.length,
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        backgroundColor: Colors.grey,
        onPressed: () async {
          Question ques = Question(
              id: '',
              imageURL: '',
              option1: '',
              option2: '',
              option3: '',
              option4: '',
              question: '',
              rightAnswer: '');
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddQuestionScreen(
                        ques: ques,
                      )));
          print('ques : ' + ques.question);
          if (ques.question != '') {
            setState(() {
              listQuestion.add(ques);
            });
          }
        },
        child: Center(
            child: Text(
          'Add\nques',
          style: TextStyle(fontSize: 16, color: Colors.white),
        )),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blue, width: 3)),
        child: TextButton(
          onPressed: () async {
            Quiz quiz = Quiz(
                id: '', code: code, imageURL: imageFile.path, title: title);
            await databaseService.addQuiz(quiz);
            storage.uploadImageToFirebase(File(imageFile.path));
            final q = await databaseService.getQuizByCode(code);
            print('code ne nha: ' + code);
            print('q ne nha : ' + q.code.toString());
            for(int i = 0 ;i < listQuestion.length; i++)
              {
                databaseService.addQuestion(listQuestion[i], q.id);
              }
          },
          child: Text(
            'Add quiz',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
