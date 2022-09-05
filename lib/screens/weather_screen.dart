import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/sound_helper.dart';
import '../helpers/geo_coder.dart';
import '../helpers/http_helper.dart';
import '../helpers/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController txtPlace = TextEditingController();
  bool isFirstLoad = true;
  bool selected = false;
  bool isGeoCoderError = false;
  String geoCoderMessage = "";
  String state = "";
  String street = "";
  String zip = "";
  WeatherModel result = WeatherModel("", "", 0, 0, 0, 0, "", "");

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Container(
        child: Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                        "${DateFormat.yMMMMEEEEd().format(DateTime.now())}",
                        style: TextStyle(fontSize: 21, color: Colors.black))))),
      ),
      Container(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
            child: TextField(
              onSubmitted: (value) {
                FocusScope.of(context).unfocus(); //unfocuses from field
                if (value != "") {
                  selected = false;
                  getCoordinates(value).then((coordinates) => {
                        if (coordinates["lon"] == "")
                          {
                            selected = false,
                            isGeoCoderError = true,
                            geoCoderMessage = coordinates["lat"].toString(),
                            playSound("assets/no-thats-not-gonna-do-it.wav"),
                            setState(() {})
                          }
                        else
                          {
                            isGeoCoderError = false,
                            geoCoderMessage = "",
                            getData(coordinates),
                            setState(() {})
                          }
                      });
                } else {
                  playSound("assets/no-thats-not-gonna-do-it.wav");
                  showAlertDialog(context);
                }
                txtPlace.clear(); //clears input text
              },
              controller: txtPlace,
              style: TextStyle(fontSize: 20.0, color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Location',
                hintText: "Enter address/location",
                hintStyle: TextStyle(fontSize: 20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 62, 179, 226), width: 5.0),
                ),
                suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.blue),
                    iconSize: 36,
                    enableFeedback: true,
                    onPressed: () {
                      FocusScope.of(context).unfocus(); //unfocuses from field
                      if (txtPlace.text != "") {
                        selected = false;
                        getCoordinates(txtPlace.text).then((coordinates) => {
                              if (coordinates["lon"] == "")
                                {
                                  selected = false,
                                  isGeoCoderError = true,
                                  geoCoderMessage =
                                      coordinates["lat"].toString(),
                                  playSound(
                                      "assets/no-thats-not-gonna-do-it.wav"),
                                  setState(() {})
                                }
                              else
                                {
                                  isGeoCoderError = false,
                                  geoCoderMessage = "",
                                  getData(coordinates),
                                  setState(() {})
                                }
                            });
                      } else {
                        playSound("assets/no-thats-not-gonna-do-it.wav");
                        showAlertDialog(context);
                      }
                      txtPlace.clear(); //clears input text
                    }),
              ),
            )),
      ),
      Center(
          child: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: SizedBox(
                  width: 350,
                  height: 350,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(16.0),
                          color: Color.fromARGB(51, 15, 135, 227),
                        ),
                      ),
                      AnimatedPositioned(
                          height: selected ? 350.0 : 0.0,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.fastOutSlowIn,
                          child: Image.network(
                            result.icon,
                            fit: BoxFit.cover,
                            color: const Color.fromRGBO(255, 255, 255, 0.6),
                            colorBlendMode: BlendMode.modulate,
                            width: 350,
                          )),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 5, color: Colors.blue),
                            borderRadius: BorderRadius.circular(12)),
                        alignment: Alignment.center,
                        child: Center(
                            child: selected
                                ? Column(children: [
                                    Center(
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10.0,
                                            ),
                                            child: Text(
                                                "Current weather for ${result.name}, ${result.country}",
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black)))),
                                    Center(
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 10.0,
                                            ),
                                            child: Text("$street, $zip, $state",
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black)))),
                                    weatherRow(
                                        "Description: ", result.description),
                                    weatherRow("Temperature: ",
                                        "${result.temperature.toStringAsFixed(2)} F"),
                                    weatherRow("Perceived: ",
                                        "${result.perceived.toStringAsFixed(2)} F"),
                                    weatherRow("Pressure: ",
                                        "${result.pressure.toString()} hPa"),
                                    weatherRow("Humidity: ",
                                        "${result.humidity.toString()} %"),
                                    // weatherRow("icon: ", result.icon)
                                  ])
                                : Text(
                                    isFirstLoad
                                        ? "Enter Location/Address in search field above"
                                        : isGeoCoderError
                                            ? geoCoderMessage
                                            : "Loading...",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        fontStyle: FontStyle.italic))),
                      ),
                    ],
                  ))))
    ]);
  }

  Future<dynamic> showAlertDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Dismiss",
                        style: TextStyle(fontSize: 25),
                      )))
            ],
            title: Center(
                child: Text("Empty Location Field!",
                    style: TextStyle(fontSize: 25, color: Colors.red))),
          );
        });
  }

  Widget weatherRow(String label, String value) {
    Widget row = Padding(
      padding: EdgeInsets.all(12),
      child: Row(children: [
        Expanded(
          flex: 3,
          child: Text(label,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontStyle: FontStyle.italic)),
        ),
        Expanded(
          flex: 4,
          child: Text(value,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontStyle: FontStyle.italic)),
        ),
      ]),
    );
    return row;
  }

  Future getData(coordinates) async {
    HttpHelper helper = HttpHelper();
    result = await helper.getWeather(coordinates);
    // print("result: ${result.name}");
    selected = true;
    isFirstLoad = false;
    state = coordinates["state"];
    street = coordinates["street"];
    zip = coordinates["zip"];
    setState(() {});
  }
}
