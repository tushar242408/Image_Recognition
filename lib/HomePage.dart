import 'package:flutter/material.dart';

import 'faceRecog.dart';
import 'objDetector.dart';



class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(child: Scaffold(
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>FaceRecog() ));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 2,color: Colors.deepPurple),
                        color: Colors.deepPurpleAccent
                    ),
                    child: Text('Face Recognition',style: TextStyle(color: Colors.white,fontSize: 30),)
                  ),
                ),
                SizedBox(height: 100,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>ObjDetector() ));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 2,color: Colors.deepPurple),
                        color: Colors.deepPurpleAccent

                    ),
                    child: Text('Image Detection',style: const TextStyle(color: Colors.white,fontSize: 30),)
                  ),
                ),
                SizedBox(height: 100,),


              ],
            ),
          )
      ),

      ),
    );
  }
}
