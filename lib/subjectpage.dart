import 'package:connectivity/connectivity.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:mernstack/TextOnly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CodeNText.dart';


class SubjectPage extends StatefulWidget {
  int index;
  SubjectPage(int i){this.index=i;}
  @override
  _SubjectPageState createState() => _SubjectPageState(this.index);
}

class _SubjectPageState extends State<SubjectPage> {
  int index;
  var data;
  String heading;
  List<String> favvalue=[];

  _SubjectPageState(int i){
    this.index=i;
    if(i==0){heading="Learn NodeJS";}
    else if(i==1){heading="Learn ExpressJS";}
    else if(i==2){heading="Learn ReactJS";}
    if(data==null ){_getindexPage();}
    _getfav();
  }


  @override
  void initState() {
    _checkconnectivity();
    _getfav();
//    FirebaseAdMob.instance
//        .initialize(appId: "ca-app-pub-6216078565461407~5244763953");
//    _bannerAd=myBanner..load()..show();
//    myInterstitial = buildInterstitialAd()..load();
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

  @override
  void dispose() {
    super.dispose();
//    _bannerAd.dispose();
  }

//  void showInterstitialAd() {
//    myInterstitial.show();
//  }


  _iffav(i){
    var index=i.toString();
    if(favvalue.contains(index))
      return true;
    else
      return false;
  }

  _getfav() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var x=await prefs.getStringList(heading);

    setState(() {
      if(x==null){

      }
      else{
        favvalue=x;
      }
    });
  }


  Future<String> _getlocaldata() async{
    return data;
}

  _getindexPage() async{
    String url = 'https://raw.githubusercontent.com/technicalspeaks/mernapp/master/subject.json';
    Response response = await get(url);
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
        //   automaticallyImplyLeading: false
      ),
      body: FutureBuilder(
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            var x=json.decode(snapshot.data);
            print(x[2]);
            return ListView.builder(
              itemBuilder: (BuildContext context, int i) {
                return Card(
                  child: ListTile(
                    title: Text(x[index]["topics"][i]),
                    trailing: _iffav(x[index]["topics"][i])?Icon(Icons.check_circle,color: Colors.teal,):null,
                    onTap: () async {
                      if(i>2){
                        SharedPreferences pref=await SharedPreferences.getInstance();
                        int click=pref.getInt("clicks");
                        pref.setInt("clicks",click+1 );
                        if((click+1)%4==0){
//                          showInterstitialAd();
                        }
                        Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>CodeNText(heading,x[index]["topics"][i])),)
                            .then((_) {
                          _getfav();
                        });
                      }
                      else{
//                        if(_bannerAd.isLoaded()!=null){
//                          _bannerAd.dispose();
//                        }
                        SharedPreferences pref=await SharedPreferences.getInstance();
                        int click=pref.getInt("clicks");
                        pref.setInt("clicks",click+1 );
                        if((click+1)%4==0){
//                          showInterstitialAd();
                        }
                        Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>TextOnly(heading,x[index]["topics"][i])),)
                            .then((_) {
                          _getfav();
                        });
                      }

                    },
                  ),
                );
              },
              itemCount: x[index]["topics"].length,
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
