
import 'package:ecommerce_app/container/home_buttons.dart';
import 'package:ecommerce_app/controller/auth_services.dart';
import 'package:ecommerce_app/utils/ext/ext.dart';
import 'package:ecommerce_app/views/auth/signin.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
             120.heightBox,
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                    ),
                    Text("Get started with your account"),
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
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            child: Text("Forget Password"),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                          title: Text("Forget Password"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Enter your email "),
                                             10.heightBox,
                                              TextFormField(
                                                // validator: (value) =>
                                                //     value!.isEmpty ? "Enter Email" : null,
                                                controller: emailController,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    label: Text("Email")),
                                              ),
                                            ],
                                          ),
                                          //   actions: [
                                          //     TextButton(
                                          //         onPressed: () {
                                          //           Navigator.pop(context);
                                          //         },
                                          //         child: Text("close")),
                                          //     TextButton(
                                          //         onPressed: () async {
                                          //           if (emailController
                                          //               .text.isEmpty) {
                                          //             ScaffoldMessenger.of(context)
                                          //                 .showSnackBar(SnackBar(
                                          //                     content: Text(
                                          //                         "Enter Email")));
                                          //             return;
                                          //           } else {
                                          //             await AuthServices()
                                          //                 .resetPassword(
                                          //                     emailController.text)
                                          //                 .then((onValue) => {
                                          //                       if (onValue ==
                                          //                           "Mail Sent")
                                          //                         {

                                          //                         }
                                          //                     });
                                          //             Navigator.pop(context);
                                          //           }
                                          //         },
                                          //         child: Text("Send)"))
                                          //   ],

                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancel")),
                                            TextButton(
                                                onPressed: () async {
                                                  if (emailController
                                                      .text.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Email cannot be empty")));
                                                    return;
                                                  }
                                                  await AuthServices()
                                                      .resetPassword(
                                                          emailController.text)
                                                      .then((value) {
                                                    if (value == "Mail Sent") {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "Password reset link sent to your email")));
                                                      Navigator.pop(context);
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                          value,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        backgroundColor:
                                                            Colors.red.shade400,
                                                      ));
                                                    }
                                                  });
                                                },
                                                child: Text("Submit")),
                                          ]));
                            })
                      ],
                    ),
                   30.heightBox,
                    HomeButton(
                        name: "Login",
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            AuthServices()
                                .loginWithEmail(emailController.text,
                                    passwordController.text)
                                .then((onValue) => {
                                      if (onValue == "Login Succesful")
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Login Successful"))),
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
                   20.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn()));
                            },
                            child: Text("Register"))
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
