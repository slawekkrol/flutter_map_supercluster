import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:flutter_map_supercluster_example/drawer.dart';
import 'package:flutter_map_supercluster_example/main.dart';
import 'package:latlong2/latlong.dart';

class BasicExamplePage extends StatelessWidget {
  static const String route = 'basicExamplePage';

  static const _totalMarkers = 3000;
  static final _random = Random(42);
  static const _initialCenter = LatLng(42.0, 10.0);
  static final _markers = List<Marker>.generate(
    _totalMarkers,
    (_) => Marker(
      builder: (context) => const Icon(Icons.location_on),
      point: LatLng(
        _random.nextDouble() * 3 - 1.5 + _initialCenter.latitude,
        _random.nextDouble() * 3 - 1.5 + _initialCenter.longitude,
      ),
    ),
  );

  const BasicExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Example')),
      drawer: buildDrawer(context, route),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: _initialCenter,
          initialZoom: 8,
          maxZoom: 19,
        ),
        children: <Widget>[
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: tileLayerPackageName,
          ),
          SuperclusterLayer.immutable(
            initialMarkers: _markers,
            indexBuilder: IndexBuilders.computeWithOriginalMarkers,
            clusterWidgetSize: const Size(40, 40),
            maxClusterRadius: 120,
            clusterAnchorPos: const AnchorPos.align(AnchorAlign.center),
            builder: (context, position, markerCount, extraClusterData) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.blue),
                child: Center(
                  child: Text(
                    markerCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
