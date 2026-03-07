import 'package:flutter_test/flutter_test.dart';
import 'package:customer_app/services/places_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  group('PlaceService', () {
    test('getSuggestions returns empty list for empty input', () async {
      final result = await PlacesService.getSuggestions('');
      expect(result, isEmpty);
    });

    test('getSuggestions returns empty list for whitespace', () async {
      final result = await PlacesService.getSuggestions('   ');
      expect(result, isEmpty);
    });

    test('decodePolyline decodes correctly', () {
      // Test the polyline decoder with a known encoded string
      final points = PlacesService.decodePolyline('_p~iF~ps|U');
      expect(points, isNotEmpty);
      expect(points.first, isA<LatLng>());
    });
  });
}