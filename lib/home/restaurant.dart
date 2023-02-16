import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/description_text.dart';
import 'package:gdsctokyo/widgets/panel_widget.dart';
import 'package:gdsctokyo/widgets/sorting_tab.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Restaurant extends StatefulWidget {  
  const Restaurant({super.key});


  @override
  State<Restaurant> createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  TextEditingController textController = TextEditingController();
  final PanelController panelController = PanelController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
          controller: panelController,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
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
                    margin: EdgeInsets.only(
                      top: 8,
                    ),
                    width: 50,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  onVerticalDragDown: (DragDownDetails details) {panelController.close();},
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: SortingTab(),
                ),
                Container(
                  padding: EdgeInsets.only(
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

