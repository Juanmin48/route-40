import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_40/widgets/rdetails.dart';

class RDetails extends StatefulWidget {
  final String index, name, company, origin, destination, time;
  const RDetails(
      {Key key,
      @required this.index,
      @required this.name,
      @required this.company,
      @required this.origin,
      @required this.destination,
      @required this.time})
      : super(key: key);
  @override
  _RDetailsState createState() => _RDetailsState();
}

class _RDetailsState extends State<RDetails> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(
      11.018843, -74.850514); //Reemplazar aqui la posición de origen

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
              zoom: 18.0,
            ),
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
                          rdetails(widget.index, widget.name, widget.company,
                              widget.origin, widget.destination, widget.time),
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
