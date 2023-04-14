import 'package:flutter/material.dart';
import 'package:payment/ui/profile_page.dart';
import 'package:payment/ui/help_page.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback logoutCallback;
  SettingsPage({required this.logoutCallback});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Get.to(()=> ProfilePage());
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              Get.to(()=> HelpPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign out'),
            onTap: () {
             logoutCallback();
            },
          ),
        ],
      ),
    );
  }
}