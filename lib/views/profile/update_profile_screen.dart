import 'package:ecommerce_app/container/flexible_button.dart';
import 'package:ecommerce_app/controller/db_services.dart';
import 'package:ecommerce_app/provider/user_provider.dart';
import 'package:ecommerce_app/utils/ext/ext.dart';
import 'package:ecommerce_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    final user = Provider.of<UserProvider>(context, listen: false);
    nameController.text = user.name;
    emailController.text = user.email;
    addressController.text = user.address;
    phoneController.text = user.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Update Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                12.heightBox,
                TextFormField(
                  validator: (value) => value!.isEmpty ? "Enter name" : null,
                  controller: nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      label: Text("Name")),
                ),
                12.heightBox,
                TextFormField(
                  validator: (value) => value!.isEmpty ? "Enter Email" : null,
                  controller: emailController,
                  readOnly: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      label: Text("Email")),
                ),
                12.heightBox,
                TextFormField(
                  validator: (value) => value!.isEmpty ? "Enter address" : null,
                  controller: addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      label: Text("Address")),
                ),
                12.heightBox,
                TextFormField(
                  validator: (value) => value!.isEmpty ? "Enter Phone" : null,
                  controller: phoneController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      label: Text("Phone")),
                ),
                30.heightBox,
                FlexibleButton(
                    title: "update profile",
                    onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        var data = {
                          "name": nameController.text,
                          "email": emailController.text,
                          "address": addressController.text,
                          "phone": phoneController.text,
                        };
                        await DbServices().updateUserData(extraData: data);
                        Navigator.pop(context);
                        Utils.toastSuccessYellowMessage(
                            "Profile updated successfully");
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
