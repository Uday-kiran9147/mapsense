import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapsense/ViewModel/home_view_model.dart';
import 'package:mapsense/data/local_data_source/local_data_storage.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (_, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[100],
          title: const Text('History'),
          actions: [
            IconButton(
              tooltip: 'Clear History',
              onPressed: () {
                setState(() {
                  _clearHistory(context);
                  value.mapHistorySet.clear();
                });
              },
              icon: Icon(Icons.delete,color: Colors.red.shade800,),
            ),
          ],
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: value.mapHistorySet.isNotEmpty
                ? value.mapHistorySet.first.position
                : const LatLng(0, 0),
            zoom: 15,
          ),
          compassEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: value.mapHistorySet,
        ),
      ),
    );
  }

  // Function to clear history from the local database
  void _clearHistory(BuildContext context) async {
    try {
      final dbHelper = MarkerDatabaseHelper.instance;
      await dbHelper
          .clearMarkers(); // Implement this method in your database helper
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('History cleared'),
        ),
      );
      // You may want to navigate back to the previous screen or take any other action
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error clearing history: $e'),
        ),
      );
    }
  }
}
