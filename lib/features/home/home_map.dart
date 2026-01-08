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
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: center, zoom: 16),
          buildingsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: false,
          markers: const {},
          onMapCreated: (c) {
            _controller = c;
            _controller!.setMapStyle('''
          [
            {"elementType": "geometry", "stylers": [{"color": "#1a1a2e"}]},
            {"elementType": "labels.text.fill", "stylers": [{"color": "#8a8a8a"}]},
            {"elementType": "labels.text.stroke", "stylers": [{"color": "#1a1a2e"}]},
            {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#2d2d44"}]},
            {"featureType": "road", "elementType": "geometry.stroke", "stylers": [{"color": "#1a1a2e"}]},
            {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#3d3d5c"}]},
            {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#0e1626"}]},
            {"featureType": "poi", "elementType": "geometry", "stylers": [{"color": "#1e1e32"}]},
            {"featureType": "poi.park", "elementType": "geometry", "stylers": [{"color": "#1a2e1a"}]},
            {"featureType": "transit", "elementType": "geometry", "stylers": [{"color": "#1a1a2e"}]}
          ]
            ''');
          },
        ),
        Positioned(
          left: 12,
          bottom: 50,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () async {
                final loc = _userLatLng;
                final c = _controller;
                if (loc == null || c == null) return;

                await c.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: loc, zoom: 16),
                  ),
                );
              },
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(Icons.my_location, color: Colors.black),
              ),
            ),
          ),
        ),
      ]
    );
  }
}