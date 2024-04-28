import 'package:digitrecognizertflite/Model/predictionModel.dart';
import 'package:digitrecognizertflite/Recognizer.dart';
import 'package:digitrecognizertflite/constants.dart';
import 'package:digitrecognizertflite/drawingPainter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
class DrawingScreen extends StatefulWidget {
  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  late List<List<double>> _points = [];
  final _recognizer = Recognizer();
  FlutterTts flutterTts = FlutterTts();
  var _prediction = [];
  bool _isLoadinganimation = false;
  bool initialize = false;
  Color colorstroke = Colors.white ;

  @override
  void initState() {
    _initModel();
    configureTts();
    super.initState();
  }

  Future<void> configureTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
  }

  void _initModel()async{
    var res = await _recognizer.loadModel();
  }

  void speakText(String text) async {
    await flutterTts.speak(text);
  }

  void stopSpeaking() async {
    await flutterTts.stop();
  }


  void _recognize() async {
    setState(() {
      _isLoadinganimation = true;
    });
    await Future.delayed(Duration(seconds: 3));
    List<dynamic> pred = await _recognizer.recognize(_points);
    print(pred);
    setState(() {
      _prediction = pred.map((json) => Prediction.fromjson(json)).toList();
      _isLoadinganimation = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your Number is'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_prediction.isNotEmpty?_prediction.first.label:"Unknown",style: TextStyle(fontSize: 40),),
            ],
          ),
        );
      },
    );
    speakText("Your Number is ${_prediction.isNotEmpty ? _prediction.first.label : 'unknown'}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Stack(
          children: [
            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [
            //         Colors.grey,
            //         Colors.black,
            //       ],
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       stops: [0.0, 1.0],
            //       tileMode: TileMode.clamp,
            //     ),
            //   ),
            // ),

            Opacity(
              opacity: 0.1,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/backgroung_image.png'), // Change the image path accordingly
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),


            // Content

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("MNIST NUM",style: TextStyle(fontSize: 25),),
                Text("RECOGNIZATION",style: TextStyle(fontSize: 15),),

                SizedBox(height: 30,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Container(
                        width: Constants.canvaSize + Constants.borderSize*2,
                        height: Constants.canvaSize + Constants.borderSize*2,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: GestureDetector(
                          onPanUpdate: (DragUpdateDetails details) {
                              RenderBox renderBox =
                              context.findRenderObject() as RenderBox;
                              Offset localPosition =
                              renderBox.globalToLocal(details.localPosition);
                              if (localPosition.dx >= 0 &&
                                  localPosition.dx <= Constants.canvaSize &&
                                  localPosition.dy >= 0 &&
                                  localPosition.dy <= Constants.canvaSize) {
                                setState(() {
                                  _points.add([localPosition.dx, localPosition.dy]);
                                });
                              }
                          },
                          onPanEnd: (DragEndDetails details) {
                            _points.add([-1, -1]);
                          },
                          child: CustomPaint(
                            size: Size(300, 300),
                            painter: DrawingPainter(_points,colorstroke),
                          ),
                        ),
                      ),
                     Container(
                       height: Constants.canvaSize + Constants.borderSize*2,

                       child: Column(

                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           colorDot(Colors.red),
                           colorDot(Colors.green),
                           colorDot(Colors.blue),
                           colorDot(Colors.white),
                           colorDot(Colors.yellow),
                         ],
                       ),
                     ),
                   ],
                 ),

                SizedBox(height: 20),

               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   InkWell(
                       onTap:(){
                         _recognize();
                       },
                       child: Container(
                           decoration: BoxDecoration(
                               color: Colors.white,
                               border: Border.all(
                                 color: Colors.white,
                               ),
                               borderRadius: BorderRadius.circular(20)
                           ),
                           child: Padding(
                             padding: const EdgeInsets.fromLTRB(25,10,25,10),
                             child: Row(
                               children: [
                                 Icon(Icons.search,color: Colors.black,),
                                 SizedBox(width: 10,),
                                 Text('Recognize Digit',style: TextStyle(color: Colors.black),),
                               ],
                             ),
                           ))),

                   SizedBox(width: 10),
                   InkWell(
                     onTap: (){
                       setState(() {
                         _points.clear();
                       });
                     },
                     child: Container(
                       decoration: BoxDecoration(
                           color: Colors.black,
                           border: Border.all(
                             color: Colors.white,
                           ),
                           borderRadius: BorderRadius.circular(20)
                       ),
                       child: Padding(
                         padding: const EdgeInsets.fromLTRB(25,10,25,10),
                         child: Row(
                           children: [
                             Icon(Icons.delete_outline),
                             SizedBox(width: 10,),
                             Text('Clear'),
                           ],
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
                SizedBox(height: 40),
                 Row(
                  children: [
                    SizedBox(width: 40,),
                    Text("Confidence Graph",style: TextStyle(color: Colors.white),),
                  ],
                ),
                SizedBox(height: 20),

                Container(
                  height: 200,
                  width: 350,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 10,
                      barTouchData: BarTouchData(
                        enabled: true,
                      ),
                      titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                            ),
                          )
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: _prediction
                          .map(
                            (prediction) => BarChartGroupData(
                          x: prediction.index,
                          barRods: [
                            BarChartRodData(
                              fromY:0 ,
                              toY: prediction.confidence,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: Constants.canvaSize / 2 - 45,
              left: Constants.canvaSize / 2-170,
              child: Visibility(
                visible: _isLoadinganimation,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Lottie.asset(
                      'assets/loading_animation.json',
                      width: 400,
                      height: 400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorDot(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          colorstroke = color;
        });
      },
      child: Container(
        width: 20, // Adjust size as needed
        height: 20, // Adjust size as needed
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }



  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}


