import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(
      {Key? key, required this.onMapCreated, required this.location})
      : super(key: key);
  final Function(GoogleMapController controller) onMapCreated;
  final LatLng location;
  static const CameraPosition kGooglePosition = CameraPosition(
    target: LatLng(10.8468936, 106.6408852),
    zoom: 14.5,
  );

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Future _mapFuture =
      Future.delayed(const Duration(milliseconds: 250), () => true);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: FutureBuilder(
        future: _mapFuture,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          return GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            markers: {
              Marker(
                markerId: const MarkerId("home"),
                draggable: true,
                position: widget.location,
                zIndex: 2,
                flat: true,
                anchor: const Offset(0.5, 0.5),
              ),
            },
            initialCameraPosition: MapWidget.kGooglePosition,
            onCameraMove: (position) {},
            onCameraIdle: () {},
            onMapCreated: (GoogleMapController controller) {
              widget.onMapCreated(controller);
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: widget.location, tilt: 0, zoom: 14.5),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
