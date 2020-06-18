import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier {
  String cartString = '[]';
  List<CartInfoModel> cartList = [];
  double totalPrice = 0; //总价格
  int totalCount = 0; //总数量
  bool isAllCheck = true; //是否全选

  save(goodsId, goodsName, count, price, image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    int ival = 0;
    totalCount = 0;
    totalPrice = 0;
    tempList.forEach((item) {
      //存在重复商品  数量+1
      if (item['goodsId'] == goodsId) {
        tempList[ival]['count'] = ++item['count'];
        cartList[ival].count++;
        isHave = true;
      }
      if (item['isCheck']) {
        totalPrice += (cartList[ival].price * cartList[ival].count);
        totalCount += cartList[ival].count;
      }
      ival++;
    });
    //不存在重复商品
    if (!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': image,
        'isCheck': true
      };
      tempList.add(newGoods);
      cartList.add(CartInfoModel.fromJson(newGoods));

      totalPrice += (count * price);
      totalCount += count;
    }
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    notifyListeners();
  }

  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    cartList = [];
    print('清除');
    notifyListeners();
  }

  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    cartList = [];
    if (cartString == null) {
      cartList = [];
    } else {
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      totalPrice = 0;
      totalCount = 0;
      isAllCheck = true;
      tempList.forEach((item) {
        if (item['isCheck']) {
          totalPrice += (item['count'] * item['price']);
          totalCount += item['count'];
        } else {
          isAllCheck = false;
        }
        cartList.add(CartInfoModel.fromJson(item));
      });
    }
    notifyListeners();
  }

  //购物车删除单个
  deleteOneGoods(String goodsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int delIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        delIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList.removeAt(delIndex);
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  changeCheckState(CartInfoModel cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  //切换全选
  changeAllCheckBtnState(bool isCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    List<Map> newList = [];
    for (var item in tempList) {
      var newItem = item;
      newItem['isCheck'] = isCheck;
      newList.add(newItem);
    }

    cartString = json.encode(newList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  //商品数量加减
  plusOrMinus(var cartItem, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int chagneIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        chagneIndex = tempIndex;
      }
      tempIndex++;
    });
    if (type == 'plus') {
      cartItem.count++;
    } else if (cartItem.count > 1) {
      cartItem.count--;
    }

    tempList[chagneIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }
}
