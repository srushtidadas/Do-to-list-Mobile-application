import "package:flutter/material.dart";
import "database_connection.dart";
import "login_page.dart";

class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  State createState() => _NewAccountState();
}

class _NewAccountState extends State {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();

  bool accountCreated = false;
  int usernameError = 0;
  bool isSubmitPressed = false;

// add user in database if not prestent
  Future<void> singUp() async {
    String username = usernameController.text;
    String password = passwordController.text;
    String contact = contactNoController.text;

    // If user not present in list then add
    if (!await UserInfo.getObject().isUserExit(userName: username)) {
      UserInfo()
          .addUser(username: username, password: password, contact: contact);
      accountCreated = true;
      setState(() {});
    } else {
      usernameError = 2;
    }
  }

  // cheack that number should have integer only
  bool isnumberContainIntegerOnly(String contact) {
    try {
      int.parse(contact);
    } catch (e) {
      return false;
    }
    return true;
  }

  // check both length and integers in the contact number
  bool isNumberValid(String contact) {
    if (contact.isEmpty ||
        contact.length != 10 ||
        !isnumberContainIntegerOnly(contact)) {
      return false;
    }
    return true;
  }

  // chech that username,password,contcat number is valid for accout creation or not
  bool isSignInfoCorrect() {
    String username = usernameController.text;
    String contact = contactNoController.text;
    String password = passwordController.text;

    setState(() {});
    if (username.isNotEmpty && password.length >= 4 && isNumberValid(contact)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (accountCreated == false)
        ? Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Stack(children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    child: Image.asset(
                      "assets/images/background5.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: Image.asset(
                          'assets/images/atten.png',
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Create an account",
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 300,
                          child: TextField(
                            //maxLength: 40,
                            onChanged: (value) {
                              usernameError = 0;
                              setState(() {});
                            },
                            controller: usernameController,
                            decoration: InputDecoration(
                              // hintText: "Username",
                              labelText: "Username",
                              labelStyle: const TextStyle(
                                  fontSize: 17,
                                  color: Color.fromRGBO(0, 0, 0, 0.5)),
                              errorText: (usernameController.text.isEmpty &&
                                      isSubmitPressed)
                                  ? "please enter correct user name"
                                  : (usernameError == 2)
                                      ? "username already exits"
                                      : null,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 22, 20, 20))),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: Colors.red.shade800)),
                              contentPadding: const EdgeInsets.only(left: 25),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 236, 236, 236),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 300,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",

                              labelStyle: const TextStyle(
                                  fontSize: 17,
                                  color: Color.fromRGBO(0, 0, 0, 0.5)),
                              //hintText: "Password",
                              errorText: (passwordController.text.length < 4 &&
                                      isSubmitPressed)
                                  ? "password should have atlest 4 letters"
                                  : null,

                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 0, 0, 0))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 24, 10, 9))),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: Colors.red.shade800)),
                              contentPadding: const EdgeInsets.only(left: 25),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 241, 241, 241),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          //maxLength: 40,
                          onChanged: (value) {
                            setState(() {});
                          },
                          controller: contactNoController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Phone No.",
                            labelStyle: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.5)),
                            errorText: ((contactNoController.text.length !=
                                            10 &&
                                        isSubmitPressed) ||
                                    (!isnumberContainIntegerOnly(
                                            contactNoController.text) &&
                                        contactNoController.text.isNotEmpty))
                                ? "please enter void mobile number"
                                : null,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide:
                                    BorderSide(color: Colors.red.shade800)),
                            contentPadding: const EdgeInsets.only(left: 25),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 241, 241, 241),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                          width: 300,
                          height: 43,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 0,
                                blurRadius: 14,
                                offset: const Offset(2, 8))
                          ]),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(111, 81, 255, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () async {
                              await UserInfo.getObject().getDatabase();

                              isSubmitPressed = true;

                              setState(() {});
                              if (isSignInfoCorrect()) {
                                singUp();
                              }
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 243, 243, 243)),
                            ),
                          )),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1.5,
                            width: 95,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(13, 103, 102, 102),
                                  Color.fromARGB(85, 103, 102, 102),
                                  Color.fromARGB(150, 87, 86, 86),
                                  Color.fromARGB(234, 41, 41, 41),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Or Sign up with",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Container(
                            height: 1.5,
                            width: 95,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(234, 41, 41, 41),
                                  Color.fromARGB(150, 87, 86, 86),
                                  Color.fromARGB(85, 103, 102, 102),
                                  Color.fromARGB(13, 103, 102, 102),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 23,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 80),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber,
                              ),
                              height: 45,
                              width: 45,
                              child: Image.asset(
                                "assets/images/googlelogo.png",
                                width: 20,
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              height: 45,
                              width: 45,
                              child: Image.asset(
                                "assets/images/facebook.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              height: 42,
                              width: 42,
                              child: Image.asset(
                                "assets/images/linkdin2.png",
                                height: 18,
                                width: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "   Already have an account?",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                    pageBuilder: (context, animation, _) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: const Login(),
                                      );
                                    },
                                  ),
                                );
                              },
                              style: const ButtonStyle(),
                              child: const Text(
                                "sing in",
                                style: TextStyle(
                                  color: Color.fromRGBO(111, 81, 255, 1),
                                  fontSize: 17,
                                ),
                              ),
                            )
                          ]),
                    ],
                  ),
                ]),
              ),
            ),
          )
        : Scaffold(
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 139, 254, 126),
                      child: Icon(
                        Icons.check,
                        grade: 400,
                        // weight: 200,
                        size: 45,
                      ),
                    )),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  "Your account has been \n   succesfully created",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 242, 219, 184),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 0,
                            blurRadius: 14,
                            offset: const Offset(2, 8))
                      ]),
                  width: 350,
                  height: 120,
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 300,
                    child: Text(
                      "   Welcome to our To-Do List app! Stay organized, stay productive. Start managing your tasks effortlessly. 📝✨",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 14,
                          offset: const Offset(2, 8))
                    ]),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(250, 45),
                            backgroundColor:
                                const Color.fromARGB(255, 139, 254, 126),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 50),
                              pageBuilder: (context, animation, _) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: const Login(),
                                );
                              },
                            ),
                          );
                        },
                        child: const Text(
                          "Continue",
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        )))
              ],
            )),
          );
  }
}
