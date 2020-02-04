import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/CheckInternet.dart';
import 'package:flutter_app/ToastMsg.dart';
import 'package:http/http.dart';

class APIConsumption {
  CheckInternet checkInternet = CheckInternet();
  ToastMsg msg = ToastMsg();

  var response;
  String URL = "http://test.chatongo.in/";
  bool internetStatus;

  //Login API
  recordListApi(BuildContext context) async {
    try {
      Response apiResponse;
      String url = '${URL}testdata.json';
      //headers
      Map<String, String> headers = {"Content-type": "application/json"};

      internetStatus = await checkInternet.checkInternet(context);
      if (internetStatus) { //response
        apiResponse = await get(url, headers: headers);
        print("API RES: ${apiResponse.body}");
        if (apiResponse.statusCode == 200 ) {
          if (apiResponse.body.isNotEmpty) {
            return response =(jsonDecode(apiResponse.body));
          }
          else {
            return msg.getNoDataFoundMsg(context);
          }
        }
        else {
          return msg.getInternetFailureMsg(context);
        }
      }
      else {
        return msg.getInternetFailureMsg(context);
      }
    }
    catch (Exception) {
              return msg.getSomethingWentWrong(context);
    }
  }
}