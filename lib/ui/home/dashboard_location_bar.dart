import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../utils/colors.dart';

class DashboardLocationBar extends StatefulWidget {
  const DashboardLocationBar({Key? key}) : super(key: key);

  @override
  _DashboardLocationBarState createState() => _DashboardLocationBarState();
}

class _DashboardLocationBarState extends State<DashboardLocationBar> {
  String _currentLocation = "Fetching location...";
  int _nearbyCollections = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check location services
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = "Location services are disabled.";
      });
      return;
    }

    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = "Location permissions denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = "Location permissions permanently denied";
      });
      return;
    }

    // Get current position
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );

      // Get human-readable address
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentLocation = "${place.subLocality}, ${place.locality}";
          // You might want to implement logic to count nearby collections
          _nearbyCollections = 0; // Placeholder
        });
      }
    } catch (e) {
      setState(() {
        _currentLocation = "Unable to get location";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentLocation,
                    style: const TextStyle(
                      color: AppColors.titleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text(
                        "Nearby Collections: ",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "$_nearbyCollections",
                        style: const TextStyle(
                          color: AppColors.titleColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 40.0,
              height: 40.0,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}