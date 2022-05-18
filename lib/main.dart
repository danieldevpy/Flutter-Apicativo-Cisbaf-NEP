
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'splash.dart';
import 'package:Cisbaf_NEP/chrome_safari_browser_example.screen.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';



Future<void> main() async {
 
  runApp(MaterialApp(
    
    home: WillPopScope(
        onWillPop: () async { 
          print('teste');
          
          return false;
         },child: Splash()),
         
  debugShowCheckedModeBanner: false,))
  ;

}