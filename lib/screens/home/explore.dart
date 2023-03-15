import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsctokyo/components/network_utility.dart';
import 'package:location/location.dart';
import 'package:gdsctokyo/widgets/description_text.dart';
import 'package:gdsctokyo/widgets/panel_widget.dart';
import 'package:gdsctokyo/widgets/sorting_tab.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../components/location_list_tile.dart';
import '../../models/place_autocomplete/autocomplete_prediction.dart';
import '../../models/place_autocomplete/place_auto_complete_response.dart';

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
              }),
            })
        // ignore: body_might_complete_normally_catch_error
        .catchError((error) {
      debugPrint('Error caught in getCurrentLocation: $error');
    });
  }

  void placeAutocomplete(String query) async {
    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
      "input": query,
      "key": dotenv.get("ANDROID_GOOGLE_API_KEY"),
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
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                      zoom: 13.5,
                    ),
                  ),
                ),
                Column(children: [
                  // LocationSearchBox(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) {
                        placeAutocomplete(value);
                      },
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search Location',
                        suffixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.only(left: 20, bottom: 5, right: 5),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      )
                    ),
                  ),
                    // UseMyLocationButton(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: placePredictions.length,
                      itemBuilder: (context, index) => LocationListTile(
                        location: placePredictions[index].description!,
                        press: () {}
                      )
                    ),
                  ),
                ]),
              ]),
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
                  child: const SortingTab(),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 10,
                    bottom: 10,
                  ),
                  child: const Align(
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

class UseMyLocationButton extends StatelessWidget {
  const UseMyLocationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          onPressed: () {
          },
          icon: SvgPicture.asset(
            "assets/icons/location.svg",
            height: 16,
          ),
          label: const Text("Use my Current Location"),
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
            suffixIcon: Icon(Icons.search),
            contentPadding: EdgeInsets.only(left: 20, bottom: 5, right: 5),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white),
            ),
          )),
    );
  }
}
