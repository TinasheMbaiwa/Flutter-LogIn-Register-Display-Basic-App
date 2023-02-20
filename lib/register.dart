import 'dart:convert';

import 'package:flutter/material.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formkey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
                      "Register",
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      "Create Your New Account",
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
                                return "Mobile # Required";
                              } else {
                                return null;
                              }
                            },
                            controller: mobileNumberController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Mobile #'),
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
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 8) {
                                return "Password Greater then 8 Digits";
                              }
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Password'),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 10,
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
                            submitData();
                          }
                        },
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomePage()));
                        // },
                        child: Center(
                          child: Text(
                            "Sign Up",
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
                        Text(
                          "Already Have Account?!",
                          style: TextStyle(
                            // color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: Text(
                            "Login",
                            textAlign: TextAlign.left,
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
                                    builder: (context) => LoginPage()));
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
    );
  }

  Future<void> submitData() async {
    final name = nameController.text;
    final mobileNumber = mobileNumberController.text;
    final email = emailController.text;
    final password = passwordController.text;
    // final username = usernameController.text;

    final body = {
      "username": name,
      "mobileNumber": mobileNumber,
      "email": email,
      "password": password,
      // "username": username,
    };

    final url = 'http://52.206.48.46/api/register';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    final result = jsonDecode(response.body);
    print(result);
    if (result["success"] == true) {
      nameController.text = '';
      mobileNumberController.text = '';
      emailController.text = '';
      passwordController.text = '';
      usernameController.text = '';

      succcessMessage("Account Created Successfully");
    } else if (result["success"] == false) {
      if (result["message"]["mobileNumber"] != null) {
        errorMessage(result["message"]["mobileNumber"][0]);
      } else if (result["message"]["username"] != null) {
        errorMessage(result["message"]["mobileNumber"][0]);
      } else if (result["message"]["mobileNumber"] != null) {
        errorMessage(result["message"]["mobileNumber"][0]);
      } else if (result["message"]["email"] != null) {
        errorMessage(result["message"]["mobileNumber"][0]);
      }
    } else {
      errorMessage("Fail! Something Went Wrong");
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
