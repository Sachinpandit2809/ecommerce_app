import 'package:ecommerce_app/container/home_buttons.dart';
import 'package:ecommerce_app/utils/ext/ext.dart';
import 'package:ecommerce_app/views/auth/login.dart';
import 'package:flutter/material.dart';

import '../../controller/auth_services.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 120),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                    ),
                    Text("Create a new account and get started"),
                    10.heightBox,
                    TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "Enter Name" : null,
                      controller: nameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), label: Text("Name")),
                    ),
                    10.heightBox,
                    TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "Enter Email" : null,
                      controller: emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), label: Text("Email")),
                    ),
                    10.heightBox,
                    TextFormField(
                      validator: (value) => value!.isEmpty || value.length < 6
                          ? "Enter password"
                          : null,
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Password")),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    HomeButton(
                        name: "sign Up",
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            AuthServices()
                                .createAccountWithEmail(
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text)
                                .then((onValue) => {
                                      if (onValue == "Account Created")
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text("Account Created"))),
                                          Navigator
                                              .restorablePushNamedAndRemoveUntil(
                                                  context,
                                                  "/home_nav",
                                                  (route) => false)
                                        }
                                      else
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              onValue,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ))
                                        }
                                    });
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: Text("Login"))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
