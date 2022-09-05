class WeatherModel {
  String name = "";
  String description = "";
  double temperature = 0;
  double perceived = 0;
  int pressure = 0;
  int humidity = 0;
  String country = "";
  String icon = "";

  WeatherModel(this.name, this.description, this.temperature, this.perceived,
      this.pressure, this.humidity, this.country, this.icon);
  //class can have only one unnamed constructor, and multiple named ones
  WeatherModel.fromJson(Map<String, dynamic> weatherMap) {
    this.name = weatherMap["name"];
    this.temperature = ((weatherMap["main"]["temp"] * (9 / 5) - 459.67) ?? 0.0)
        as double; //for F
    this.perceived = ((weatherMap["main"]["feels_like"] * (9 / 5) - 459.67) ??
        0.0) as double; //for F;
    // this.temperature = (weatherMap["main"]["temp"] - 273.15) ?? 0; //for C
    // this.perceived = (weatherMap["main"]["feels_like"] - 273.15) ?? 0; //for C
    this.pressure = weatherMap["main"]["pressure"];
    this.humidity = weatherMap["main"]["humidity"];
    this.description =
        "${weatherMap["weather"][0]["main"]}, ${weatherMap["weather"][0]["description"]}";
    this.country = weatherMap["sys"]["country"];
    this.icon =
        "http://openweathermap.org/img/wn/${weatherMap["weather"][0]["icon"]}@2x.png";
  }
}
