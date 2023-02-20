import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinashembaiwa/home.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class AddUserScreen extends StatefulWidget {
  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final formkey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Add New User"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomeScreenPage()));
        },
        child: Text("List"),
      ),
      body: ListView(
        children: [
          SafeArea(
            child: Center(
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      "Create New User Account",
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
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Name Required");
                              }
                            },
                            controller: nameController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Name'),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Email Required";
                              } else {
                                return null;
                              }
                            },
                            controller: emailController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Email'),
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
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            createNewUser();
                          }
                        },
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomePage()));
                        // },
                        child: Center(
                          child: Text(
                            "Create",
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
                        //   "Already Have Account?!",
                        //   style: TextStyle(
                        //     // color: Colors.blue,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: Text(
                            "View List",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              // color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreenPage()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // ),
    );
  }

  Future<void> createNewUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final token = sharedPreferences.getString("token");

    final body = {
      "token": token,
      "name": nameController.text,
      "email": emailController.text,
    };

    final url = 'http://52.206.48.46/api/add-user';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    final result = jsonDecode(response.body);

    if (result["message"] == "User Added") {
      succcessMessage(result["message"]);
      nameController.text = '';
      emailController.text = '';
    } else if (result["success"] == false) {
      if (result["message"]["name"] != null) {
        errorMessage(result["message"]["name"][0]);
      } else if (result["message"]["email"] != null) {
        errorMessage(result["message"]["email"][0]);
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
