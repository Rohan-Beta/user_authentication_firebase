// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login/provider/internet_provider.dart';
import 'package:login/provider/sign_in_provider.dart';
import 'package:login/utilss/screen_size.dart';
import 'package:login/utilss/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey _scafoldKey = GlobalKey<ScaffoldState>();

  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();

  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();

  Size screenSize = MyScreenSize().getScreenSize();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.only(left: 40, right: 40, top: 90, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Image(
                      image: AssetImage("MyAssets/splashimage.png"),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Flutter Firebase",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "User Authentication using firebase",
                      style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                    )
                  ],
                ),
              ),
              // rounded loading button

              // google
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedLoadingButton(
                    controller: googleController,
                    successColor: Colors.red,
                    color: Colors.red[600],
                    width: screenSize.width * 0.80,
                    child: const Wrap(
                      children: [
                        Icon(
                          FontAwesomeIcons.google,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Sign in with google",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      handleGoogleSignIn();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // facebook
                  RoundedLoadingButton(
                    controller: facebookController,
                    successColor: Colors.blue,
                    color: Colors.blue[600],
                    width: screenSize.width * 0.80,
                    child: const Wrap(
                      children: [
                        Icon(
                          FontAwesomeIcons.facebook,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Sign in with Facebook",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  // handling google sign in

  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackBar(context, "check your Internet Connection", Colors.red);
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackBar(context, sp.errorCode.toString(), Colors.red);
          googleController.reset();
        } else {
          // check whether user exists or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exists
            } else {
              // user does not exists
            }
          });
        }
      });
    }
  }
}
