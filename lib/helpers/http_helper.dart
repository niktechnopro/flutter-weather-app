import 'package:http/http.dart' as http;
import 'dart:convert';
import './weather_model.dart';
import 'secrets.dart';

class HttpHelper {
  //api call: https://api.openweathermap.org/data/2.5/weather?q=London&appid=51bfbec8aac4cae529f1917a2e66d3c7
  final String authority = "api.openweathermap.org";
  final String path = "data/2.5/weather";
  final String apiKey = weatherApiKey;

  //Future class - result of async operation, would allow to run async tasks
  Future<WeatherModel> getWeather(coordinates) async {
    Map<String, dynamic> parameters = {
      "lat": coordinates["lat"],
      "lon": coordinates["lon"],
      "appId": apiKey
    };
    Uri uri = Uri.https(authority, path, parameters);
    http.Response result = await http.get(uri);
    Map<String, dynamic> data = json.decode(result.body);
    return WeatherModel.fromJson(data);
  }
}
