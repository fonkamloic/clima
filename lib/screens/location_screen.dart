import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/screens/city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});
  final dynamic locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel newWeatherModel;
  dynamic temperature;
  dynamic temp;
  String condition;
  String cityName;
  String weatherMessage;

  String newCityName;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
    newWeatherModel = WeatherModel();
//    dynamic newWeatherData = await WeatherModel().getWeatherModel();
//    updateUI(newWeatherData);
  }

  void updateUI(dynamic weatherData) {
    print(weatherData);
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        condition = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = ' ';
        print('WeatherData is null');
        return;
      }
      temperature = weatherData['main']['temp'];
      int cond = weatherData['weather'][0]['id'];
      temp = temperature.toInt();
      cityName = weatherData['name'];
      print(temperature);
      print(cond);
      condition = WeatherModel().getWeatherIcon(cond);
      weatherMessage = WeatherModel().getMessage(temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      dynamic weatherData =
                          await newWeatherModel.getWeatherModel();
                      setState(() {
                        updateUI(weatherData);
                      });
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      newCityName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CityScreen(),
                        ),
                      );
                      if (newCityName != null) {
                        dynamic newCityWeather =
                            await newWeatherModel.getCityWeather(newCityName);
                        updateUI(newCityWeather);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "$temp°",
                      style: kTempTextStyle,
                    ),
                    Text(
                      condition,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $cityName !",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
