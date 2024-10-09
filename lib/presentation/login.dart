import 'package:flutter/material.dart';
import 'package:todo_firebase_ui_template/domain/infrastructure/todo_db.dart';
import 'package:todo_firebase_ui_template/domain/infrastructure/user_model.dart';
import 'package:todo_firebase_ui_template/presentation/panel/todo_home.dart';
import 'package:todo_firebase_ui_template/presentation/registration/signup_screen.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .3,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/reminder_banner.jpg'))),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 25, right: 25),
                        child: TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email Cannot be empty!';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              hintText: 'Email Address',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 25, right: 25),
                        child: TextFormField(
                          obscureText: true,
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password Cannot be empty!';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              UserModel user = UserModel(
                                  userId: '1',
                                  userName: '1',
                                  userEmail: emailController.text,
                                  userPassword: passwordController.text,
                                  userMobile: '1',
                                  userAddress: '1');
                              if (await checkLogin(user)) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ScreenTodoHome()));
                              } else {
                                final snackBar = SnackBar(
                                  content: const Text('Login failed.'),
                                  action: SnackBarAction(
                                    label: 'Ok',
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ScreenLogin()));
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple, // Purple background
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * .7,
                                50), // Stretched button
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22), // White text
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an accoun?",
                        style: TextStyle(color: Colors.black), // Purple text
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.purple, // Text color
                          backgroundColor:
                              Colors.white, // Button background color
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ScreenSignup()));
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}