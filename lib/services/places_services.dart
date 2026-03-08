import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesService {
  static const _apiKey = 'AIzaSyCg7of7a_zWYOEt7rGjK-syAtfwVYjQUyw';

  static Future<List<PlacesSuggestion>> getSuggestions(
    String input, {
    LatLng? location,
    int radius = 50000,
  }) async {
    if (input.trim().isEmpty) return [];

    String googleUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=${Uri.encodeComponent(input)}'
        '&key=$_apiKey'
        '&components=country:us';

    if (location != null) {
      googleUrl +=
          '&location=${location.latitude},${location.longitude}'
          '&radius=$radius';
    }
    final url = Uri.parse(
      'https://corsproxy.io/?${Uri.encodeComponent(googleUrl)}',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) return [];

    final data = json.decode(response.body);
    if (data['status'] != 'OK') return [];

    return (data['predictions'] as List)
        .map(
          (p) => PlacesSuggestion(
            placeId: p['place_id'],
            description: p['description'],
            mainText: p['structured_formatting']['main_text'],
            secondaryText: p['structured_formatting']['secondary_text'] ?? '',
          ),
        )
        .toList();
  }

  static Future<PlacesDetails?> getDetails(String placeId) async {
    final googleUrl =
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId'
        '&fields=geometry,formatted_address'
        '&key=$_apiKey';

    final url = Uri.parse(
      'https://corsproxy.io/?${Uri.encodeComponent(googleUrl)}',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    if (data['status'] != 'OK') return null;

    final result = data['result'];
    final location = result['geometry']['location'];

    return PlacesDetails(
      address: result['formatted_address'],
      lat: (location['lat'] as num).toDouble(),
      lng: (location['lng'] as num).toDouble(),
    );
  }

  static Future<List<LatLng>?> getRoutePolyline({
    required double pickupLat,
    required double pickupLng,
    required double destLat,
    required double destLng,
  }) async {
    final googleUrl =
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=$pickupLat,$pickupLng'
        '&destination=$destLat,$destLng'
        '&key=$_apiKey';
    final url = Uri.parse(
      'https://corsproxy.io/?${Uri.encodeComponent(googleUrl)}',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    if (data['status'] != 'OK') return null;
    final encodedPolyline = data['routes'][0]['overview_polyline']['points'];

    return decodePolyline(encodedPolyline);
  }

  static List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
}

class PlacesSuggestion {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  PlacesSuggestion({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });
}

class PlacesDetails {
  final String address;
  final double lat;
  final double lng;

  PlacesDetails({required this.address, required this.lat, required this.lng});
}
