import 'package:flutter/material.dart';
import '../service/service_method.dart';
import '../model/category.dart';
import '../model/categoryGoodList.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CatrgoryPageState createState() => _CatrgoryPageState();
}

class _CatrgoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            CategoryNav(),
            Column(
              children: <Widget>[RightNav(), Product()],
            )
          ],
        ),
      ),
    );
  }
}

class CategoryNav extends StatefulWidget {
  @override
  _CategoryNavState createState() => _CategoryNavState();
}

class _CategoryNavState extends State<CategoryNav> {
  List list = [];
  int listIndex = 0;
  @override
  void initState() {
    super.initState();
    _getCategory();
    _getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _leftItem(index);
        },
      ),
    );
  }

  Widget _leftItem(int index) {
    bool isClick = false;
    isClick = index == listIndex ? true : false;
    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        print(childList);
        Provide.value<ChildCategory>(context)
            .getChildCategory(childList, categoryId);
        _getProduct(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
            color: isClick ? Color.fromRGBO(236, 236, 236, 0.5) : Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(30)),
        ),
      ),
    );
  }

  void _getCategory() async {
    await getCategory().then((res) {
      ResponseData obj = ResponseData.fromJson(res);
      setState(() {
        list = obj.data;
      });
      Provide.value<ChildCategory>(context)
          .getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
    });
  }

  void _getProduct({String categoryId}) async {
    var data = {'categoryId': categoryId ?? '4', 'page': 1};
    await getProduct(data).then((res) {
      CategoryGoodsList obj = CategoryGoodsList.fromJson(res);
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(obj.data);
    });
  }
}

class RightNav extends StatefulWidget {
  RightNav({Key key}) : super(key: key);

  @override
  _RightNavState createState() => _RightNavState();
}

class _RightNavState extends State<RightNav> {
  // List list=['名酒','宝丰','北京二锅头','舍得','五粮液','茅台','文王贡酒'];
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context, child, childCategory) {
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black12))),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (context, index) {
              return _rightItem(index, childCategory.childCategoryList[index]);
            },
          ),
        );
      },
    );
  }

  Widget _rightItem(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick = (index == Provide.value<ChildCategory>(context).childIndex)
        ? true
        : false;
    return InkWell(
      onTap: () {
        Provide.value<ChildCategory>(context)
            .changeChildIndex(index, item.mallSubId);
        _getProduct(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(item.mallSubName,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: isClick ? Colors.pink : Colors.black)),
      ),
    );
  }

  void _getProduct(String categorySubId) {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId
    };
    getProduct(data).then((res) {
      CategoryGoodsList obj = CategoryGoodsList.fromJson(res);
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(obj.data);
    });
  }
}

class Product extends StatefulWidget {
  Product({Key key}) : super(key: key);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  var scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(builder: (context, child, data) {
      try {
        if (Provide.value<ChildCategory>(context).page == 1) {
          scrollController.jumpTo(0.0);
        }
      } catch (e) {
        print('第一次进入页面$e');
      }

      if (data.goodsList.length > 0) {
        return Container(
            width: ScreenUtil().setWidth(570),
            height: ScreenUtil().setHeight(1000),
            child: EasyRefresh(
                footer: ClassicalFooter(
                    loadText: '下拉加载更多',
                    loadingText: '正在加载中...',
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    loadedText: '没有更多了'),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: data.goodsList.length,
                  itemBuilder: (context, index) {
                    return _listItem(data.goodsList, index);
                  },
                ),
                onLoad: () async {
                  _loadMore();
                }));
      } else {
        return Container(
          padding: EdgeInsets.only(top: 30),
          child: Text('暂无该类商品'),
        );
      }
    });
  }

  void _loadMore() {
    Provide.value<ChildCategory>(context).addPage();
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page,
    };
    getProduct(data).then((res) {
      CategoryGoodsList obj = CategoryGoodsList.fromJson(res);
      if (obj.data.length == 0) {
        Fluttertoast.showToast(
            msg: '已经到底了',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      Provide.value<CategoryGoodsListProvide>(context).getMoreList(obj.data);
    });
  }

  Widget _goodsImage(List newList, index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList, index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(newList[index].goodsName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: ScreenUtil().setSp(28))),
    );
  }

  Widget _goodsPrice(List newList, index) {
    return Container(
      width: ScreenUtil().setWidth(370),
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Text(
            '价格：￥${newList[index].presentPrice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '￥${newList[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          )
        ],
      ),
    );
  }

  Widget _listItem(List newList, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
        child: Row(
          children: <Widget>[
            _goodsImage(newList, index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index)
              ],
            )
          ],
        ),
      ),
    );
  }
}
