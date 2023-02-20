import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinashembaiwa/register.dart';
import 'home.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: [
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  // Welcome Text
                  Text(
                    "Hello Again",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Weclome Back, you\'ve been missed!",
                    style: TextStyle(fontSize: 16),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  // Text Field Email
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Email'),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  // Text Field Password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Password'),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Sign in Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      // color: Colors.deepPurple,
                      // padding: EdgeInsets.all(20),
                      // decoration: BoxDecoration(
                      //     color: Colors.deepPurple,
                      //     borderRadius: BorderRadius.circular(12)),
                      onPressed: () {
                        submitData();
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomeScreenPage()));
                      },
                      child: Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Create New Accout
                  SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   "I Have not Account!",
                      //   style: TextStyle(
                      //     // color: Colors.blue,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        // splashColor: Colors.red,
                        // color: Colors.green,
                        // textColor: Colors.white,
                        child: Text(
                          "Register Now",
                          style: TextStyle(
                            // backgroundColor: Colors.black,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                      ),
                      // Text(
                      //   "Register Now",
                      //   style: TextStyle(
                      //     color: Colors.blue,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitData() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email == '' || password == '') {
      errorMessage("All Fields Required");
    } else {
      final body = {
        "email": email,
        "password": password,
      };

      const url = 'http://52.206.48.46/api/login';
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      final result = jsonDecode(response.body);
      print(result);

      if (result["status"] == true) {
        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        sharedPreferences.setString("token", result["token"]);

        succcessMessage(result["message"]);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreenPage()));
      } else if (result["status"] == false) {
        errorMessage(result["message"]);
      } else if (result["success"] == false) {
        errorMessage(result["message"]["password"][0]);

        // Get.to(HomePage());
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => WaitingScreen()));
        // return HomePage();
      } else {
        errorMessage("Fail! Something Went Wrong");
      }
    }
  }

  void succcessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void errorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
