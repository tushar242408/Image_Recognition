import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

import 'main.dart';
class FaceRecog extends StatefulWidget {
  const FaceRecog({Key? key}) : super(key: key);

  @override
  State<FaceRecog> createState() => _FaceRecogState();
}

class _FaceRecogState extends State<FaceRecog> {
  bool isWorking= false;
  CameraImage? imgCamera;
  late CameraController cameraC;
  List?  recognition;
  String? result;
  double? imgHeight;
  double? imgWidth;
  initCamera(){
    cameraC=CameraController(cameras[1],ResolutionPreset.medium);
    cameraC.initialize().then((value) {
      if(!mounted)
      {
        return;
      }
      cameraC.startImageStream((image) {
        if(!isWorking){
          //setState
          setState(() {
            isWorking=true;
            imgCamera=image;
            runModelInStream();
          });


        }
      });
    });

  }
  runModelInStream()async{
imgHeight= double.parse('${imgCamera?.height??0 +0}') ;
imgWidth= double.parse('${imgCamera?.width??0 +0}');
if(imgCamera !=null){
  recognition= await Tflite.runPoseNetOnFrame(bytesList: imgCamera?.planes.map((e) {
    return e.bytes;
  }).toList()??[],
      imageHeight: imgCamera?.height??1280,
      imageWidth: imgCamera?.width??720,

    numResults: 2
  );
  setState(() {
    imgCamera;
  });
  isWorking = false;

}
  }

  loadModel()async{
    Tflite.close();
    try {
   String? response =   await Tflite.loadModel(
          model: 'assets/FR.tflite',
         );
   print(response);

    }catch(e){
      print('-------------------');
    }
  }
 List<Widget> display(Size size){
    if(recognition ==null) return [];

    if(imgHeight ==null || imgWidth ==null) return [];
     double? x= size.width;
     double? y= imgHeight;

     var list= <Widget>[];
     recognition?.forEach((element) {
       var l= element['keypoints'].values.map<Widget>((val){
         return Positioned(
           left: val['x'] * x-6,
           top: val['y'] * x-6,
           width: 100,
           height: 20,
           child: Text('*${val['part']}',style: const TextStyle(
             color: Colors.red,
             fontSize:20
           ),),

         );
       }).toList();
       list.addAll(l);
     });
     return list;




  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
    initCamera();
  }
  void dispose()async {
    await Tflite.close();
    cameraC.dispose();
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    List<Widget> wg=[];
    wg.add(Positioned(
        top: 0,
        left: 0,
        width: size.width,
        height: size.height-100,

        child:     imgCamera==null?Container():
    Container(
      margin: const EdgeInsets.all(10 ),
      child: AspectRatio(aspectRatio: cameraC.value.aspectRatio,
          child:CameraPreview(
              cameraC)),
    ),

    ));

    if(imgCamera !=null){
      wg.addAll(display(size));
    }


    return      SafeArea(
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
                child: Stack(
                  children: wg,
                ),
              )
          ),
        )
    ;
  }
}
