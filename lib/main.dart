import 'package:flutter/material.dart';
import 'package:image_recog/splashScreen.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras=[];
int current=0;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras=await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      title: 'Object Dectection APP',
home: HomeSplashScreen(),
    );
  }
}

