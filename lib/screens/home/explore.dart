import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsctokyo/components/network_utility.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/distance_matrix/distance_matrix_response.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:location/location.dart' as Loc;
import 'package:gdsctokyo/widgets/description_text.dart';
import 'package:gdsctokyo/widgets/panel_widget.dart';
import 'package:gdsctokyo/widgets/sorting_tab.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../components/location_list_tile.dart';
import '../../models/place_autocomplete/autocomplete_prediction.dart';
import '../../models/place_autocomplete/place_auto_complete_response.dart';
import '../../models/place_details/place_details_response.dart';
import '../../models/store/_store.dart';
import '../../routes/router.gr.dart';

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

  Loc.LocationData? currentLocation;
  late LatLng currLatLng;
  late Stream<List<DocumentSnapshot>> _storeStream;
  List<DocumentSnapshot> _storeSnapshots = [];

  final geo = GeoFlutterFire();
  final _firestore = FirebaseFirestore.instance;
  late GeoFirePoint currGeoPoint;

  bool searchWidgetSwitch = false;
  dynamic storeDistance = {};
  dynamic storeLst = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getCurrentLocation() {
    Loc.Location location = Loc.Location();
    location.getLocation().then((location) {
      setState(() {
        currentLocation = location;
        currLatLng = LatLng(location.latitude!, location.longitude!);
        currGeoPoint = geo.point(
            latitude: location.latitude!, longitude: location.longitude!);
      });
      setMapCameraToLatLng(currLatLng);
      setStoreDistance();
    }).catchError((e) {
      print("ERROR: $e");
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
          setMapCameraToLatLng(currLatLng);
          searchWidgetSwitch = false;
        });
      }
    }
  }

  void setMapCameraToLatLng(LatLng latlng) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng, zoom: 13.5)));
  }

  void setSearchWidgetSwitch(bool newValue) {
    setState(() {
      searchWidgetSwitch = newValue;
    });
  }

  void setMapController(GoogleMapController newController) {
    setState(() {
      mapController = newController;
    });
  }

  void setNearbyStores({double radius = 50000}) async {
    var collectionReference = _firestore.collection('stores');
    String field = 'location';
    setState(() {
      _storeStream = geo.collection(collectionRef: collectionReference).within(
          center: currGeoPoint, radius: radius, field: field, strictMode: true);
    });
    _storeStream.listen((List<DocumentSnapshot> documentList) {
      setState(() {
        _storeSnapshots = documentList;
      });
    });
  }

  Future<Map> getDistances(LatLng origin, List<LatLng> destinationLatlngLst,
      List<String> destinationStoreIdLst) async {
    Map distances = {};
    String destinationParam = '';
    destinationLatlngLst.asMap().forEach((key, value) {
      if (key > 0) {
        destinationParam += '|';
      }
      destinationParam +=
          value.latitude.toString() + ',' + value.longitude.toString();
    });
    Uri uri = Uri.https("maps.googleapis.com", "maps/api/distancematrix/json", {
      "origins": origin.latitude.toString() + ',' + origin.longitude.toString(),
      "destinations": destinationParam,
      "key": dotenv.get("ANDROID_GOOGLE_API_KEY"),
    });
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      DistanceMatrixResponse result =
          DistanceMatrixResponse.parseDistanceMatrix(response);
      if (result.status == "OK") {
        result.responses!.asMap().forEach((key, value) {
          distances[destinationStoreIdLst[key]] = value;
        });
      }
    }
    return distances;
  }

  Future<void> setStoreDistance() async {
    List<LatLng> destinationLatlngLst = [];
    List<String> destinationStoreIdLst = [];
    List storeDetails = [];
    for (final doc in _storeSnapshots) {
      dynamic data = doc.data();
      GeoPoint geoPoint = data['location']['geopoint'];
      LatLng latlng = LatLng(geoPoint.latitude, geoPoint.longitude);
      destinationLatlngLst.add(latlng);
      destinationStoreIdLst.add(doc.id);
    }
    Map distances = await getDistances(
        currLatLng, destinationLatlngLst, destinationStoreIdLst);
    for (final doc in _storeSnapshots) {
      Map store = {};
      store['id'] = doc.id;
      store['distance'] = distances[doc.id];
      store['data'] = doc.data();
      storeDetails.add(store);
    }
    setState(() {
      storeDistance = distances;
      storeLst = storeDetails;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    setNearbyStores();
    setStoreDistance();
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
                          : GMap(
                              // storeStream: _storeStream,
                              storeLst: storeLst,
                              currLatLng: currLatLng,
                              onMapCreated: _onMapCreated,
                            )),
                  Column(children: [
                    LocationSearchBox(
                      searchWidgetSwitch: searchWidgetSwitch,
                      setSearchWidgetSwitch: setSearchWidgetSwitch,
                      placeAutocomplete: placeAutocomplete,
                    ),
                    searchWidgetSwitch
                        ? UseMyLocationButton(
                            getCurrentLocation: getCurrentLocation,
                            setSearchWidgetSwitch: setSearchWidgetSwitch,
                          )
                        : const SizedBox.shrink(),
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
                    )
                  ]),
                ]),
          panel: Column(
            children: [
              GestureDetector(
                child: Center(
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
                child: const SortingTab(),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 10,
                  bottom: 10,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _storeSnapshots.length <= 1
                        ? _storeSnapshots.length.toString() + " place found"
                        : _storeSnapshots.length.toString() + " places found",
                  ),
                ),
              ),
              Expanded(child: PanelWidget(storeLst: storeLst))
              // child: ListView.builder(
              //     itemCount: storeLst.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return PanelWidget(storeData: storeLst[index]);
              //     }))
            ],
          )),
    );
  }
}

class GMap extends StatefulWidget {
  final storeLst;
  final LatLng currLatLng;
  final onMapCreated;
  // final storeDistances;
  const GMap({
    super.key,
    required this.storeLst,
    required this.currLatLng,
    required this.onMapCreated,
  });

  @override
  State<GMap> createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  final Set<Marker> markers = new Set();

  // Future<String?> calculateDistance(LatLng origin, LatLng destination) async {
  //   Uri uri = Uri.https("maps.googleapis.com", "maps/api/distancematrix/json", {
  //     "origins": origin.latitude.toString() + ',' + origin.longitude.toString(),
  //     "destinations": destination.latitude.toString() +
  //         ',' +
  //         destination.longitude.toString(),
  //     "key": dotenv.get("ANDROID_GOOGLE_API_KEY"),
  //   });
  //   String? response = await NetworkUtility.fetchUrl(uri);
  //   if (response != null) {
  //     DistanceMatrixResponse result =
  //         DistanceMatrixResponse.parseDistanceMatrix(response);
  //     if (result.distance != null) {
  //       return result.distance!;
  //     }
  //   }
  // }

  void getMarkers() async {
    for (final store in widget.storeLst) {
      GeoPoint geoPoint = store.data.location.geopoint;
      LatLng latlng = LatLng(geoPoint.latitude, geoPoint.longitude);
      markers.add(Marker(
          markerId: MarkerId(store.data.name),
          position: latlng,
          infoWindow: InfoWindow(
              title: store.data.name,
              snippet: store.distance.text + " from here",
              onTap: () {
                context.router.pushNamed('/store/${store.id}');
              })));
    }
  }
  // widget.storeStream.listen((documentList) async {
  //   for (final doc in documentList) {
  //     dynamic data = doc.data();
  //     GeoPoint geoPoint = data.location.geopoint;
  //     LatLng latlng = LatLng(geoPoint.latitude, geoPoint.longitude);
  //     String storeId = doc.id;
  //     // String? distanceFromCurr =
  //     //     await calculateDistance(widget.currLatLng, latlng);
  //     setState(() {
  //       markers.add(Marker(
  //         markerId: MarkerId(data.name),
  //         position: latlng,
  //         infoWindow: InfoWindow(
  //           title: data.name,
  //           // snippet: distanceFromCurr.toString() + " from here",
  //           onTap: () {
  //             context.router.pushNamed('/store/$storeId');
  //           },
  //         ),
  //       ));
  //     });
  //   }
  // });
  // }

  @override
  void initState() {
    super.initState();
    getMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: widget.onMapCreated,
      initialCameraPosition: CameraPosition(
        target: widget.currLatLng,
        zoom: 13.5,
      ),
      markers: markers,
    );
  }
}

class UseMyLocationButton extends StatelessWidget {
  final getCurrentLocation;
  final ValueChanged<bool> setSearchWidgetSwitch;
  const UseMyLocationButton(
      {super.key,
      required this.getCurrentLocation,
      required this.setSearchWidgetSwitch});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          onPressed: () {
            getCurrentLocation();
            setSearchWidgetSwitch(false);
          },
          icon: Icon(Icons.place),
          label: const Text("Use my Current Location"),
        ));
  }
}

class LocationSearchBox extends StatelessWidget {
  final bool searchWidgetSwitch;
  final ValueChanged<bool> setSearchWidgetSwitch;
  final ValueChanged<String> placeAutocomplete;
  const LocationSearchBox(
      {super.key,
      required this.searchWidgetSwitch,
      required this.setSearchWidgetSwitch,
      required this.placeAutocomplete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          onTap: () {
            setSearchWidgetSwitch(true);
          },
          onChanged: (value) {
            placeAutocomplete(value);
            setSearchWidgetSwitch(true);
          },
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
