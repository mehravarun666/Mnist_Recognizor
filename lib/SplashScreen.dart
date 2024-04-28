import 'package:digitrecognizertflite/display_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DrawingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Splash_Screen.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          Positioned(right:10,bottom:0,child: Stack(
            children: [
              Positioned(top:15,left:8,child: Text("Presented By",style: TextStyle(color: Colors.white),)),
              Image.asset('assets/phantomTroupe.png',scale: 3,color: Colors.white,),
              Positioned(bottom:45,right:25,child: Text("2.0",style: TextStyle(color: Colors.white,fontSize: 20),)),
            ],
          ))
        ],
      ),
    );
  }
}


