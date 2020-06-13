import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; //子类高亮索引
  String categoryId = '4'; //大类Id
  String subId='';//小类id

  getChildCategory(List<BxMallSubDto> list, String id) {
    childIndex = 0;
    categoryId = id;

    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = 'all';
    all.mallCategoryId = 'all';
    all.comments = 'all';
    all.mallSubName = '全部';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  //改变子类索引
  changeChildIndex(index,String id) {
    childIndex = index;
    subId=id;
    notifyListeners();
  }
}
