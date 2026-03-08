import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/places_services.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../../services/location_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddShortcutModal extends StatefulWidget {
  final String label;
  final IconData icon;
  final String fieldName;

  const AddShortcutModal({
    super.key,
    required this.label,
    required this.icon,
    required this.fieldName,
  });

  @override
  State<AddShortcutModal> createState() => _AddShortcutModalState();
}

class _AddShortcutModalState extends State<AddShortcutModal> {
  final _addressController = TextEditingController();
  bool isLoading = true;
  bool _suggestIsLoading = false;
  PlacesSuggestion? _finalSuggestion;

  List<PlacesSuggestion> _suggestions = [];

  Position? _userPosition;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final userData = doc.data();

    if (!mounted) return;

    _userPosition = await LocationService.getUserPosition();

    if (!mounted) return;

    _addressController.text = userData?[widget.fieldName] ?? '';
    setState(() => isLoading = false);
  }

  void _saveUserData() async {
    if (_finalSuggestion == null) return;
    if (_finalSuggestion!.mainText != _addressController.text) return;
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      widget.fieldName == 'homeAddress' ? 'home' : 'work': {
        (widget.fieldName): _finalSuggestion!.mainText,
        'placeId': _finalSuggestion!.placeId,
        'address': _finalSuggestion!.description,
      },
    }, SetOptions(merge: true));
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _fetchSuggestions(String input) async {
    if (input.length < 2) {
      setState(() {
        _suggestIsLoading = false;
        _suggestions = [];
      });
      return;
    }

    setState(() => _suggestIsLoading = true);

    final results = await PlacesService.getSuggestions(
      input,
      location: LatLng(_userPosition!.latitude, _userPosition!.longitude),
    );

    if (results.isEmpty || !mounted) return;

    setState(() {
      _suggestions = results;
      _suggestIsLoading = false;
    });
  }

  Future<void> _onSearchChanged(String input) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _fetchSuggestions(input);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        if (isLoading)
          Center(child: CircularProgressIndicator(color: Color(0xFFFF00BF)))
        else
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _addressController,
                    keyboardType: TextInputType.streetAddress,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Add address',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                      icon: Icon(widget.icon, color: Colors.grey[800]),
                    ),
                    onChanged: (_) => _onSearchChanged(_addressController.text),
                  ),
                ),
                const SizedBox(height: 12),
                if (_suggestIsLoading)
                  CircularProgressIndicator(color: Color(0xFFFF00BF))
                else if (_suggestions.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        return ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.grey[400],
                          ),
                          title: Text(
                            suggestion.mainText,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            suggestion.secondaryText,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          onTap: () => setState(() {
                            _finalSuggestion = suggestion;
                            _addressController.text = suggestion.mainText;
                            _suggestions = [];
                          }),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveUserData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF00BF),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
      ],
    );
  }
}
