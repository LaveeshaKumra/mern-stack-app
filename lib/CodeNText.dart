import 'package:connectivity/connectivity.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:share/share.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CodeNText extends StatefulWidget {
  String heading;
  String type;
  CodeNText(t,s){this.heading=s;this.type=t;}
  @override
  _CodeNTextState createState() => _CodeNTextState(this.type,this.heading);
}

class _CodeNTextState extends State<CodeNText> {
  String heading,type;
  var data;
  List<String> favvalue=[];
  _CodeNTextState(t,s){
    this.heading=s;
    this.type=t;
    if(data==null){_getdatafromapi();}
    _getfav();
    _checkconnectivity();
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

  @override
  void initState() {
//    FirebaseAdMob.instance
//        .initialize(appId: "ca-app-pub-6216078565461407~5244763953");
//    _bannerAd=myBanner..load()..show();
    _getfav();
    _checkconnectivity();
  }
//
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

  @override
  void dispose() {
    super.dispose();
//    _bannerAd.dispose();
  }

  Future<String> _getlocaldata() async{
    return data;
  }

  _iffav(i){
    var index=i.toString();
    if(favvalue.contains(index))
      return true;
    else
      return false;
  }

  _addtofav(i) async{
    var index=i.toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favvalue.add(index);
    });
    prefs.setStringList(type,favvalue);

  }

  _removefromfav(i) async{
    var index=i.toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favvalue.remove(index);
    });
    prefs.setStringList(type,favvalue);
  }

  _getfav() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var x=await prefs.getStringList(type);

    setState(() {
      if(x==null){

      }
      else{
        favvalue=x;
      }
    });
  }

  _getdatafromapi() async{
    Response response;
    if(type=="Learn NodeJS"){
      response = await get("https://raw.githubusercontent.com/technicalspeaks/mernapp/master/node.json");
    }
    else if(type =="Learn ExpressJS"){
      response = await get("https://raw.githubusercontent.com/technicalspeaks/mernapp/master/express.json");
    }
    else if(type=="Learn ReactJS"){
      response = await get("https://raw.githubusercontent.com/technicalspeaks/mernapp/master/react.json");
    }
    else if(type=="MongoDB with Nodejs"){
      response = await get("https://raw.githubusercontent.com/devatomdata/data1mern/master/mongo.json");
    }
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String bodyText = response.body;
      setState(() {
        data=bodyText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(heading),
        backgroundColor: Colors.teal[300],
        actions: <Widget>[
          GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _iffav(heading)?Icon(Icons.check_circle):Icon(Icons.check_circle_outline),
              ),
          onTap: (){
                if(_iffav(heading)) {
                  _removefromfav(heading);
                  Toast.show("Topic marked as undone", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                }
                else{
                  _addtofav(heading);
                  Toast.show("Topic marked as done", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                }
          },
          )
        ],
        //   automaticallyImplyLeading: false
      ),
      body: FutureBuilder(
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            var x=json.decode(snapshot.data.toString());
            var data=x[0]["$heading"];
            return ListView.builder(
              itemBuilder: (BuildContext context, int i) {
                return Container(
                    child:(i==0 || i%3==0)?
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(data[i],style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                    ):
                    (i==1 || i==4 ||i==7)?
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          decoration: BoxDecoration(
                            //color: Colors.black,
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                    child: Icon(Icons.content_copy,size: 16,),
                                  onTap: (){
                                    Clipboard.setData(ClipboardData(text: data[i]));
                                    Toast.show("Code Copied ", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                                  },
                                ),
                                SizedBox(width: 16,),
                                GestureDetector(
                                  child: Icon(Icons.share,size: 16,),
                                  onTap: (){
                                    Share.share("${data[i]} \n\n Learn fullStack development (Practical Guide) from this app. It includes MERN stack (NodeJs,ExpressJs,ReactJs,MongoDB) \nhttps://play.google.com/store/apps/details?id=learn.mern.stack_17j20 ");
                                  },
                                ),
                              ],
                            ),
                            Text(data[i],style: TextStyle(color: Colors.black),),
                          ],
                        ),
                      )),
                    ):
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(data[i]),
                    )

                );
              },
              itemCount: data.length,
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.teal),
                    ),
                    width: 30,
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text("Loading.."),
                  )
                ],
              ),
            );
          }
        },
        future:
        _getlocaldata(),
      ),
    );
  }
}
