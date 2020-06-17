import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodsInfo = null;
  bool isLeft = true;
  bool isRight = false;

  //底部tabBar切换方法
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }

  getGoodsInfo(String id) async {
    var obj = {"id": id};
    await getDetail(obj).then((res) {
      goodsInfo = DetailsModel.fromJson(res);
      print('----------');
      print(res);
      notifyListeners();
    });
  }
}
