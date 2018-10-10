import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

var api_key = "AIzaSyBR4P3_68H4QDUqoa7Mx3tRXbQBf25vzkA";

class ShopScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ShopScreenState();
  }
}

class ShopScreenState extends State<ShopScreen> {
    MapView mapView = new MapView();

  List<Marker> markers = <Marker>[
    new Marker("1", "BSR Restuarant", 22.72, 75.853,
        color: Colors.amber),
    new Marker("2", "Flutter Institute", 22.7194, 75.8573,
        color: Colors.purple),
  ];

  showMap() {
    mapView.show(new MapOptions(
        mapViewType: MapViewType.normal,
        initialCameraPosition:
            new CameraPosition(new Location(22.7196, 75.8577), 15.0),
        showUserLocation: true,
        showCompassButton: true,
        showMyLocationButton: true,
        hideToolbar: true,
        title: "Google Maps"));
    mapView.setMarkers(markers);
    mapView.zoomToFit(padding: 100);

    mapView.onMapTapped.listen((_) {
      setState(() {
        mapView.setMarkers(markers);
        mapView.zoomToFit(padding: 100);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child:new Text("Welcome to Google Maps!", style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.blue),
      ),
      ),
    );
  }


}