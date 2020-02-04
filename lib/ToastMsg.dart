

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMsg{



  //Failure MSGS
  getInternetFailureMsg(BuildContext context){
    return Fluttertoast.showToast(
      msg: "No Internet Connection!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }


  getNoDataFoundMsg(BuildContext context) {
    return Fluttertoast.showToast(
        msg: "No data found!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0

    );
  }
  getSomethingWentWrong(BuildContext context) {
      return Fluttertoast.showToast(
          msg: "Something Went Wrong!\n Please try after some time.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0

      );
    }


}