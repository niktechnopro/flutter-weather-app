import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../helpers/sound_helper.dart'; //this to detect what Platform that is

class MenuBottom extends StatelessWidget {
  bool isAlreadyPressed = false;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Color.fromARGB(255, 105, 170, 240),
        unselectedItemColor: Colors.white,
        selectedFontSize: 16,
        unselectedFontSize: 16,
        onTap: (int index) async {
          switch (index) {
            case 0:
              print("tap on tab $index");
              //TODO - navigation to a main page - second option might be History or Forecast
              break;
            case 1:
              if (!isAlreadyPressed) {
                isAlreadyPressed = true; //should prevent multiple presses
                playSound("assets/maybe-next-time.wav");
                Future.delayed(
                    //equivalent of setTimeout to let sound play
                    const Duration(milliseconds: 1500),
                    () => {
                          if (Platform.isAndroid)
                            {SystemNavigator.pop()}
                          else if (Platform.isIOS)
                            {exit(0)}
                        });
              }
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: "Today"),
          BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), label: "Exit")
        ]);
  }
}
