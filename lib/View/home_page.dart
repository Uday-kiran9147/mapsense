import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapsense/ViewModel/home_view_model.dart';
import 'package:provider/provider.dart';

import 'history_page.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title:  Text('Mapsense', style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryPage(),
                  ));
            },
            icon: const Icon(Icons.history),
          )
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (_, homeViewModel, child) {
          return homeViewModel.currentPosition == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GoogleMap(
                  onMapCreated: homeViewModel.onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: homeViewModel.currentPosition ??
                        homeViewModel.mapHistorySet.first.position,
                    zoom: 13,
                  ),
                  compassEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: homeViewModel.mapHistorySet,
                );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<HomeViewModel>(context, listen: false)
              .collectCoordinates();
        },
        tooltip: 'Collect Coordinates',
        child: const Icon(Icons.add_location),
      ),
    );
  }
}
