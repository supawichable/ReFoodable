import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/description_text.dart';

class StoreCard extends StatefulWidget {
  final dynamic data;
  final bool edit;

  const StoreCard({
    Key? key,
    required this.data,
    required this.edit,
  }) : super(key: key);

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  late final String ownerId;
  late final DocumentReference ownerRef;
  @override
  void initState() {
    super.initState();
    ownerId = widget.data.ownerId;
    ownerRef = FirebaseFirestore.instance.collection('owners').doc(ownerId);
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
        left: 10,
        bottom: 10,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Store Info',
                maxLines: 1, // making sure overflow works propperly
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                ),
              ),
              widget.edit
                  ? TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size.zero),
                        visualDensity: VisualDensity.compact,
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.zero),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                      ),
                      child: Text(
                        'edit',
                        maxLines: 1, // making sure overflow works propperly
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  : SizedBox.shrink()
            ],
          ),
          Container(
            // height: 130,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 3),
              )
            ]),
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 18,
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            right: 10,
                          ),
                          child: const Icon(
                            Icons.location_pin,
                            size: 20,
                          ),
                        ),
                        Text(
                          widget.data.address,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.shadow,
                                  ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: const Icon(
                          Icons.bento,
                          size: 20,
                        ),
                      ),
                      const DescriptionText(size: 16, text: 'Bento')
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: const Icon(
                          Icons.schedule,
                          size: 20,
                        ),
                      ),
                      const DescriptionText(size: 16, text: '11:00-23:00')
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 20,
                        ),
                      ),
                      const DescriptionText(size: 16, text: 'Natpawee')
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: const Icon(
                          Icons.email,
                          size: 20,
                        ),
                      ),
                      Text(
                        widget.data.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.shadow,
                            ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: const Icon(
                          Icons.call,
                          size: 20,
                        ),
                      ),
                      Text(
                        widget.data.phone,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.shadow,
                            ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
