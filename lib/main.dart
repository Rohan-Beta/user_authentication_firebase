import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCj9J5pdNH-fXqtrrorFBMCAHUF_mE8yJA",
          authDomain: "userauthentication-854d8.firebaseapp.com",
          projectId: "userauthentication-854d8",
          storageBucket: "userauthentication-854d8.appspot.com",
          messagingSenderId: "969961199216",
          appId: "1:969961199216:web:b9b89a2fae23f3407a86b5",
          measurementId: "G-QJKMM7YM1S"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(UserLogin());
}

class UserLogin extends StatelessWidget {
  const UserLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "User Authentication",
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: SizedBox(
            height: 50,
            child: AppBar(
              title: const Center(child: Text("User Authentication")),
              backgroundColor: Colors.lightBlue,
            ),
          ),
        ),
      ),
    );
  }
}
