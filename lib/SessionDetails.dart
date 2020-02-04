import 'package:shared_preferences/shared_preferences.dart';

class SessionDetails {

  void saveImageList(String imgList) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("imageList", imgList);
    sharedPreferences.commit();
  }

}