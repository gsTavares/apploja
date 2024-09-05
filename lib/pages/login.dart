import 'package:flutter/material.dart';

import '../main.dart';

import 'dart:developer';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("FCM LOGIN")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            "Selecione o tipo de usuário",
            style: TextStyle(fontSize: 24.0),
          ),
          const SizedBox(height: 30.0),
          InkWell(
            onTap: () {
              //Navigator.push(

              //  context,

              //MaterialPageRoute(

              // builder: (context) => const AdminHomePage()));
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(border: Border.all(color: MyApp.primaryColor)),
              child: const Center(
                child: Text(
                  "ADMINISTRADOR",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          InkWell(
            onTap: () {
              // Navigator.push(

              //   context,

              // MaterialPageRoute(

              //  builder: (context) => const UserHomePage()));
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(border: Border.all(color: MyApp.primaryColor)),
              child: const Center(
                child: Text(
                  "USUÁRIO",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
