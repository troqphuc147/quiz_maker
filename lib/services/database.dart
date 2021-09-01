import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_maker/models/Question.dart';
import 'package:quiz_maker/models/Quiz.dart';

class DatabaseService {
  final String uid;
  DatabaseService({
    required this.uid,
  });
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference quizs =
      FirebaseFirestore.instance.collection('quizs');

  Future addQuiz(Quiz quiz) async {
    //get auto id for quiz
    DocumentReference quizRef = quizs.doc();
    quiz.id = quizRef.id;
    //add codQuiz into users code
    await quizRef
        .set(quiz.toMap())
        .then((value) => print('add quizcode completed'));
    DocumentReference codeRef =
        await users.doc(uid).collection('codeQuizs').doc();
    await codeRef.set(quiz.code).then((value) => print('add code to users'));
  }

  Future addQuestion(Question question, String idQuiz) async {
    DocumentReference quesRef = quizs.doc(idQuiz).collection('questions').doc();
    question.id = quesRef.id;
    await quesRef
        .set(question.toMap())
        .then((value) => print('add question completed'))
        .catchError((error) => print(error));
  }
  Future<Quiz> getQuizByID(String id) async {
    return quizs
        .doc(id)
        .get()
        .then((value) => Quiz.fromMap(value.data() as Map<String, dynamic>));
  }
}
