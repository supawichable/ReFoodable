import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/big_text.dart';
import 'package:location/location.dart';
import 'package:gdsctokyo/widgets/description_text.dart';
import 'package:gdsctokyo/widgets/panel_widget.dart';
import 'package:gdsctokyo/widgets/sorting_tab.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Restaurant extends StatefulWidget {
  const Restaurant({super.key});


  @override
  State<Restaurant> createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  TextEditingController textController = TextEditingController();
  final PanelController panelController = PanelController();

  late GoogleMapController mapController;

  // static const LatLng currentLocation = LatLng(60.521563, -122.677433);
  LocationData? currentLocation;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getCurrentLocation() {
    Location location = Location();
    // bool _serviceEnabled;
    // PermissionStatus _permissionGranted;
    // LocationData _locationData;

    // debugPrint('HERE');
    // _serviceEnabled = await location.serviceEnabled();
    // debugPrint('serviceEnabled: $_serviceEnabled');
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     return;
    //   }
    // }

    // _permissionGranted = await location.hasPermission();
    // if (_permissionGranted == PermissionStatus.denied) {
    //   _permissionGranted = await location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {
    //     return;
    //   }
    // }

    // debugPrint('permissionGranted: $_permissionGranted');

    // currentLocation = await location.getLocation();
    location
        .getLocation()
        .then((location) => {
              setState(() {
                currentLocation = location;
                // debugPrint('currentLocation: $currentLocation');
              }),
            })
        .catchError((onError) {
          debugPrint("Error caught in getCurrentLocation: $onError");
        });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
          controller: panelController,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          body: currentLocation == null
              ? const Center(child: Text("Loading"))
              : Stack(children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                        zoom: 13.5,
                      ),
                    ),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search Location',
                        suffixIcon: Icon(Icons.search)),
                  )
                ]),
          // body: Column(
          //   children: [
          //     Container(
          //       margin: EdgeInsets.only(left: 10, right: 10),
          //       child: AnimSearchBar(
          //         width: 400,
          //         textController: textController,
          //         onSuffixTap: () {
          //           setState(() {
          //             textController.clear();
          //           });
          //         },
          //         autoFocus: true,
          //         closeSearchOnSuffixTap: true,
          //         animationDurationInMilli: 100,
          //         onSubmitted: (string) {
          //           return debugPrint('do nothing');
          //         },
          //       ),
          //     )
          //   ],
          // ),
          panelBuilder: (controller) {
            return Column(
              children: [
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 8,
                    ),
                    width: 50,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  onVerticalDragDown: (DragDownDetails details) {
                    panelController.close();
                  },
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: SortingTab(),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: DescriptionText(
                        text: 'n places found',
                        size: 14,
                      )),
                ),
                PanelWidget(
                  controller: controller,
                ),
              ],
            );
          }),
    );
  }
}
