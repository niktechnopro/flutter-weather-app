import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import './app_wrapper.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: MainAppWrapper(),
      duration: 8000, //TODO - return it back to 8000
      imageSize: 170,
      imageSrc: "assets/logo.png",
      text: "Fun project by Nik built with Flutter",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(fontSize: 30.0, fontStyle: FontStyle.italic),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );
  }
}
