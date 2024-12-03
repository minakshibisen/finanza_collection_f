
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

String getFancyNumber(double number) {
  // Split into integer and decimal parts
  String numberString = number.toStringAsFixed(2);
  List<String> parts = numberString.split('.');

  // Format integer part in Indian style
  String integerPart = parts[0];
  String formattedInteger = integerPart.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+(\d{1})(?!\d))'),
          (Match m) => '${m[0]},'
  );

  // Combine back with decimal part
  return '$formattedInteger.${parts[1]}';
}

void closeKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

void showSnackBar(String s, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(s)),
  );
}

Future<Map<String, Object?>> getCurrentLocation(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    if(!context.mounted) return {};
    showSnackBar("Location services are disabled.", context);
    return {};
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      if(!context.mounted) return {};
      showSnackBar("Location permissions denied.", context);
      return {};
    }
  }

  if (permission == LocationPermission.deniedForever) {
    if(!context.mounted) return {};
    showSnackBar("Location permissions permanently denied.", context);
    return {};
  }

  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> places =
    await placemarkFromCoordinates(position.latitude, position.longitude);

    if (places.isNotEmpty) {
      Placemark place = places[0];
      var address = {
        "latitude": position.latitude.toString() ?? '',
        "longitude": position.longitude.toString() ?? '',
        "location": '${place.name}, ${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}',
        "pincode": place.postalCode,
        "city": place.locality,
      };

      return address;
    }

    return {};
  } catch (e) {
    if(!context.mounted) return {};
    showSnackBar("Unable to get location.", context);
    return {};
  }
}


Future<String?> getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor;
  } else if(Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return const AndroidId().getId();
  }
}