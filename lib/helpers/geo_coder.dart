import 'package:geocoding/geocoding.dart';

//to translate the address from address to latitude and longitude
Future<Map<String, String>> getCoordinates(address) async {
  var lat = "";
  var lon = "";
  var state = "";
  var street = "";
  var zip = "";
  Map<String, String> coordinates = {
    "lat": lat,
    "lon": lon,
    "state": state,
    "street": street,
    "zip": zip,
  };
  try {
    List<Location> locations = await locationFromAddress(address);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        locations[0].latitude, locations[0].longitude);
    lat = locations[0].latitude.toString();
    lon = locations[0].longitude.toString();
    coordinates["lat"] = lat;
    coordinates["lon"] = lon;
    coordinates["state"] = placemarks[0].administrativeArea.toString();
    coordinates["street"] = placemarks[0].street.toString();
    coordinates["zip"] = placemarks[0].postalCode.toString();
  } catch (ex) {
    print("Exception: $ex");
    coordinates["lat"] = ex.toString();
    coordinates["lon"] = "";
  }
  return coordinates;
}
