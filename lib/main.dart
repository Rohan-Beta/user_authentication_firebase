import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:login/provider/internet_provider.dart";
import "package:login/provider/sign_in_provider.dart";
import "package:login/screens/login_screen.dart";
import "package:login/screens/phoneAuth_screen.dart";
import "package:login/screens/splass_screen.dart";
import "package:provider/provider.dart";

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

  runApp(const UserLogin());
}

class UserLogin extends StatelessWidget {
  const UserLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => InternetProvider(),
        ),
      ],
      child: const MaterialApp(
        title: "User Authentication",
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            body: MySplashScreen(),
          ),
        ),
      ),
    );
  }
}
