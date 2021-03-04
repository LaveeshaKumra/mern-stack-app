import 'package:connectivity/connectivity.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:launch_review/launch_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'CodeNText.dart';

class MongoList extends StatefulWidget {
  @override
  _MongoListState createState() => _MongoListState();
}

class _MongoListState extends State<MongoList> {
  var data;
  List<String> favvalue = [];

  _MongoListState() {
    if (data == null) {
      _getindexPage();
    }
    _getfav();
    _checkconnectivity();
  }

  @override
  void initState() {
    _getfav();
    _checkconnectivity();
//    FirebaseAdMob.instance
//        .initialize(appId: "ca-app-pub-6216078565461407~5244763953");
//    _bannerAd=myBanner..load()..show();
//    myInterstitial = buildInterstitialAd()..load();
  }


  @override
  void dispose() {
    super.dispose();
//    _bannerAd.dispose();
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

  _iffav(i) {
    var index = i.toString();
    if (favvalue.contains(index))
      return true;
    else
      return false;
  }

  _getfav() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var x = await prefs.getStringList("MongoDB with Nodejs");

    setState(() {
      if (x == null) {
      } else {
        favvalue = x;
      }
    });
  }

  Future<String> _getlocaldata() async {
    return data;
  }

  _getindexPage() async {
    String url = 'https://raw.githubusercontent.com/technicalspeaks/mernapp/master/subject.json';
    Response response = await get(url);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String bodyText = response.body;
      setState(() {
        data = bodyText;
      });
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MongoDB with Nodejs"),
        backgroundColor: Colors.teal[300],
        //   automaticallyImplyLeading: false
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              //color: Colors.white,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/icons/learn.png"),fit: BoxFit.cover
                )
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Want to learn mongoDB exclusively?"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RaisedButton(
                        color: Colors.teal[300],
                        child: Text("Click here"),
                        onPressed: () {
                          LaunchReview.launch(
                               androidAppId: "com.quest.learnmongo",
                             );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: FutureBuilder(
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  var x = json.decode(snapshot.data);
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int i) {
                      return Card(
                        child: ListTile(
                          title: Text(x[3]["topics"][i]),
                          trailing: _iffav(x[3]["topics"][i])
                              ? Icon(Icons.check_circle,color: Colors.teal,)
                              : null,
                          onTap: () async {
//                            if(_bannerAd.isLoaded()!=null){
//                              _bannerAd.dispose();
//                            }
                            SharedPreferences pref=await SharedPreferences.getInstance();
                            int click=pref.getInt("clicks");
                            pref.setInt("clicks",click+1 );
                            if((click+1)%4==0){
//                              showInterstitialAd();
                            }
                            Navigator.of(context)
                                .push(
                              new MaterialPageRoute(
                                  builder: (_) => CodeNText(
                                      "MongoDB with Nodejs", x[3]["topics"][i])),
                            )
                                .then((_) {
                              _getfav();
                            });
                          },
                        ),
                      );
                    },
                    itemCount: x[3]["topics"].length,
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
              future: _getlocaldata(),
            ),
          ),
        ],
      ),
    );
  }
}
