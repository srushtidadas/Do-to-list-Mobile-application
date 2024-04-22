import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolistadavance/database_connection.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolistadavance/login_page.dart';

// new tasks model class
class NewTask {
  int? taskid;
  final String title;
  final String description;
  final String date;
  final String userName;

  NewTask({
    this.taskid,
    required this.title,
    required this.description,
    required this.date,
    required this.userName,
  });

  // return the Map for all information of task
  Map<String, dynamic> getTaskMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'userName': userName,
    };
  }
}

class MyHomePage extends StatefulWidget {
  final List taskList;

  const MyHomePage({
    required this.taskList,
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState(taskList);
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final GlobalKey _taskKey = GlobalKey<FormState>();

  List cards;

  _MyHomePageState(this.cards);

  void taskManegment({required bool todoEdit, Map? task}) async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    String date = dateController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty && date.isNotEmpty) {
      if (!todoEdit) {
        NewTask nt = NewTask(
          title: title,
          description: description,
          date: date,
          userName: UserInfo.getObject().userName,
        );

        await UserInfo.getObject().insertNewTask(newUser: nt);
      } else {
        NewTask ut = NewTask(
          taskid: task!["id"],
          title: title,
          description: description,
          date: date,
          userName: UserInfo.getObject().userName,
        );
        updateTask(taskToBeUpdate: ut);
      }
      Navigator.of(context).pop();
    }
    cards = await UserInfo.getObject()
        .getTasksList(userName2: UserInfo.getObject().userName);
    setState(() {});
  }

  Future<void> showCalender() async {
    DateTime? pickdate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );

    String formatedDate = DateFormat.yMMMd().format(pickdate!);
    setState(() {
      dateController.text = formatedDate;
    });
  }

  void showMyBottomShett({required bool todoEdit, Map? task}) {
    if (todoEdit == true) {
      titleController.text = task!["title"];
      descriptionController.text = task["description"];
      dateController.text = task['date'];
    } else {
      titleController.clear();
      descriptionController.clear();
      dateController.clear();
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text((!todoEdit) ? "Create Task" : "Edit Task",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600)),
                const SizedBox(
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _taskKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          " Title",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(111, 81, 255, 1),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (titleController.text.isEmpty) {
                              return "Please enter valid data";
                            } else {
                              return null;
                            }
                          },
                          controller: titleController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(111, 81, 255, 1),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(" Description",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(111, 81, 255, 1),
                            )),
                        TextFormField(
                          maxLines: 2,
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            /* contentPadding: EdgeInsets.symmetric(
                                vertical: 35.0, horizontal: 10.0),*/
                            labelStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(111, 81, 255, 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(111, 81, 255, 1),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          " Date",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(111, 81, 255, 1),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (titleController.text.isEmpty) {
                              return "Please enter valid data";
                            } else {
                              return null;
                            }
                          },
                          readOnly: true,
                          onTap: showCalender,
                          //onTap: showCalender,
                          controller: dateController,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                                child: const Icon(Icons.calendar_month)),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 10.0,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(111, 81, 255, 1),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ]),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color.fromRGBO(111, 81, 255, 1),
                    fixedSize: const Size(300, 50),
                  ),
                  onPressed: () {
                    if (/*_taskKey.currentState!.validate()*/ true) {
                      if (!todoEdit) {
                        taskManegment(todoEdit: false);
                      } else {
                        taskManegment(todoEdit: true, task: task);
                      }
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(111, 81, 255, 1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMyBottomShett(todoEdit: false);
        },
        backgroundColor: const Color.fromRGBO(111, 81, 255, 1),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 40, right: 20),
                child: GestureDetector(
                  onTap: () async {
                    await UserInfo.getObject().removeCurrentUser();
                    print("7777777");
                    print(await UserInfo.getObject().getCurrentUser());
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        //transitionDuration: const Duration(milliseconds: 150),
                        builder: (context) {
                          return const Login();
                        },
                      ),
                    );
                  },
                  child: Text("logout"),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Good Mornig",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                      color: Colors.white,
                      letterSpacing: 0.7),
                ),
                Text(
                  UserInfo.getObject().userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                    color: Colors.white,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              //height: double.infinity,
              padding: const EdgeInsets.only(top: 18),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Color.fromRGBO(217, 217, 217, 1),
              ),
              child: Column(
                children: [
                  const Text(
                    "CREATE TO DO LIST",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 18),
                          padding: const EdgeInsets.only(top: 35),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: (cards.isNotEmpty)
                              ? ListView.builder(
                                  itemCount: cards.length,
                                  itemBuilder: (context, index) {
                                    return getCard(cards[index]);
                                  },
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: Image.asset(
                                        "assets/images/noTask.png",
                                        height: 150,
                                        width: 150,
                                      ),
                                    ),
                                    const Text("        No Task Found ")
                                  ],
                                ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getCard(Map task) {
    return GestureDetector(
      child: Slidable(
        //closeOnScroll: false,
        endActionPane: ActionPane(
            extentRatio: 0.21,
            // openThreshold: 0.9,
            motion: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    showMyBottomShett(todoEdit: true, task: task);
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color.fromRGBO(111, 81, 255, 1),
                    radius: 18,
                    child: Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    deleteTask(task);
                  },
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color.fromRGBO(111, 81, 255, 1),
                    child: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                )
              ],
            ),
            children: const [
              Icon(Icons.edit),
              Icon(Icons.delete),
            ]),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.15), blurRadius: 20),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(217, 217, 217, 1),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.08),
                            blurRadius: 20),
                      ],
                    ),
                    child: Image.asset("assets/images/2.jpg"),
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 270,
                          child: Text(
                            task["title"],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          child: SizedBox(
                            width: 270,
                            child: Text(
                              task["description"],
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: Color.fromARGB(255, 23, 23, 23),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          task["date"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: Color.fromARGB(255, 10, 10, 10),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    child: Container(
                      height: 16,
                      width: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        //color: Color.fromRGBO(4, 189, 0, 1),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 20,
                        color: Colors.green,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteTask(Map task) async {
    UserInfo.getObject().deleteTaskFromDataBAse(taskId: task["id"]);
    cards = await UserInfo.getObject()
        .getTasksList(userName2: UserInfo.getObject().userName);
    setState(() {});
  }

  void updateTask({required NewTask taskToBeUpdate}) async {
    await UserInfo.getObject().updateTaskInDataBase(task: taskToBeUpdate);
    cards = await UserInfo.getObject()
        .getTasksList(userName2: UserInfo.getObject().userName);
    setState(() {});
  }
}
