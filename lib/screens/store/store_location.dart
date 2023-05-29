import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/util/logger.dart';
// ignore: unused_import
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

final _geo = GeoFlutterFire();

@RoutePage()
class StoreLocationPage extends StatefulWidget {
  final locationField;
  const StoreLocationPage({super.key, required this.locationField});

  @override
  State<StoreLocationPage> createState() => _StoreLocationPageState();
}

class _StoreLocationPageState extends State<StoreLocationPage> {
  late GoogleMapController mapController;
  LatLng? currLatLng;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {
      setState(() {
        currLatLng = LatLng(location.latitude!, location.longitude!);
      });
    }).catchError((e) {
      logger.e('_getCurrentLocation error: $e');
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Set Store's Location")),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            widget.locationField.didChange(_geo.point(
                latitude: currLatLng!.latitude,
                longitude: currLatLng!.longitude));
            context.router.pop();
          },
          label: const Row(
            children: [
              Icon(Icons.save),
              Text('Save'),
            ],
          ),
        ),
        body: currLatLng == null
            ? const Center(child: Text('Loading'))
            : GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: currLatLng!,
                  zoom: 13.5,
                ),
                markers: <Marker>{
                    Marker(
                        draggable: true,
                        markerId: const MarkerId('1'),
                        position: currLatLng!,
                        onDragEnd: ((newPosition) {
                          setState(() {
                            currLatLng = LatLng(
                                newPosition.latitude, newPosition.longitude);
                          });
                        }))
                  }));
  }
}
