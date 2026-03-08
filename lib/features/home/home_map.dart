import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/location_services.dart';
import 'package:geolocator/geolocator.dart';

class HomeMap extends StatefulWidget {
  final Set<Polyline>? polylines;
  const HomeMap({super.key, this.polylines});

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  GoogleMapController? _controller;
  LatLng? _userLatLng;
  bool _isLoading = true;
  String? error;
  Position? _userPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    setState(() => _isLoading = true);
    _userPosition = await LocationService.getUserPosition();
    if (!mounted) return;

    if (_userPosition == null) {
      setState(() {
        error = 'Failed to get User Position';
        _isLoading = false;
      });
    } else {
      final latLng = LatLng(_userPosition!.latitude, _userPosition!.longitude);
      setState(() {
        _userLatLng = latLng;
        _markers = {
          Marker(
            markerId: MarkerId('currentLocation'),
            position: latLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet,
            ),
          ),
        };
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: Colors.grey[300]));
    }

    if (error != null) {
      return Center(child: Text(error!));
    }

    final center = _userLatLng!;
    return Stack(
      children: [
        GoogleMap(
          key: ValueKey(widget.polylines?.length ?? 0),
          initialCameraPosition: CameraPosition(target: center, zoom: 16),
          polylines: widget.polylines ?? <Polyline>{},
          buildingsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: false,
          markers: _markers,
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
      ],
    );
  }
}
