import 'package:flutter/material.dart';
import '../../shared/widgets/custom_header.dart';
import '../rides/ride_select_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './add_shortcut_modal.dart';
import './schedule_ahead_screen.dart';
import '../../services/places_services.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/location_services.dart';
import 'package:geolocator/geolocator.dart';

class DestinationSelectModal extends StatefulWidget {
  final DateTime? scheduleTime;

  const DestinationSelectModal({super.key, this.scheduleTime});

  @override
  State<DestinationSelectModal> createState() => _DestinationSelectModalState();
}

class _DestinationSelectModalState extends State<DestinationSelectModal> {
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();
  DateTime? _scheduleTime;
  String _selected = 'Destination';
  bool _isLoading = true;
  String? _homeAddress;
  String? _homePlaceId;
  String? _workAddress;
  String? _workPlaceId;

  Position?_userPosition;

  Timer? _debounce;

  List<PlacesSuggestion> _suggestions = [];
  bool _suggestIsLoading = false;

  PlacesDetails? _pickupDetails;
  PlacesDetails? _destinationDetails;

  @override
  void initState() {
    super.initState();
    _scheduleTime = widget.scheduleTime;
    _loadUserData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final userData = doc.data();

    _userPosition = await LocationService.getUserPosition();

    if (!mounted) return;

    setState(() {
      _homeAddress = userData?['home']?['homeAddress'];
      _homePlaceId = userData?['home']?['placeId'];
      _workAddress = userData?['work']?['workAddress'];
      _workPlaceId = userData?['work']?['placeId'];
      _isLoading = false;
      _suggestIsLoading = false;
    });
  }

  Future<void> _fetchSuggestions (String input) async {
    if(input.length < 2) {
      setState(() {
        _suggestions = [];
        _suggestIsLoading = false;
      });
      return;
    }

    setState(() => _suggestIsLoading = true);

    final result = await PlacesService.getSuggestions(input, location: _userPosition != null ? LatLng(_userPosition!.latitude, _userPosition!.longitude) : null);

    if(!mounted) return;
    setState(() {
      _suggestions = result;
      _suggestIsLoading = false;
    });
  }

  void _onSearchChanged (String input) {
    if(_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 150), () {
      _fetchSuggestions(input);
    });
  }

  Future<void> _onSuggestionTap(PlacesSuggestion suggestion) async {
    final details = await PlacesService.getDetails(suggestion.placeId);
    if(details == null || !mounted) return;

    setState(() {
      if(_selected == 'Start') {
      _pickupController.text = suggestion.mainText;
      _pickupDetails = details;
      } else {
        _destinationController.text = suggestion.mainText;
        _destinationDetails = details;
      }
      _suggestions = [];
    });
  }

  void _confirmDestination() {
    if(_destinationController.text.isEmpty || _destinationDetails == null) return;

    final pickupAddress = _pickupController.text.isEmpty ? 'Current Location' : _pickupController.text;

    if(pickupAddress == 'Current Location' && _userPosition == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RideSelectScreen(
          pickupAddress: pickupAddress,
          destinationAddress: _destinationController.text,
          pickupLat: pickupAddress != 'Current Location' ? _pickupDetails!.lat : _userPosition!.latitude,
          pickupLng: pickupAddress != 'Current Location' ? _pickupDetails!.lng : _userPosition!.longitude,
          destinationLat: _destinationDetails!.lat,
          destinationLng: _destinationDetails!.lng,
          scheduleTime: widget.scheduleTime,
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: _isLoading
            ? 
              Center(
                child: CircularProgressIndicator(color: Color(0xFFFF00BF)),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomHeader(title: 'Destination'),
                    const SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final time = await Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleAheadScreen()));
                                  if(time != null) setState(() => _scheduleTime = time);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.4,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 18,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _scheduleTime == null ? 'Schedule ahead' : 'Scheduled • ${_dayLabel(_scheduleTime!)}, ${TimeOfDay.fromDateTime(_scheduleTime!).format(context)}',
                                        style: TextStyle(
                                          color: _scheduleTime == null ? Colors.grey[300] : Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if(_scheduleTime != null)...{
                                        GestureDetector(
                                          onTap: () => setState(() => _scheduleTime = null),
                                          child: Icon(Icons.close, size: 16, color: Colors.grey[300])
                                        )
                                      }
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[700]!, width: 1),
                      ),
                      child: Column(
                        children: [
                          _buildLocationRow(
                            accentColor: Colors.indigoAccent,
                            controller: _pickupController,
                            isSelected: _selected == 'Start',
                            label: 'Start',
                            onTap: () => setState(() => _selected = 'Start'),
                            placeholder: 'Current location',
                          ),
                          Divider(
                            color: Colors.grey[700],
                            thickness: 1,
                            height: 1,
                          ),
                          _buildLocationRow(
                            accentColor: Color(0xFFFF00BF),
                            controller: _destinationController,
                            isSelected: _selected == 'Destination',
                            label: 'Destination',
                            onTap: () =>
                                setState(() => _selected = 'Destination'),
                            placeholder: 'Where to?',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if(_suggestIsLoading)
                    CircularProgressIndicator(color: Color(0xFFFF00BF))
                    else if(_suggestions.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = _suggestions[index];
                          return ListTile(
                            leading: Icon(Icons.location_on, color: Colors.grey[400]),
                            title: Text(suggestion.mainText, style: TextStyle(color: Colors.white)),
                            subtitle: Text(suggestion.secondaryText, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                            onTap: () => _onSuggestionTap(suggestion)
                          );
                        }
                      )
                    )
                    else...{
                      _buildShortcutTile(
                        icon: Icons.home,
                        label: 'Home',
                        hasAddress:
                            _homeAddress != null && _homeAddress!.isNotEmpty,
                        onTap: _homeAddress != null
                            ? () async {
                              final details = await PlacesService.getDetails(_homePlaceId!);
                              if(details == null || !mounted) return;

                              setState(() {
                                if(_selected == 'Start'){
                                  _pickupController.text = _homeAddress!;
                                _pickupDetails = details;
                                } else {
                                  _destinationController.text = _homeAddress!;
                                  _destinationDetails = details;
                                }
                              });
                            }
                            : () async {
                                await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => AddShortcutModal(
                                    fieldName: 'homeAddress',
                                    icon: Icons.home,
                                    label: 'Home',
                                  ),
                                );
                                _loadUserData();
                              },
                      ),
                      const SizedBox(height: 12),
                      _buildShortcutTile(
                        icon: Icons.work,
                        label: 'Work',
                        hasAddress:
                            _workAddress != null && _workAddress!.isNotEmpty,
                        onTap: _workAddress != null
                            ? () async {
                              final details = await PlacesService.getDetails(_workPlaceId!);
                              if(details == null || !mounted) return;

                              setState(() {
                                if(_selected == 'Start'){
                                  _pickupController.text = _workAddress!;
                                _pickupDetails = details;
                                } else {
                                  _destinationController.text = _workAddress!;
                                  _destinationDetails = details;
                                }
                              });
                            }
                            : () async {
                                await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => AddShortcutModal(
                                    fieldName: 'workAddress',
                                    icon: Icons.work,
                                    label: 'Work',
                                  ),
                                );
                                _loadUserData();
                              },
                      ),
                    },
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _confirmDestination,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF00BF),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Confirm',
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
      ),
    );
  }

  Widget _buildShortcutTile({
    required IconData icon,
    required String label,
    required bool hasAddress,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFFF00BF), size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (!hasAddress)
                Text(
                  'Add shortcut',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required TextEditingController controller,
    required String placeholder,
    required Color accentColor,
    required bool isSelected,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.circle, color: accentColor, size: 12),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 50,
                child: isSelected
                    // Selected: label + TextField
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            label,
                            style: TextStyle(color: accentColor, fontSize: 10),
                          ),
                          TextField(
                            controller: controller,
                            autofocus: true,
                            cursorColor: accentColor,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: placeholder,
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (_) => _onSearchChanged(controller.text),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 7),
                          Text(
                            label,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            controller.text.isEmpty
                                ? placeholder
                                : controller.text,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dayLabel(DateTime t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(t.year, t.month, t.day);
    final d = day.difference(today).inDays;

    if(d == 0) return "Today";
    if(d == 1) return "Tomorrow";

    return '${t.month}/${t.day}';
  }

}
