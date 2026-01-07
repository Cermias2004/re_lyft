import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeMap extends StatefulWidget{
  const HomeMap({super.key});

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  GoogleMapController? _controller;
  LatLng? _userLatLng;
  bool _isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try{
      final permission = await Geolocator.requestPermission();
      if(!mounted) return;
      if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() {
          error = "Location permission denied";
          _isLoading = false;
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      if(!mounted) return;
        setState(() {
          _userLatLng = LatLng(pos.latitude, pos.longitude);
          _isLoading = false;
        });

    } catch(e) {
      setState(() {
        error = "Failed to get location: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading) {
      return Center(child: CircularProgressIndicator(color: Colors.grey[300]));
    }

    if(error != null) {
      return Center(child: Text(error!));
    }

    final center = _userLatLng!;
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: center, zoom: 16),
      buildingsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      markers: {},
      onMapCreated: (c) {
        _controller = c;
        _controller!.setMapStyle('''
      [
        {"elementType": "geometry", "stylers": [{"color": "#242f3e"}]},
        {"elementType": "labels.text.stroke", "stylers": [{"color": "#242f3e"}]},
        {"elementType": "labels.text.fill", "stylers": [{"color": "#746855"}]},
        {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#38414e"}]},
        {"featureType": "road", "elementType": "geometry.stroke", "stylers": [{"color": "#212a37"}]},
        {"featureType": "road", "elementType": "labels.text.fill", "stylers": [{"color": "#9ca5b3"}]},
        {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#17263c"}]}
      ]
        ''');
      }
    );
  }
}