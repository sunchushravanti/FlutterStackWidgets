import 'package:flutter/material.dart';
import 'package:flutter_app/Background.dart';
import 'package:flutter_app/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Nimap Infotech Ltd';
    return MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        home: MyAppSate(),
       routes: <String, WidgetBuilder>{
      '/screen1': (BuildContext context) => new HomePage(),
    }
    );
  }
}

class MyAppSate extends StatefulWidget {
  State createState() => MyApp_State();
}

class MyApp_State extends State<MyAppSate> {

  @override
  void initState() {
    //check the internet
    Future.delayed(const Duration(seconds: 3), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
     });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Background(),
          ],
        ));
  }

}
