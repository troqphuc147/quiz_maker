import 'package:flutter/material.dart';
import 'package:quiz_maker/screens/athentication/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
       home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('error');
              return someThingWrong();
            }
            if(snapshot.connectionState == ConnectionState.done)
            {
              return SignInScreen();
            }
            return Container();
          }),
    );
  }
}

Widget someThingWrong() {
  return Container(
    child: Text('wrong'),
  );
}



