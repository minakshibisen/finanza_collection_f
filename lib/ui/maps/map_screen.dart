import 'package:finanza_collection_f/common/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final String title;
  final LatLng start;
  final LatLng? destination;
  final String customerName;
  final String customerAddress;

  const MapScreen({
    super.key,
    required this.title,
    this.start = const LatLng(22, 71),
    this.destination,
    this.customerName = '',
    this.customerAddress = '',
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    if (widget.destination != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('my_location'),
            position: widget.destination!,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              // Force the info window to be fully visible
              title: widget.customerName,
              snippet: '${widget.customerAddress}.',
            ),
          ),
        );
      });

      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: widget.destination!, zoom: 14)));
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.destination == null) {
      getNearbyCollections();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var zoom = 15.0;
    var target = widget.start;
    // if (widget.destination != null) {
    //   zoom = 11;
    //   target = widget.destination!;
    // }

    return Scaffold(
      appBar: DefaultAppBar(title: widget.title, size: size),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: target,
          zoom: zoom,
        ),
        myLocationEnabled: true,
        markers: _markers,
      ),
    );
  }

  void getNearbyCollections() {}
}
