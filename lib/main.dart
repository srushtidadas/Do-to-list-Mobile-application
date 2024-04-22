import 'package:flutter/material.dart';
import 'package:todolistadavance/database_connection.dart';
import 'login_page.dart';
import 'to_do_list_home.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State createState() {
    return _MyAppState();
  }
}

List tasks = [];

class _MyAppState extends State {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: FutureBuilder(
          future: isUserLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                value: 10,
              );
            } else {
              bool userLoggedIn = snapshot.data ?? false;
              if (userLoggedIn) {
                return MyHomePage(
                  taskList: tasks,
                );
              } else {
                return const Login();
              }
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<bool> isUserLoggedIn() async {
    List currentUser = await UserInfo.getObject().getCurrentUser();
    UserInfo.getObject().userName =
        currentUser[currentUser.length - 1]["userName"];
    tasks = await UserInfo.getObject()
        .getTasksList(userName2: UserInfo.getObject().userName);
    return currentUser.isNotEmpty;
  }
}
