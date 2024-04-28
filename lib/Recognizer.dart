import 'dart:ui';
import 'dart:typed_data';
import 'package:digitrecognizertflite/constants.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

final _canvasCullReact = Rect.fromPoints(Offset(0,0), Offset(Constants.imageSize,Constants.imageSize));
final _bgpaint = Paint()..color = Colors.black;
final _whitepaint = Paint()..color = Colors.white..strokeCap = StrokeCap.round..strokeWidth = Constants.strokeWidth;

class Recognizer{
  Future loadModel(){
    Tflite.close();
    return Tflite.loadModel(model: "assets/mnist.tflite",labels: "assets/labels.txt");
  }

  Future recognize(List<List<double>> points) async{
    final picture = _pointsToPicture(points);
    Uint8List bytes = await _imageToByteListUnit8(picture,Constants.mnistImageSize);
    return _predict(bytes);
  }

  Future _predict(Uint8List bytes){
    return Tflite.runModelOnBinary(binary: bytes);
  }

  Future<Uint8List> _imageToByteListUnit8(Picture pic,int size) async {
    final img= await pic.toImage(size, size);
    final imgBytes = await img.toByteData();
    final resultBytes = Float32List(size*size);
    final buffer = Float32List.view(resultBytes.buffer);

    int index = 0;

    for(int i=0;i<imgBytes!.lengthInBytes; i+=4){
      final r = imgBytes.getUint8(i);
      final g = imgBytes.getUint8(i+1);
      final b = imgBytes.getUint8(i+2);
      buffer[index++] = (r+g+b)/ 3.0/ 255.0;
    }

    return resultBytes.buffer.asUint8List();
  }

  Picture _pointsToPicture(List<List<double>> points){
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder,_canvasCullReact)..scale(Constants.mnistImageSize / Constants.canvaSize);

    canvas.drawRect(Rect.fromLTWH(0, 0, Constants.imageSize, Constants.imageSize), _bgpaint);

    final Paint _paint = Paint()..strokeCap=StrokeCap.round..color = Colors.white..strokeWidth = Constants.strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i][0] != -1 && points[i + 1][0] != -1) {
        canvas.drawLine(
          Offset(points[i][0], points[i][1]),
          Offset(points[i + 1][0], points[i + 1][1]),
          _paint,
        );
      }
    }

    return recorder.endRecording();
  }
}