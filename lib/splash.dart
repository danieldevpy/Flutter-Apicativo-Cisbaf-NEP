import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'start.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds:5),(){
      Navigator.pushReplacement(context,MaterialPageRoute(
        builder: (context)=>MyApp(),
      ));
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async { 
          print('teste');
          
          return false;
         },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage('images/logo.png')),
              Text('Loading...',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 5.0,),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blue),
                strokeWidth: 11.0,
              ),
            ],
          ),
        ),
      ),
    );
    
  }
}