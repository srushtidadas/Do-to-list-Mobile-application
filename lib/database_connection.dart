import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

dynamic database;

//  newUser Model class
class NewUser {
  final String userName;
  final String password;
  final String contact;
  NewUser(
      {required this.userName, required this.password, required this.contact});
  Map<String, dynamic> userMap() {
    return {
      'userName': userName,
      'password': password,
      'contact': contact,
    };
  }
}

// new tasks model class
class Tasks {
  int? taskid;
  final String title;
  final String description;
  final String date;
  final String userName;
  Tasks(
      {this.taskid,
      required this.title,
      required this.description,
      required this.date,
      required this.userName});
  Map<String, dynamic> getTaskMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'userName': userName
    };
  }
}

// initialise database
Future<Database> databaseint() async {
  final database = openDatabase(
    join(await getDatabasesPath(), "todolist8.db"),
    version: 1,
    onCreate: (db, version) {
      db.execute('''CREATE TABLE users(
                    userName TEXT PRIMARY KEY,
                    password TEXT,
                    contact TEXT
                )''');
      db.execute('''CREATE TABLE tasks(
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    title TEXT,
                    description TEXT,
                    date TEXT,
                    userName TEXT,
                    FOREIGN KEY (userName) REFERENCES users(userName)
                )''');
      db.execute('''CREATE TABLE currentUser(
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    userName TEXT,
                    password TEXT
                )''');
    },
  );
  return database;
}

// information class [ sarv app chi information assess karanyat madat karel]
class UserInfo {
  static UserInfo obj = UserInfo();
  // ignore: prefer_typing_uninitialized_variables
  var database;
  String userName = "";

  // ignore: prefer_typing_uninitialized_variables
  var user;
// To return the single obbject of the class(single tan desine patten)
// if we create a new object each time database not get initialise for that object and we get null database error
  static UserInfo getObject() {
    return obj;
  }

  // return database object
  Future<void> getDatabase() async {
    database = await databaseint();
  }

  // add new user in database
  Future<void> insertNewUser(NewUser nu) async {
    await getDatabase();
    final localDB = await database;
    localDB.insert(
      'users',
      nu.userMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeCurrentUser() async {
    final localDB = await database;
    localDB.delete(
      'currentUser',
    );
  }

  Future<void> insertCurrentUser(String currentUser, String password) async {
    await getDatabase();
    final localDB = await database;
    user = await getCurrentUser();
    await removeCurrentUser();
    if (user.isEmpty) {
      localDB.insert(
        'currentUser',
        {"userName": currentUser, "password": password},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      localDB.update(
        'currentUser',
        {"userName": currentUser, "password": password},
        where: "id = ?",
        whereArgs: [1],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      user = await getCurrentUser();
    }
  }

  Future<List> getCurrentUser() async {
    await getDatabase();
    final localDB = await database;
    List<Map<String, dynamic>> mapEntry = await localDB.query("currentUser");

    List currentUserList = mapEntry;
    return currentUserList;
  }

  // add new task in database for that user
  Future<void> insertNewTask({var newUser}) async {
    final localDB = await database;
    localDB.insert(
      'tasks',
      newUser.getTaskMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // create object of newuser model class and pass to add in database
  Future<bool> addUser({
    required String username,
    required String password,
    required String contact,
  }) async {
    await getDatabase();

    // chaeck that user with given username is already exit or not
    if (!await obj.isUserExit(userName: username)) {
      NewUser newUser = NewUser(
        userName: username,
        password: password,
        contact: contact,
      );
      await insertNewUser(newUser);
      List<Map<String, dynamic>> retVal = await getUserList();
      for (int i = 0; i < retVal.length; i++) {}

      return true;
    } else {
      return false;
    }
  }

  // return list of all users
  Future<List<Map<String, dynamic>>> getUserList() async {
    await getDatabase();
    final localDB = await database;
    List<Map<String, dynamic>> mapEntry = await localDB.query("users");
    return mapEntry;
  }

  //return list of all tasks for the specific user
  Future<List<Map<String, dynamic>>> getTasksList({
    required String userName2,
  }) async {
    final localDB = await database;
    List<Map<String, dynamic>> mapEntry = await localDB
        .query("tasks", where: 'userName = ?', whereArgs: [userName2]);
    return mapEntry;
  }

  // this method check that user is already exit or not
  Future<bool> isUserExit({required String userName}) async {
    final localdb = await database;
    List<Map<String, dynamic>> result = await localdb
        .rawQuery("SELECT * FROM users WHERE userName = ?", [userName]);
    return result.isNotEmpty;
  }

  //check that task is allready added in list or not

  Future<void> deleteTaskFromDataBAse({required int taskId}) async {
    final localDB = await database;
    await localDB.delete(
      'tasks',
      where: "id = ?",
      whereArgs: [taskId],
    );
  }

  Future<void> updateTaskInDataBase({var task}) async {
    final localDB = await database;

    await localDB.update("tasks", task.getTaskMap(),
        where: 'id=?', whereArgs: [task.taskid]);
  }

  // return password for the specific username
  Future<String> getPassword({required String userName}) async {
    final localdb = await database;
    List<Map<String, dynamic>> result = await localdb
        .rawQuery("SELECT password FROM users WHERE userName = ?", [userName]);
    return result[0]['password'];
  }
}
