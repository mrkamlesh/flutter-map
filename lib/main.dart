import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapbox App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Mapbox Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //FIXME: Add your Mapbox access token here
  static const String ACCESS_TOKEN =
      "pk.eyJ1IjoibXJrYW1sZXNoIiwiYSI6ImNrZjZka2p3NzBkN2EycnFnaDhib3lramkifQ.1s4mNcbxVR75Ts_xXMOuEA";
  final Location location = Location();

  Future<void> _showInfoDialog() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Demo Application'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Created by Kamlesh Kumar'),
                InkWell(
                  child: Text(
                    'https://github.com/tobrun/flutter-mapbox-gl',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () =>
                      launch('https://github.com/tobrun/flutter-mapbox-gl'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  MapboxMapController controller;
  Symbol _selectedSymbol;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onSymbolTapped.add(_onSymbolTapped);
    this.controller.addSymbol(
          SymbolOptions(
              geometry: LatLng(26.8361416, 85.1600435),
              iconImage: "airport-15"),
        );
  }

  void _onSymbolTapped(Symbol symbol) {
    if (_selectedSymbol != null) {
      _updateSelectedSymbol(
        const SymbolOptions(iconSize: 1.0),
      );
    }
    setState(() {
      _selectedSymbol = symbol;
    });
    _updateSelectedSymbol(
      SymbolOptions(
        iconSize: 1.4,
      ),
    );
  }

  void _updateSelectedSymbol(SymbolOptions changes) {
    controller.updateSymbol(_selectedSymbol, changes);
  }

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(26.8361416, 85.1600435),
    zoom: 11.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: _showInfoDialog,
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 300.0,
                child: MapboxMap(
                  accessToken: ACCESS_TOKEN,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: _kInitialPosition,
                  trackCameraPosition: true,
                  myLocationEnabled: true,
                  myLocationRenderMode: MyLocationRenderMode.GPS,
                  onMapClick: (point, latLng) async {
                    print(
                        "Map click: ${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
                  },
                  onMapLongClick: (point, latLng) async {
                    print(
                        "Map long press: ${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
