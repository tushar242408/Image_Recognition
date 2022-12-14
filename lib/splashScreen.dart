import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'faceRecog.dart';

class HomeSplashScreen extends StatelessWidget {
  const HomeSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.network('https://img.freepik.com/vetores-gratis/vetor-de-modelo-de-logotipo-de-cerebro-ai-em-azul-para-empresa-de-tecnologia_53876-112221.jpg'),
      title: const Text('Image Detection',style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.deepPurpleAccent,
      showLoader: true,
      loadingText: const Text('Loading...',style: TextStyle(color: Colors.white),),
      navigator:  Home(),
      durationInSeconds: 2,
    );
  }
}
