import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinashembaiwa/add_user.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class HomeScreenPage extends StatefulWidget {
  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  TextEditingController tokenController = TextEditingController();
  List<dynamic> usersList = [];

  @override
  void initState() {
    super.initState();
    // getToken();
    getUserList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("User List"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddUserScreen()));
        },
        child: Icon(
          Icons.add,
        ),
      ),
      // drawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: getUserList,
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: usersList.length,
            itemBuilder: (BuildContext context, int index) {
              final user = usersList[index];
              final email = user["email"];
              final name = user["name"];
              final inputter = user["inputter"];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      // leading: Image.asset("assets/images/resturant_profile.png"),
                      title: Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text(
                        inputter,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Icon(
                              //   Icons.email,
                              // ),
                              Text(
                                email,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  // ],
                ),
              );
            }),
      ),

      // ),
    );
  }

  Future<void> getUserList() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final token = sharedPreferences.getString("token");

    final body = {
      "token": token,
    };

    final url = 'http://52.206.48.46/api/show-users';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    final result = jsonDecode(response.body);
    print(result);
    if (result["status"] == true) {
      usersList = result["data"];
    }
  }
}
