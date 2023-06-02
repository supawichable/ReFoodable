import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gdsctokyo/components/network_utility.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/distance_matrix/distance_matrix_response.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/providers/explore.dart';
import 'package:gdsctokyo/routes/router.dart';
import 'package:gdsctokyo/util/logger.dart';
import 'package:gdsctokyo/widgets/store_page/store_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// will uncomment the sorting_tab when needed
// ignore: unused_import
import 'package:gdsctokyo/widgets/explore/sorting_tab.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gdsctokyo/components/location_list_tile.dart';
import 'package:gdsctokyo/models/place_autocomplete/autocomplete_prediction.dart';
import 'package:gdsctokyo/models/place_autocomplete/place_auto_complete_response.dart';
import 'package:gdsctokyo/models/place_details/place_details_response.dart';

final _firestore = FirebaseFirestore.instance;

@RoutePage()
class ExplorePage extends StatefulHookConsumerWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final PanelController panelController = PanelController();

  /// 1. currentPositionProvider
  /// This is a provider that will be used to get the current location
  /// as a context throughout the app
  /// more info: providers/explore.dart
  late final CurrentLocationNotifier currentLocationNotifier =
      ref.read(currentLocationProvider.notifier);

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
        LatLng latlng = LatLng(result.lat!, result.lng!);
        await setMapCameraToLatLng(latlng);
        setSearchWidgetSwitch(false);
      }
    }
  }

  /// If we set it to an asynchronous function, we can know when the camera
  /// has finished moving then we can safely do something with the mapController
  Future<void> setMapCameraToLatLng(LatLng latlng) async {
    await ref.read(mapControllerProvider)?.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: latlng, zoom: 13.5)));
  }

  /// 3. SearchController
  final TextEditingController textController = TextEditingController();
  List<AutocompletePrediction> placePredictions = [];
  bool searchWidgetSwitch = false;
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

  /// Distance Matrix
  /// This is used to cache the distance between the current location.
  /// Could be accessed through [id]
  late Map<String, String> storeDistances;

  @override
  void initState() {
    super.initState();
    // request permission
  }

  late double _fabPos = 0.9 * 350;

  @override
  Widget build(BuildContext context) {
    final currentLocationState = ref.watch(currentLocationProvider);
    final storesStream = ref.watch(storesStreamProvider);

    return Scaffold(
      body: SlidingUpPanel(
        onPanelSlide: (_) => setState(() {
          _fabPos = 350 * (0.9 + _);
        }),
        minHeight: 150,
        controller: panelController,
        color: Theme.of(context).colorScheme.surface,
        body: Stack(children: [
          const GMap(),
          currentLocationState.when(
              success: (locationData, latLng, geoPoint) => Column(children: [
                    LocationSearchBox(
                      searchWidgetSwitch: searchWidgetSwitch,
                      setSearchWidgetSwitch: setSearchWidgetSwitch,
                      placeAutocomplete: placeAutocomplete,
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          final mapController = ref.read(mapControllerProvider);
                          if (mapController != null) {
                            ref
                                .read(storeQueryInputProvider.notifier)
                                .updateStoreStreamFromMapController(
                                    mapController);
                          }
                        },
                        icon: const Icon(Icons.search),
                        label: const Text('Search in this area')),
                    Expanded(
                      child: searchWidgetSwitch
                          ? ListView.builder(
                              itemCount: placePredictions.length,
                              itemBuilder: (context, index) => LocationListTile(
                                  location:
                                      placePredictions[index].description!,
                                  press: () async {
                                    String placeId =
                                        placePredictions[index].placeId!;
                                    await setMapCameraviewToPlaceId(placeId);
                                  }))
                          : const SizedBox.shrink(),
                    )
                  ]),
              failure: (String message) {
                return Center(child: Text(message));
              },
              standby: () {
                return Column(children: [
                  const LinearProgressIndicator(),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ]);
              }),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            bottom: _fabPos,
            right: 20,
            child: FloatingActionButton(
                onPressed: () async {
                  final location = await ref
                      .read(currentLocationProvider.notifier)
                      .getCurrentLocation();
                  if (location == null && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Location not found'),
                      ),
                    );
                  }
                  await ref.read(mapControllerProvider)?.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          target:
                              LatLng(location!.latitude!, location.longitude!),
                          zoom: 13.5)));
                },
                child: const Icon(Icons.my_location)),
          )
        ]),
        panelBuilder: (sc) => Column(children: [
          GestureDetector(
            child: Center(
              child: Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(
                  top: 8,
                ),
              ),
            ),
            onVerticalDragDown: (details) {
              panelController.close();
            },
          ),
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
          // Container(
          //   height: 50,
          //   padding: const EdgeInsets.only(
          //     left: 10,
          //     right: 10,
          //   ),
          //   child: const SortingTab(),
          // ),
          ...storesStream.when(
              data: (data) => [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 15,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          data.length <= 1
                              ? '${data.length} place found'
                              : '${data.length} places found',
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        controller: sc,
                        itemCount: data.length + 1,
                        itemBuilder: (context, index) {
                          if (index == data.length) {
                            return Container();
                          }
                          final storeDoc = data[index];
                          return StoreCard(
                              storeDoc.id,
                              Store.fromJson(
                                  storeDoc.data()! as Map<String, dynamic>),
                              distanceText:
                                  ref.read(storeDistanceProvider)[storeDoc.id]);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      ),
                    ),
                  ],
              error: (e, st) => [
                    const Center(
                      child: Text('Error'),
                    ),
                  ],
              loading: () => [const LinearProgressIndicator()]),
        ]),
      ),
    );
  }

  void setSearchWidgetSwitch(bool newValue) {
    setState(() {
      searchWidgetSwitch = newValue;
    });
  }
}

class GMap extends StatefulHookConsumerWidget {
  const GMap({super.key});

  @override
  ConsumerState<GMap> createState() => _GMapState();
}

class _GMapState extends ConsumerState<GMap> {
  late final StateController<GoogleMapController?> mapControllerNotifier =
      ref.read(mapControllerProvider.notifier);

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

  Future<Map<String, String>> getDistances(
      LatLng origin, List<PlaceOrStore> storeOrPlaceLst) async {
    // 1. Filter out cached distances
    final filteredStoreLst = storeOrPlaceLst
        .where(
            (store) => !ref.read(storeDistanceProvider).containsKey(store.id))
        .toList();

    // 2. Get the list of destinationLatLng for uncached distances
    final List<LatLng> destinationLatLngLst = filteredStoreLst
        .map((store) =>
            LatLng(store.geoFirePoint.latitude, store.geoFirePoint.longitude))
        .toList();

    // 3. Create a destinationParam which is a string of latlng separated by '|'
    String destinationParam = '';
    for (final latLng in destinationLatLngLst) {
      destinationParam += '${latLng.latitude},${latLng.longitude}|';
    }
    Uri uri = Uri.https('maps.googleapis.com', 'maps/api/distancematrix/json', {
      'origins': '${origin.latitude},${origin.longitude}',
      'destinations': destinationParam,
      'key': dotenv.get('ANDROID_GOOGLE_API_KEY'),
    });
    String? response = await NetworkUtility.fetchUrl(uri);
    // 4. Parse the response and save the result.responses.first.text
    // to the storeDistanceProvider while also returning the result
    if (response != null) {
      DistanceMatrixResponse result =
          DistanceMatrixResponse.parseDistanceMatrix(response);
      if (result.status == 'OK') {
        for (int i = 0; i < result.responses!.length; i++) {
          final storeDoc = filteredStoreLst[i];
          final String? distance = result.responses![i].text;
          if (distance == null) {
            continue;
          }
          ref
              .read(storeDistanceProvider)
              .putIfAbsent(storeDoc.id, () => distance);
        }
      }
    }

    return ref.read(storeDistanceProvider);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(placesAndStoresWrapperProvider, (pref, storeLst) {
      ref.read(currentLocationProvider).whenOrNull(
          success: (locationData, latLng, geoFirePoint) async {
        try {
          // might error out if something wrong with the response
          await getDistances(latLng, storeLst);
          setState(() {});
        } catch (e, stackTrace) {
          logger.e('Oh no. Can\'t get distances', e, stackTrace);
        }
      });
    });

    final Set<Marker> markers =
        ref.watch(placesAndStoresWrapperProvider).map((placeOrStore) {
      final geoPoint = placeOrStore.geoFirePoint;
      LatLng latlng = LatLng(geoPoint.latitude, geoPoint.longitude);

      return Marker(
          markerId: MarkerId(placeOrStore.id),
          position: latlng,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              placeOrStore.type == PlaceOrStoreType.place
                  ? BitmapDescriptor.hueYellow
                  : BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
              title: placeOrStore.name,
              snippet:
                  '${ref.watch(storeDistanceProvider)[placeOrStore.id] ?? '...'} from here',
              onTap: () async {
                if (placeOrStore.type == PlaceOrStoreType.store) {
                  context.router.pushNamed('/store/${placeOrStore.id}');
                  return;
                }

                // Handle user not logged in
                if (FirebaseAuth.instance.currentUser == null) {
                  // show dialog to login
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Login'),
                          content: const Text(
                              'This store is not yet registered. Please login to be the first to register it!'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  context.router.push(const SignInRoute());
                                },
                                child: const Text('Login')),
                            // dismiss the dialog
                          ],
                        );
                      });
                  return;
                }

                _firestore.stores
                    .where('placeId', isEqualTo: placeOrStore.id)
                    .get()
                    .then((value) {
                  if (value.docs.isNotEmpty) {
                    context.router.pushNamed('/store/${value.docs.first.id}');
                  } else {
                    _firestore.stores
                        .add(Store(
                      name: placeOrStore.name,
                      placeId: placeOrStore.id,
                      address: placeOrStore.address,
                      location: placeOrStore.geoFirePoint,
                      ownerId: FirebaseAuth.instance.currentUser!.uid,
                    ))
                        .then((value) {
                      context.router.pushNamed('/store/${value.id}');
                    }).catchError((error) {
                      logger.e(error);
                    });
                  }
                });
              }));
    }).toSet();

    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onTap: (_) {
        FocusScope.of(context).unfocus();
      },
      onMapCreated: (controller) {
        mapControllerNotifier.update((state) => controller);
        ref
            .read(currentLocationProvider.notifier)
            .getCurrentLocation()
            .then((_) {
          ref.read(currentLocationProvider).when(
            success: (locationData, latLng, geoFirePoint) async {
              await controller.animateCamera(CameraUpdate.newLatLng(latLng));
              Future<void>.delayed(const Duration(seconds: 2), () async {
                await ref
                    .read(storeQueryInputProvider.notifier)
                    .updateStoreStreamFromMapController(controller);
              });
            },
            failure: (String message) {
              logger.e(message);
            },
            standby: () {
              logger.w('Still in standby state. Something might went wrong.');
            },
          );
        });
      },
      initialCameraPosition: CameraPosition(
        target: ref.read(currentLocationProvider).maybeWhen(
            orElse: () => const LatLng(
                  35.681236,
                  139.767125,
                ),
            success: (_, latlng, __) => latlng),
        zoom: 13.5,
      ),
      markers: markers,
    );
  }
}

class UseMyLocationButton extends ConsumerWidget {
  final ValueChanged<bool> setSearchWidgetSwitch;
  const UseMyLocationButton({super.key, required this.setSearchWidgetSwitch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          onPressed: () async {
            await ref
                .read(currentLocationProvider.notifier)
                .getCurrentLocation();
            ref.read(mapControllerProvider)?.animateCamera(
                CameraUpdate.newLatLng(
                    ref.read(currentLocationProvider).maybeWhen(
                        orElse: () => const LatLng(
                              35.681236,
                              139.767125,
                            ),
                        success: (_, latlng, __) => latlng)));
            setSearchWidgetSwitch(false);
          },
          icon: const Icon(Icons.place),
          label: const Text('Use my Current Location'),
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
            fillColor: Theme.of(context).colorScheme.surface,
            hintText: 'Search Location',
            suffixIcon: const Icon(Icons.search),
            contentPadding:
                const EdgeInsets.only(left: 20, bottom: 5, right: 5),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.surfaceVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.surfaceVariant),
            ),
          )),
    );
  }
}
