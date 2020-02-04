import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/APIConsumption.dart';
import 'package:flutter_app/CheckInternet.dart';
import 'package:flutter_app/Demo.dart';
import 'package:flutter_app/SessionDetails.dart';
import 'package:flutter_app/ToastMsg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Nimap Infotech Ltd';
    return MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        home: HomePageState());
  }
}

class HomePageState extends StatefulWidget {
  State createState() => HomePage_State();
}

class HomePage_State extends State<HomePageState> {
  ToastMsg msg = new ToastMsg();
  CheckInternet inetCheck = CheckInternet();
  APIConsumption apiConsumption = new APIConsumption();
  SharedPreferences sharedPreferences;
  SessionDetails sessionDetails = new SessionDetails();

  bool internetStatus;

  //offline image storing for cache-representation
  var imageURLs = [];

  //online image storing
  List recordList = new List();
  List<Demo_Record> _recordListData = new List<Demo_Record>();


  @override
  void initState() {
    //check the internet
    Future.delayed(const Duration(milliseconds: 4), () async {
      internetStatus = await inetCheck.checkInternet(context);
      if (internetStatus) {
        getRecordList(context);
      } else {
        getOffineImageList();
        msg.getInternetFailureMsg(context);
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/nimap-logo.png"),
          title: new Text("Nimap Infotech Ltd \nRecordList", style: TextStyle(
            fontSize: 20,
            fontFamily: 'Dancing Script',
            fontWeight: FontWeight.bold,
            color: Colors.white,),),
          backgroundColor: Colors.cyan[800],
        ),
        body: new SingleChildScrollView(
            physics: ScrollPhysics(),
            child: new Container(
                color: Colors.black,
                child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _recordListData.length > 0
                          ? getOnlineUI()
                          : getOfflineUI()
                    ]
                )
            ))
    );
  }


  //GetOnlineDetails from JSON
  getRecordList(BuildContext context) async {
    var responseData = await apiConsumption.recordListApi(context);
    recordList = responseData['data']['Records'];
    for (int i = 0; i < recordList.length; i++) {
      setState(() {
        _recordListData.add(Demo_Record(
            recordList[i]['title'],
            recordList[i]['shortDescription'],
            recordList[i]['collectedValue'],
            recordList[i]['totalValue'],
            recordList[i]['startDate'],
            recordList[i]['endDate'],
            recordList[i]['mainImageURL'],
            recordList[i]["Id"],
            false
        ));
        imageURLs.add(recordList[i]['mainImageURL']);
      });
    }
    String data = Demo_Record.listToJson(imageURLs);
    sessionDetails.saveImageList(data);
  }

  //GetOfflineDetails from Cache
  getOffineImageList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      var imgListData =
      jsonDecode(sharedPreferences.getString("imageList")) as List;
      imageURLs = imgListData;
    });
  }

  // calculateDays
  int calculateNoDays(String startDate, String endDate) {
    DateTime sDate = DateTime.parse(
        startDate.substring(6, 10) + "-" + startDate.substring(3, 5) + "-" +
            startDate.substring(0, 2));
    DateTime eDate = DateTime.parse(
        endDate.substring(6, 10) + "-" + endDate.substring(3, 5) + "-" +
            endDate.substring(0, 2));
    int days = eDate.difference(sDate).inDays;
    print("Date: ${days}");
    return days;
  }

  //OFFLINE UI WIDFGET
  Widget getOfflineUI() {
    return new Center(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(top: 10),
            itemCount: imageURLs.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int position) {
              return ListTile(
                  subtitle: new Stack(
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.black,
                          ),
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 4,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ClipRect(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  imageUrl: imageURLs[position]["mainImageURL"]
                                      .toString(),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  repeat: ImageRepeat.repeat,
                                  alignment: const Alignment(2, 1.5),
                                )
                            ),
                          ),
                        ),
                      ]));
            }));
  }

  //ONLINE UI WIDGET
  Widget getOnlineUI() {
    return new Center(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(top: 10),
            itemCount: _recordListData.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int position) {
              Demo_Record record = _recordListData[position];
              return ListTile(
                subtitle: new Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        //Image
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.black,
                          ),
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 3,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: CachedNetworkImage(
                            imageUrl: record.mainImageURL.toString(),
                            imageBuilder: (context, imageProvider) =>
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      )
                                  ),
                                ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                          ),
                        ),
                        //Values
                        Container(
                            color: Colors.cyan[700],
                            height: 150,
                            child: Row(
                                children: <Widget>[
                                  SizedBox(width: 5,),
                                  //Value List
                                  Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 1.6,
                                      child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    SizedBox(height: 70,),
                                                    new Row(
                                                        children: <Widget>[
                                                          SizedBox(width: 5),
                                                          Text("₹ ${record
                                                              .collectedValue} ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight: FontWeight
                                                                      .bold)),
                                                          SizedBox(width: 25),
                                                          Text("₹ ${record
                                                              .totalValue} ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight: FontWeight
                                                                      .bold)),
                                                          SizedBox(width: 30),
                                                          Text(
                                                              " ${calculateNoDays(
                                                                  record
                                                                      .startDate,
                                                                  record
                                                                      .endDate)}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight: FontWeight
                                                                      .bold)),

                                                          SizedBox(width: 20),
                                                        ]),
                                                    SizedBox(height: 25,),
                                                    new Row(
                                                        children: <Widget>[
                                                          SizedBox(width: 5),
                                                          Text("FUNDED",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight: FontWeight
                                                                      .bold)),
                                                          SizedBox(width: 20),
                                                          Text("GOALS",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight: FontWeight
                                                                      .bold)),
                                                          SizedBox(width: 20),
                                                          Text("ENDS IN",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight: FontWeight
                                                                      .bold)),
                                                          SizedBox(width: 20),
                                                        ]),
                                                  ]),
                                            )
                                          ])),
                                  //Button
                                  Column(
                                    children: <Widget>[
                                      SizedBox(height: 80,),
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.circular(
                                              10.0),
                                          color: Colors.white,
                                        ),
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width / 4.5,
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height / 20,
                                        child: MaterialButton(
                                          padding: EdgeInsets.only(right: 10),
                                          onPressed: () {},
                                          child: Text("PLEDGE",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.teal[700],
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 10,)
                                ])
                        )
                      ],
                    ),

                    //Overlapped Container
                    Positioned(
                      left: 10,
                      top: 200,
                      child: Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 8,
                          child: Row(
                              children: <Widget>[
                                Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.white,
                                    ),
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 1.5,
                                    child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width / 2,
                                                        child: Text("  ${record
                                                            .title} ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight: FontWeight
                                                                    .bold)),
                                                      ),
                                                      IconButton(
                                                          alignment: Alignment
                                                              .topRight,
                                                          icon: record.favValue
                                                              ? Icon(
                                                              Icons.favorite)
                                                              : Icon(Icons
                                                              .favorite_border),
                                                          color: Colors.red,
                                                          onPressed: () {
                                                            setState(() {
                                                              if (position ==
                                                                  (record.id) -
                                                                      1) {
                                                                record
                                                                    .favValue =
                                                                true;
                                                              }
                                                              else {
                                                                record
                                                                    .favValue =
                                                                false;
                                                              }
                                                            });
                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 1.5,
                                                    child: Text(" ${record
                                                        .shortDescription}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .teal[700],
                                                            fontWeight: FontWeight
                                                                .normal)),
                                                  )

                                                ]),
                                          )
                                        ])),

                                SizedBox(width: 20),
                                //Button
                                Column(
                                  children: <Widget>[
                                    SizedBox(height: 25,),
                                    Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width / 5.4,
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height / 13,
                                        child: Material(
                                          borderRadius: BorderRadius.circular(
                                              90.0),
                                          color: Colors.cyan[800],
                                          child: MaterialButton(
                                            minWidth: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            onPressed: () {},
                                            child: Text("100%",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight
                                                        .bold)),
                                          ),
                                        )
                                    )
                                  ],
                                ),
                                SizedBox(width: 50),

                              ])
                      ),
                    )
                  ],
                ),

              );
            }
        )
    );
  }

}
