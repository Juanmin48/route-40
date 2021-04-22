import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_40/widgets/rdetails.dart';

class RDetails extends StatefulWidget {
  final String index;
  final dynamic route;
  final User user;
  const RDetails(
      {Key key, @required this.index, @required this.route, this.user})
      : super(key: key);
  @override
  _RDetailsState createState() => _RDetailsState();
}

class _RDetailsState extends State<RDetails> {
  GoogleMapController mapController;
  LatLng _center; //Reemplazar aqui la posición de origen
  List<Polyline> myPolyline = [];
  final Set<Marker> _markers = Set();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _center = LatLng(widget.route['pointInit']['_latitude'],
          widget.route['pointInit']['_longitude']);
      LatLng origin = LatLng(double.parse(widget.route['origin']['y']),
          double.parse(widget.route['origin']['x']));
      _markers.add(Marker(markerId: MarkerId('pointInit'), position: _center));
      _markers.add(Marker(
          markerId: MarkerId('pointInit'),
          position: origin,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
    });
    createPolyline();
  }

  createPolyline() {
    print(widget.route);
    List<LatLng> points = [];
    for (var item in widget.route['route']) {
      points.add(LatLng(item['_latitude'], item['_longitude']));
    }
    print(points);
    myPolyline.add(
      Polyline(
          polylineId: PolylineId('1'),
          color: Colors.black,
          width: 3,
          points: points),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 17.0,
            ),
            polylines: myPolyline.toSet(),
            markers: _markers,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.only(
                  bottom: 16.0, top: 36.0, left: 16.0, right: 16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 460.0,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color.fromRGBO(38, 28, 20, 0.8),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 15.0,
                          ),
                          rdetails(
                              widget.index,
                              widget.route['nameR'],
                              widget.route['nameE'],
                              'Origen: x: ${widget.route['pointInit']['_latitude'].toString()}, y: ${widget.route['pointInit']['_longitude'].toString()}',
                              'Destino: x: ${widget.route['pointInit']['_latitude'].toString()}, y: ${widget.route['pointInit']['_longitude'].toString()}',
                              widget.route['time']),
                          SizedBox(
                            height: 15.0,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
