import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartProvide with ChangeNotifier {
  String cartString = '[]';
  save(goodsId, goodsName, count, price, image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    int ival = 0;
    tempList.forEach((item) {
      //存在重复商品  数量+1
      if (item['goodsId'] == goodsId) {
        tempList[ival]['count'] = ++item['count'];
        isHave = true;
      }
      ival++;
    });
    //不存在重复商品
    if (!isHave) {
      tempList.add({
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': image
      });
      notifyListeners();
    }
    cartString = json.encode(tempList).toString();
    print('--------');
    print(goodsId);
    print(cartString);
    prefs.setString('cartInfo', cartString);
  }

  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    print('清除');
    notifyListeners();
  }
}
