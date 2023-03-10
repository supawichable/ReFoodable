import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:gdsctokyo/util/logger.dart';
import 'package:gdsctokyo/widgets/description_text.dart';

class StoreCard extends StatefulWidget {
  final String storeId;
  final Store? store;

  const StoreCard({
    Key? key,
    required this.store,
    required this.storeId,
  }) : super(key: key);

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  late final String? ownerId = widget.store?.ownerId;
  late final Future<String?> ownerName = FirebaseFirestore.instance.usersPublic
      .doc(widget.store?.ownerId)
      .get()
      .then((snapshot) {
    return snapshot.data()?.displayName;
  });
  late final bool editable = ownerId != null
      ? FirebaseAuth.instance.currentUser!.uid == ownerId
      : false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Store Info',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.apply(fontWeightDelta: 2)),
            if (editable)
              TextButton(
                onPressed: () {
                  context.router.push(StoreFormRoute(
                    storeId: widget.storeId,
                  ));
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(
                  'edit',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              )
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.25),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 3),
              )
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_pin,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.store?.address ?? '(No address)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.bento,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.store?.category?.map((e) => e.name).join(', ') ??
                        '(No category)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
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
                      Icons.schedule,
                      size: 20,
                    ),
                  ),
                  Text(
                    '(No Schedule)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  FutureBuilder<String?>(
                      future: ownerName,
                      builder: (context, snapshot) {
                        return Text(snapshot.data ?? ownerId ?? '(No owner)',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ));
                      }),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.email,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.store?.email ?? '(No email)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.call,
                    size: 20,
                  ),
                  Text(
                    widget.store?.phone ?? '(No phone)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
