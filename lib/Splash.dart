import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    _function().then(
            (status){
          _navigatetohome();
        }
    );
  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _function() async{
    await Future.delayed(Duration(milliseconds: 7000),(){});
    return true;
  }

  void _navigatetohome() async{
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context)=>MyHomePage()
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Image.asset('assets/icons/splash.png',width: 200,),
        SizedBox(height: 20,),
        SizedBox(
          width: 200.0,
          child: TypewriterAnimatedTextKit(
              onTap: () {
              },
              text: [
                "Learn Mern stack development",
                "A Practical guide for beginners",
              ],
              textStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: "Agne"
              ),
              textAlign: TextAlign.start,
              alignment: AlignmentDirectional.topStart ,
            speed: Duration(milliseconds: 100),
          ),
        ),
          ],
        ),
      ),
    );
  }
}
