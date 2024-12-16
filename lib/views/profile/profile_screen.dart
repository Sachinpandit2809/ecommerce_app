import 'package:ecommerce_app/controller/auth_services.dart';
import 'package:ecommerce_app/provider/user_provider.dart';
import 'package:ecommerce_app/utils/ext/ext.dart';
import 'package:ecommerce_app/views/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        // centerTitle: true,
      ),
      body: Consumer<UserProvider>(builder: (context, value, _) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Card(
              child: ListTile(
                title: Text(value.name),
                subtitle: Text(value.email),
                onTap: () {
                  Navigator.pushNamed(context, "/update_profile");
                },
                trailing: Icon(Icons.edit),
              ),
            ),
            ListTile(
              leading: Icon(Icons.local_shipping_outlined),
              title: Text("Order"),
              onTap: () {
                Navigator.pushNamed(context, "/orders");
              },
            ),
            15.heightBox,
            ListTile(
              leading: Icon(Icons.discount_outlined),
              title: Text("Discount"),
              onTap: () {
                Navigator.pushNamed(context, "/discount");
              },
            ),
            15.heightBox,
            ListTile(
              leading: Icon(Icons.support_agent_sharp),
              title: Text("Help & Support"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Mail us at sachinmaheshpandit@gmail.com")));
              },
            ),
            15.heightBox,
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                "Log-out",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                AuthServices().logOut();
                Navigator.pushNamed(context, "/login");
              },
            ),
            15.heightBox,
          ]),
        );
      }),
    );
  }
}
