import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/api/osm_nominatim_dlient.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:go_router/go_router.dart";
import "package:latlong2/latlong.dart";

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

// TODO: Translate this file
class _DiscoverScreenState extends State<DiscoverScreen> {
  Future<Iterable<Event>> events = Future.value([]);
  Future<Iterable<Profile>> profiles = Future.value([]);

  void search(String value) {
    setState(() {
      events = Event.findAll();
      profiles = Profile.search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: CupertinoSearchTextField(
            onSubmitted: search,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge!.color,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Events"),
              Tab(text: "Profiles"),
            ],
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: TabBarView(children: [
          eventList,
          profileList,
        ]),
      ),
    );
  }

  Widget get profileList => Column(
        children: [
          FutureBuilder(
            future: profiles,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text(snapshot.error!.toString());
              }

              final profiles = snapshot.data!.map(listItemProfile).toList();

              return Expanded(
                child: ListView.separated(
                  itemCount: profiles.length,
                  itemBuilder: (context, index) => profiles[index],
                  separatorBuilder: (context, index) => const Divider(),
                ),
              );
            },
          )
        ],
      );

  Widget get eventList => Column(
        children: [
          FutureBuilder(
              future: userLatLng(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      center: snapshot.data!,
                      zoom: 11,
                      maxZoom: 18.2,
                    ),
                    nonRotatedChildren: [
                      AttributionWidget.defaultWidget(
                        source: "OpenStreetMap contributors",
                        onSourceTapped: null,
                      ),
                    ],
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png",
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: snapshot.data!,
                            builder: (context) => const FlutterLogo(),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
        ],
      );

  Widget listItemEvent(Event event) => GestureDetector(
        onTap: () => context.push("/events/${event.id}"),
        child: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.centerLeft,
          child: Column(children: [
            Text(
              event.title,
              style: Theme.of(context).primaryTextTheme.titleMedium,
            )
          ]),
        ),
      );

  Widget listItemProfile(Profile profile) => GestureDetector(
        onTap: () => context.push("/profiles/${profile.id}"),
        child: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.centerLeft,
          child: Column(children: [
            Text(
              profile.displayName,
              style: Theme.of(context).primaryTextTheme.titleMedium,
            )
          ]),
        ),
      );
}
