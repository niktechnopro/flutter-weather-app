import 'package:flutter/material.dart';
import './weather_screen.dart';
import '../components/menu_bottom.dart';

class MainAppWrapper extends StatelessWidget {
  MainAppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, //disables back button
        child: Scaffold(
            appBar: AppBar(
              title: Text("Simple Weather App by Nik"),
              centerTitle: true,
            ),
            body: WeatherScreen(),
            bottomNavigationBar: MenuBottom()));
  }
}
