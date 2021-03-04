import 'dart:convert';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:launch_review/launch_review.dart';
import 'package:flutter/material.dart';
import 'package:mernstack/Splash.dart';
import 'package:mernstack/mongolist.dart';
import 'package:mernstack/subjectpage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:share/share.dart';
import 'package:connectivity/connectivity.dart';
import 'package:url_launcher/url_launcher.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn Mern Stack',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
 class MyHomePage extends StatefulWidget {
   @override
   _MyHomePageState createState() => _MyHomePageState();
 }

 class _MyHomePageState extends State<MyHomePage> {
  var nodeper,mongoper,reactper,expressper;
  final keyIsFirstLoaded = 'is_first_loaded';
  _MyHomePageState(){
    _getpercentages();
    _checkconnectivity();
    _firstloaded();
  }

  _firstloaded() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
    prefs.setInt("clicks", 0);
    if (isFirstLoaded == null) {
      prefs.setStringList("Learn NodeJS", []);
      prefs.setStringList("Learn ExpressJS", []);
      prefs.setStringList("Learn ReactJS", []);
      prefs.setStringList("MongoDB with Nodejs", []);
      prefs.setBool(keyIsFirstLoaded, false);
    }

  }

  @override
  void initState() {
    _getpercentages();
    _checkconnectivity();
//    FirebaseAdMob.instance
//        .initialize(appId: "ca-app-pub-6216078565461407~5244763953");
//    _bannerAd=myBanner..load()..show();
//    myInterstitial = buildInterstitialAd()..load();

  }
//  BannerAd _bannerAd;
//
//  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//    keywords: <String>['learn', 'mongodb','nodejs','full stack','expressjs','development','reactjs'],
//    contentUrl: 'https://flutter.io',
//    birthday: DateTime.now(),
//    childDirected: false,
//    designedForFamilies: false,
//    gender:
//    MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
//    testDevices: <String>[], // Android emulators are considered test devices
//  );
//
//  BannerAd myBanner = BannerAd(
//    // Replace the testAdUnitId with an ad unit id from the AdMob dash.
//    // https://developers.google.com/admob/android/test-ads
//    // https://developers.google.com/admob/ios/test-ads
//    adUnitId: "ca-app-pub-6216078565461407/5657264285",
//    //adUnitId: BannerAd.testAdUnitId,
//    size: AdSize.smartBanner,
//    targetingInfo: targetingInfo,
//    listener: (MobileAdEvent event) {
//      print("BannerAd event is $event");
//    },
//  );
//  InterstitialAd myInterstitial;
//
//  InterstitialAd buildInterstitialAd() {
//    return InterstitialAd(
//      //adUnitId: InterstitialAd.testAdUnitId,
//      adUnitId: "ca-app-pub-6216078565461407/5182072829",
//      listener: (MobileAdEvent event) {
//        if (event == MobileAdEvent.failedToLoad) {
//          myInterstitial..load();
//        } else if (event == MobileAdEvent.closed) {
//          myInterstitial = buildInterstitialAd()..load();
//        }
//        print(event);
//      },
//    );
//  }
//
//  void showInterstitialAd() {
//    myInterstitial.show();
//  }

  @override
  void dispose() {
    super.dispose();
//    _bannerAd.dispose();
  }


  _checkconnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("No internet Connection"),
              content: Text("Check your internet connection"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok',style: TextStyle(color: Colors.green)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  _getpercentages() async{
    var nodetlength;
    var mongolength;
    var expresslength;
    var reactlength;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var a=await prefs.getStringList("Learn NodeJS");
    var m=await prefs.getStringList("MongoDB with Nodejs");
    var e=await prefs.getStringList("Learn ExpressJS");
    var r=await prefs.getStringList("Learn ReactJS");
    Response response = await get("https://raw.githubusercontent.com/technicalspeaks/mernapp/master/subject.json");
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String bodyText = response.body;
      var x=jsonDecode(bodyText);
      nodetlength=x[0]["topics"].length;
      mongolength=x[3]["topics"].length;
      expresslength=x[1]["topics"].length;
      reactlength=x[2]["topics"].length;
    }
    setState(() {
      nodeper= double.parse((a.length/nodetlength).toStringAsFixed(2));
      mongoper=double.parse((m.length/mongolength).toStringAsFixed(2));
      expressper=double.parse((e.length/expresslength).toStringAsFixed(2));
      reactper=double.parse((r.length/reactlength).toStringAsFixed(2));
      //reactper=0.0;
    });

  }


   @override
   Widget build(BuildContext context) {
     return WillPopScope(
       onWillPop: _onBackPressed,
       child: Scaffold(
         appBar: AppBar(
           title: Text("Learn Mern-Stack Development"),
           backgroundColor: Colors.teal[300],
           actions: <Widget>[
             PopupMenuButton(
               itemBuilder: (context) => [
                 PopupMenuItem(
                   value: 1,
                   child: Text("Rate app"),
                 ),
                 PopupMenuItem(
                   value: 2,
                   child: Text("Share"),
                 ),
                 PopupMenuItem(
                   value: 4,
                   child: Text("More Apps"),
                 ),
               ],
               onSelected: (val) {
                 if (val == 1) {
                   LaunchReview.launch(
                     androidAppId: "learn.mern.stack_17j20",
                   );
                 }
//                else if (val == 3) {
//                  LaunchReview.launch(
//                    androidAppId: "learn.mern.stack_17j20",
//                  );
//                }
                 else if (val == 4) {
                   launch(
                       "https://play.google.com/store/apps/developer?id=DevAtom");
                 } else {
                   Share.share(
                       "Learn fullStack development (Practical Guide) from this app. It includes MERN stack (NodeJs,ExpressJs,ReactJs,MongoDB) \nhttps://play.google.com/store/apps/details?id=learn.mern.stack_17j20 ");
                 }
               })
           ],
           ),

         body: SingleChildScrollView(
           child: Padding(
             padding: const EdgeInsets.all(50.0),
             child: Column(
               children: <Widget>[
                 Row(
                   children: <Widget>[
                     Container(
                       width: MediaQuery. of(context). size. width*0.3,
                       child: Column(
                         children: <Widget>[
                           GestureDetector(
                             child: Card(
                               elevation: 10.0,
                               child: Image.asset("assets/icons/mongodb.png"),
                             ),
                             onTap: () async {
//                               if(_bannerAd.isLoaded()!=null){
//                                 _bannerAd.dispose();
//                               }
                               SharedPreferences pref=await SharedPreferences.getInstance();
                               int click=pref.getInt("clicks");
                               pref.setInt("clicks",click+1 );
                               if((click+1)%4==0){
//                                 showInterstitialAd();
                               }
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => MongoList()),
                               ).then((_) {
                                 _getpercentages();
                               });
                             },
                           ),
                           SizedBox(height: 10,),
                           mongoper!=null ?LinearPercentIndicator(
                             animation: true,
                             lineHeight: 15.0,
                             animationDuration: 2500,
                             percent: mongoper,
                             center: Padding(
                               padding: const EdgeInsets.all(2.0),
                               child: Text("${mongoper *100}%",style: TextStyle(fontSize: 10),),
                             ),
                             linearStrokeCap: LinearStrokeCap.roundAll,
                             progressColor: Colors.green[400],
                           ):
                           LinearPercentIndicator(
                             animation: true,
                             lineHeight: 15.0,
                             animationDuration: 2500,
                             percent: 0,
                             center: Padding(
                               padding: const EdgeInsets.all(2.0),
                               child: Text("0%",style: TextStyle(fontSize: 10),),
                             ),
                             linearStrokeCap: LinearStrokeCap.roundAll,
                             progressColor: Colors.green[400],
                           ),

                         ],
                       ),
                     ),
                     Spacer(),
                     Container(
                       width: MediaQuery. of(context). size. width*0.3,
                       child: Column(
                         children: <Widget>[
                           GestureDetector(
                             child: Card(
                               elevation: 10.0,
                               child: Image.asset("assets/icons/express.png"),
                             ),
                             onTap: () async {
//                               if(_bannerAd.isLoaded()!=null){
//                                 _bannerAd.dispose();
//                               }
                               SharedPreferences pref=await SharedPreferences.getInstance();
                               int click=pref.getInt("clicks");
                               pref.setInt("clicks",click+1 );
                               if((click+1)%4==0){
//                                 showInterstitialAd();
                               }
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => SubjectPage(1)),
                               ).then((_) {
                                 _getpercentages();
                               });
                             },
                           ),
                           SizedBox(height: 10,),
                           expressper!=null ?LinearPercentIndicator(
                             animation: true,
                             lineHeight: 15.0,
                             animationDuration: 2500,
                             percent: expressper,
                             center: Padding(
                               padding: const EdgeInsets.all(2.0),
                               child: Text("${expressper *100}%",style: TextStyle(fontSize: 10),),
                             ),
                             linearStrokeCap: LinearStrokeCap.roundAll,
                             progressColor: Colors.yellow[300],
                           ):
                           LinearPercentIndicator(
                             animation: true,
                             lineHeight: 15.0,
                             animationDuration: 2500,
                             percent: 0,
                             center: Padding(
                               padding: const EdgeInsets.all(2.0),
                               child: Text("0%",style: TextStyle(fontSize: 10),),
                             ),
                             linearStrokeCap: LinearStrokeCap.roundAll,
                             progressColor: Colors.yellow[300],
                           ),


                         ],
                       ),
                     )
                   ],
                 ),
                 SizedBox(height: 60,),
                 Row(
                   children: <Widget>[

                     Container(
                       width: MediaQuery. of(context). size. width*0.3,
                       child: Column(
                         children: <Widget>[
                           GestureDetector(
                             child: Card(
                               elevation: 10.0,
                               child: Image.asset("assets/icons/react.png"),
                             ),
                             onTap: () async{
//                               if(_bannerAd.isLoaded()==null){
//                                 _bannerAd.dispose();
//                               }
                               SharedPreferences pref=await SharedPreferences.getInstance();
                               int click=pref.getInt("clicks");
                               pref.setInt("clicks",click+1 );
                               if((click+1)%4==0){
//                                 showInterstitialAd();
                               }
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => SubjectPage(2)),
                               ).then((_) {
                                 _getpercentages();
                               });
                             },
                           ),
                           SizedBox(height: 10,),
                           reactper!=null ?LinearPercentIndicator(
                             animation: true,
                             lineHeight: 15.0,
                             animationDuration: 2500,
                             percent: reactper,
                             center: Padding(
                               padding: const EdgeInsets.all(2.0),
                               child: Text("${reactper *100}%",style: TextStyle(fontSize: 10),),
                             ),
                             linearStrokeCap: LinearStrokeCap.roundAll,
                             progressColor: Colors.blue[300],
                           ):
                           LinearPercentIndicator(
                             animation: true,
                             lineHeight: 15.0,
                             animationDuration: 2500,
                             percent: 0,
                             center: Padding(
                               padding: const EdgeInsets.all(2.0),
                               child: Text("0%",style: TextStyle(fontSize: 10),),
                             ),
                             linearStrokeCap: LinearStrokeCap.roundAll,
                             progressColor: Colors.blue[300],
                           ),


                         ],
                       ),
                     ),
                     Spacer(),
                     Container(
                       width: MediaQuery. of(context). size. width*0.3,
                       child: Column(
                         children: <Widget>[
                           GestureDetector(
                             child: Card(
                               elevation: 10.0,
                               child: Image.asset("assets/icons/nodejs.png"),
                             ),
                             onTap: () async {
//                               if(_bannerAd.isLoaded()!=null){
//                                 _bannerAd.dispose();
//                               }
                               SharedPreferences pref=await SharedPreferences.getInstance();
                               int click=pref.getInt("clicks");
                               pref.setInt("clicks",click+1 );
                               if((click+1)%4==0){
                               }
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => SubjectPage(0)),
                               ).then((_) {
                                 _getpercentages();
                               });
                             },
                           ),
                           SizedBox(height: 10,),
                           nodeper!=null ?LinearPercentIndicator(
                             animation: true,
                             lineHeight: 15.0,
                             animationDuration: 2500,
                             percent: nodeper,
                             center: Padding(
                               padding: const EdgeInsets.all(2.0),
                               child: Text("${nodeper *100}%",style: TextStyle(fontSize: 10),),
                             ),
                             linearStrokeCap: LinearStrokeCap.roundAll,
                             progressColor: Colors.green,
                           ):
                           LinearPercentIndicator(
                             animation: true,
                             lineHeight: 15.0,
                             animationDuration: 2500,
                             percent: 0,
                             center: Padding(
                               padding: const EdgeInsets.all(2.0),
                               child: Text("0%",style: TextStyle(fontSize: 10),),
                             ),
                             linearStrokeCap: LinearStrokeCap.roundAll,
                             progressColor: Colors.green[400],
                           ),


                         ],
                       ),
                     ),

                   ],
                 ),
//               SizedBox(height: 100,),
               ],
             ),
           ),
         ),
       ),
     );
   }
 }
