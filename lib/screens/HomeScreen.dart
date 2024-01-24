import 'package:flutter/material.dart';
import 'package:login/provider/sign_in_provider.dart';
import 'package:login/screens/login_screen.dart';
import 'package:login/utilss/next_screen.dart';
import 'package:provider/provider.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _UserAuthState();
}

class _UserAuthState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final sp = context.read<SignInProvider>();

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            child: const Text("Sign Out"),
            onPressed: () {
              sp.userSignOut();
              nextScreenReplace(context, const LogInScreen());
            },
          ),
        ),
      ),
    );
  }
}
