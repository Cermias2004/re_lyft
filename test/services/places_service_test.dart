import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:customer_app/services/places_services.dart';

void main() {
  group('PlacesService', () {
    group('getSuggestions', () {
      test('returns empty list for empty input', () async {
        final result = await PlacesService.getSuggestions('');
        expect(result, isEmpty);
      });

      test('returns empty list for whitespace input', () async {
        final result = await PlacesService.getSuggestions('   ');
        expect(result, isEmpty);
      });

      test('returns empty list for tab/newline input', () async {
        final result = await PlacesService.getSuggestions('\t\n');
        expect(result, isEmpty);
      });
    });

    group('decodePolyline', () {
      test('decodes simple encoded polyline', () {
        // Known encoded polyline for a simple path
        const encoded = '_p~iF~ps|U_ulLnnqC_mqNvxq`@';
        final points = PlacesService.decodePolyline(encoded);

        expect(points, isNotEmpty);
        expect(points.length, 3);
        expect(points.first, isA<LatLng>());
      });

      test('returns correct coordinates for known polyline', () {
        // Encoded polyline for: (38.5, -120.2), (40.7, -120.95), (43.252, -126.453)
        const encoded = '_p~iF~ps|U_ulLnnqC_mqNvxq`@';
        final points = PlacesService.decodePolyline(encoded);

        // Check first point (approximately)
        expect(points[0].latitude, closeTo(38.5, 0.001));
        expect(points[0].longitude, closeTo(-120.2, 0.001));
      });

      test('returns empty list for empty string', () {
        final points = PlacesService.decodePolyline('');
        expect(points, isEmpty);
      });

      test('handles single point polyline', () {
        // Minimal encoded polyline
        const encoded = '_p~iF~ps|U';
        final points = PlacesService.decodePolyline(encoded);

        expect(points, isNotEmpty);
        expect(points.length, 1);
      });

      test('decoded points have valid latitude range', () {
        const encoded = '_p~iF~ps|U_ulLnnqC_mqNvxq`@';
        final points = PlacesService.decodePolyline(encoded);

        for (final point in points) {
          expect(point.latitude, inInclusiveRange(-90, 90));
          expect(point.longitude, inInclusiveRange(-180, 180));
        }
      });
    });
  });

  group('PlacesSuggestion', () {
    test('creates instance with required fields', () {
      final suggestion = PlacesSuggestion(
        placeId: 'ChIJtest123',
        description: '123 Main St, San Jose, CA',
        mainText: '123 Main St',
        secondaryText: 'San Jose, CA',
      );

      expect(suggestion.placeId, 'ChIJtest123');
      expect(suggestion.description, '123 Main St, San Jose, CA');
      expect(suggestion.mainText, '123 Main St');
      expect(suggestion.secondaryText, 'San Jose, CA');
    });

    test('handles empty secondary text', () {
      final suggestion = PlacesSuggestion(
        placeId: 'ChIJtest456',
        description: 'Some Place',
        mainText: 'Some Place',
        secondaryText: '',
      );

      expect(suggestion.secondaryText, '');
    });
  });

  group('PlacesDetails', () {
    test('creates instance with required fields', () {
      final details = PlacesDetails(
        address: '123 Main St, San Jose, CA 95112',
        lat: 37.3382,
        lng: -121.8863,
      );

      expect(details.address, '123 Main St, San Jose, CA 95112');
      expect(details.lat, 37.3382);
      expect(details.lng, -121.8863);
    });

    test('handles negative coordinates', () {
      final details = PlacesDetails(
        address: 'Test Location',
        lat: -33.8688,
        lng: 151.2093,
      );

      expect(details.lat, -33.8688);
      expect(details.lng, 151.2093);
    });
  });
}
