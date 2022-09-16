// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_app/services/repositories/google_places_repository.dart';

void main() {
  //45.437500,-75.649110   Algonquin college
  test("getting a sample place coordnate (Algonquin college)", () async {
    LatLng college = await GooglePlacesRepository()
        .getPlaceCoordinates("Algonquin college,Canada");
    const check = LatLng(45.437500, -75.649110);
    expect(college, check);
  });
}