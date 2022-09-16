import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_app/constats.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

///
///@author @musabisinwa
///
///
///google places repo
///
///uses google api keys to make http requests to get suggestions
///
///

class GooglePlacesRepository {
  final _key = G_API_KEY;

  /// gets a plceid of an address
  Future<String> getPlaceId(String place) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$place&inputtype=textquery&key=$_key';
    var response = await http.get(Uri.parse(url));
    var jsonResponse = convert.jsonDecode(response.body);
    var placeId = jsonResponse['candidates'][0]['place_id'] as String;
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String place) async {
    final placeId = await getPlaceId(place);
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&inputtype=textquery&key=$_key';
    var response = await http.get(Uri.parse(url));
    var jsonResponse = convert.jsonDecode(response.body);
    var result = jsonResponse['result'] as Map<String, dynamic>;
    return result;
  }

  ///
  ///get lat long of a given String place : reverse geocoding
  Future<LatLng> getPlaceCoordinates(String place) async {
    final gplace = await GooglePlacesRepository().getPlace(place);
    final lat = gplace['geometry']['location']['lat'];
    final long = gplace['geometry']['location']['lng'];
    return LatLng(lat, long);
  }

  //getting directions from google directions
  Future<Map<String, dynamic>> getDirections(
      {required String from, required String to}) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$from&destination=$to&key=$_key';
    var response = await http.get(Uri.parse(url));
    var jsonResponse = convert.jsonDecode(response.body);
    
    return {
      'ne_bounds': jsonResponse['routes'][0]['bounds']['northeast'],
      'sw_bounds': jsonResponse['routes'][0]['bounds']['southwest'],
      'start_loc': jsonResponse['routes'][0]['legs'][0]['start_location'],
      'dest_loc': jsonResponse['routes'][0]['legs'][0]['end_location'],
      'polyline': jsonResponse['routes'][0]['overview_polyline']['points'],
      'polyline_dec':PolylinePoints().decodePolyline(jsonResponse['routes'][0]['overview_polyline']['points']),
      'distance': jsonResponse['routes'][0]['legs'][0]['distance']['text'],
      'duration': jsonResponse['routes'][0]['legs'][0]['duration']['text'],
    };
  }
}
