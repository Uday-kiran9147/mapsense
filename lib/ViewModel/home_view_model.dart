import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../Model/marker_model.dart';
import '../data/local_data_source/local_data_storage.dart';

class HomeViewModel with ChangeNotifier {
  HomeViewModel() {
    getLocationUpdates();
    loadMarkersFromDatabase();
  }
  Location locationController = Location();
  final MarkerDatabaseHelper dbHelper = MarkerDatabaseHelper.instance;
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  LatLng? currentPosition;

  Set<Marker> mapHistorySet = {};

  void onMapCreated(GoogleMapController controller) {
    debugPrint('On Map created');
    mapController.complete(controller);
    notifyListeners();
  }

  // Function to handle button press events
  void collectCoordinates() async {
    debugPrint('Collecting coordinates');
    try {
      // Retrieve the current location
      LocationData currentLocation = await locationController.getLocation();
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        LatLng newLatLng =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);

        // Create a MarkerModel object
        MarkerModel newMarker = MarkerModel(
          id: Random().nextInt(1000).hashCode,
          markerId: '${currentPosition.hashCode}',
          latitude: newLatLng.latitude,
          longitude: newLatLng.longitude,
        );

        // Save the marker to the database
        await dbHelper.createMarker(newMarker);

        // Update the UI with the new coordinates
        mapHistorySet.add(Marker(
          markerId: MarkerId(newMarker.markerId),
          icon: BitmapDescriptor.defaultMarker,
          position: newLatLng,
        ));
        currentPosition = newLatLng;
        cameraToPosition(currentPosition!);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    // notifyListeners();
  }

  Future<void> cameraToPosition(LatLng pos) async {
    debugPrint('Camera to position');
    final GoogleMapController controller = await mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
    notifyListeners();
  }

  Future<void> getLocationUpdates() async {
    debugPrint('Getting location updates');
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        currentPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
      }
      notifyListeners();
    });
  }

  void loadMarkersFromDatabase() async {
    final markers = await dbHelper.fetchMarkers();
    mapHistorySet = markers.map((marker) {
      return Marker(
        markerId: MarkerId(marker.markerId),
        position: LatLng(marker.latitude, marker.longitude),
        icon: BitmapDescriptor.defaultMarker,
      );
    }).toSet();
    notifyListeners();
  }
}
