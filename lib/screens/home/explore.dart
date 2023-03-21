import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsctokyo/components/network_utility.dart';
import 'package:location/location.dart';
import 'package:gdsctokyo/widgets/explore/panel_widget.dart';
import 'package:gdsctokyo/widgets/explore/sorting_tab.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gdsctokyo/components/location_list_tile.dart';
import 'package:gdsctokyo/models/place_autocomplete/autocomplete_prediction.dart';
import 'package:gdsctokyo/models/place_autocomplete/place_auto_complete_response.dart';
import 'package:gdsctokyo/models/place_details/place_details_response.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  TextEditingController textController = TextEditingController();
  final PanelController panelController = PanelController();

  late GoogleMapController mapController;

  List<AutocompletePrediction> placePredictions = [];

  LocationData? currentLocation;
  LatLng currLatLng = const LatLng(0.0, 0.0);

  bool searchWidgetSwitch = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getCurrentLocation() {
    Location location = Location();
    location
        .getLocation()
        .then((location) => {
              setState(() {
                currentLocation = location;
                currLatLng = LatLng(location.latitude!, location.longitude!);
              }),
            })
        // ignore: body_might_complete_normally_catch_error
        .catchError((error) {});
  }

  Future<void> placeAutocomplete(String query) async {
    Uri uri =
        Uri.https('maps.googleapis.com', 'maps/api/place/autocomplete/json', {
      'input': query,
      'key': dotenv.get('ANDROID_GOOGLE_API_KEY'),
    });
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  Future<void> setMapCameraviewToPlaceId(String placeId) async {
    Uri uri = Uri.https('maps.googleapis.com', 'maps/api/place/details/json', {
      'place_id': placeId,
      'key': dotenv.get('ANDROID_GOOGLE_API_KEY'),
    });
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      PlaceDetailsResponse result =
          PlaceDetailsResponse.parsePlaceDetails(response);
      if (result.lat != null && result.lng != null) {
        setState(() {
          currLatLng = LatLng(result.lat!, result.lng!);
          mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: currLatLng, zoom: 13.5)));
          searchWidgetSwitch = false;
        });
      }
    }
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
              ? const Center(child: Text('Loading'))
              : Stack(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: searchWidgetSwitch
                        ? Container(
                            color: Colors.white,
                          )
                        : GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: currLatLng,
                              zoom: 13.5,
                            ),
                          ),
                  ),
                  Column(children: [
                    // LocationSearchBox(),sdlj
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          onTap: () {
                            setState(() {
                              searchWidgetSwitch = true;
                            });
                          },
                          onChanged: (value) {
                            placeAutocomplete(value);
                            setState(() {
                              searchWidgetSwitch = true;
                            });
                          },
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Search Location',
                            suffixIcon: const Icon(Icons.search),
                            contentPadding: const EdgeInsets.only(
                                left: 20, bottom: 5, right: 5),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          )),
                    ),
                    // UseMyLocationButton(),
                    Expanded(
                      child: searchWidgetSwitch
                          ? ListView.builder(
                              itemCount: placePredictions.length,
                              itemBuilder: (context, index) => LocationListTile(
                                  location:
                                      placePredictions[index].description!,
                                  press: () {
                                    String placeId =
                                        placePredictions[index].placeId!;
                                    setMapCameraviewToPlaceId(placeId);
                                  }))
                          : const SizedBox.shrink(),
                    ),
                  ]),
                ]),
          panelBuilder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      child: Container(
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
                  ),
                  const SortingTab(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Latest in the area',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PanelWidget(
                    controller: controller,
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class UseMyLocationButton extends StatelessWidget {
  const UseMyLocationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: SvgPicture.asset(
            'assets/icons/location.svg',
            height: 16,
          ),
          label: const Text('Use my Current Location'),
        ));
  }
}

class LocationSearchBox extends StatelessWidget {
  const LocationSearchBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          onChanged: (value) {},
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Search Location',
            suffixIcon: const Icon(Icons.search),
            contentPadding:
                const EdgeInsets.only(left: 20, bottom: 5, right: 5),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white),
            ),
          )),
    );
  }
}
