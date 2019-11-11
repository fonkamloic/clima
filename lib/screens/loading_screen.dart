import 'package:clima/screens/location_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  dynamic weatherModel;
  @override
  void initState() {
    super.initState();

    getLocationData();
  }

  void getLocationData() async {
    weatherModel = await WeatherModel().getWeatherModel();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LocationScreen(locationWeather: weatherModel);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        body: Center(
          child: SpinKitDoubleBounce(
            color: Colors.white,
            size: 100,
          ),
        ),
      );
    } catch (e) {
      print(e);
      return Column();
    }
  }
}
