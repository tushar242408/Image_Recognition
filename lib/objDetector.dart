import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

import 'main.dart';


class ObjDetector extends StatefulWidget {
  const ObjDetector({Key? key}) : super(key: key);

  @override
  State<ObjDetector> createState() => _ObjDetectorState();
}

class _ObjDetectorState extends State<ObjDetector> {
  bool isWorking= false;
  CameraImage? imgCamera;
  late CameraController cameraC;
  String? result;
  initCamera(){
    try {
      cameraC = CameraController(cameras[0], ResolutionPreset.medium);
      cameraC.initialize().then((value) {
        if (!mounted) {
          return;
        }
        cameraC.startImageStream((image) {
          if (!isWorking) {
            //setState
            setState(() {
              isWorking = true;
              imgCamera = image;
              runModelInStream();
            });
          }
        });
      });
    }catch(e){
      print('--------');
    }

  }
  runModelInStream()async{
    if(imgCamera !=null){
      var recog= await Tflite.runModelOnFrame(bytesList: imgCamera?.planes.map((e) {
        return e.bytes;
      }).toList()??[],
          imageHeight: imgCamera?.height??1280,
          imageWidth: imgCamera?.width??720,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,numResults: 2,
          threshold: 0.1,
          asynch: true
      );

      result='';
      recog?.forEach((element) {
        result = result! + element['label']+ '  ' +(element['confidence']).toString().substring(0,4)  +'\n\n';
      });
      setState(() {
        result;
      });
      isWorking = false;

    }
  }
  loadModel()async{
    Tflite.close();
    await Tflite.loadModel(
        model:'assets/example.tflite',
        labels: 'assets/example.txt');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
    initCamera();
  }
  @override
  void dispose()async {
    await Tflite.close();
    cameraC.dispose();
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
              body:Container(
                width: MediaQuery.of(context).size.width,
                height: double.maxFinite,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQV4MFpN034ol8SULmsqGDU3Rb4gTDTP2wC_g&usqp=CAU'),
                        fit: BoxFit.fill
                    )

                ),
                child: Column(
                  children: [
                    imgCamera==null?Container():
                    Container(
                      margin: const EdgeInsets.all(10 ),
                      child: AspectRatio(aspectRatio: cameraC.value.aspectRatio,
                          child:CameraPreview(
                              cameraC)),
                    ),

                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text('$result',
                          style: TextStyle(
                            backgroundColor: Colors.white,
                            color: Colors.black,
                            fontSize:30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )

                  ],
                ),
              )
          ),
        )
    ;
  }
}
