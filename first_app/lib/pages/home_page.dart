import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../routers/application.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int current = 1;
  List<Map> hotGoodsList = [];
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print('0000000000000000000000');
    // _getHotGoods();
  }

  String homePageContent = '正在获取数据';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('百姓生活+'),
        ),
        body: FutureBuilder(
          future: getHomePageContent(),
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.hasData) {
              //数据处理
              List<dynamic> swiper =
                  (snapshot.data['data'] as List)[0]['scrollData'];
              List<dynamic> navigatorList =
                  (snapshot.data['data'] as List)[0]['category'];
              String adPicture =
                  (snapshot.data['data'] as List)[0]['bannerUrl'];
              Map leaderData = (snapshot.data['data'] as List)[0]['leaderData'];
              List<dynamic> recommentList =
                  (snapshot.data['data'] as List)[0]['recommend'];
              List<dynamic> floorData =
                  (snapshot.data['data'] as List)[0]['floorData'];
              return EasyRefresh(
                  footer: ClassicalFooter(
                      loadText: '下拉加载更多',
                      loadingText: '正在加载中...',
                      bgColor: Colors.white,
                      textColor: Colors.pink,
                      loadedText: '没有更多了'),
                  child: ListView(
                    children: <Widget>[
                      SwiperDiy(
                        swiperDataList: swiper,
                      ),
                      TopNavigator(
                        navigatorList: navigatorList,
                      ),
                      AdBanner(adPicture: adPicture),
                      LeaderPhone(
                        leaderImage: leaderData['img'],
                        leaderPhone: leaderData['phone'],
                      ),
                      Recommend(
                        recommendList: recommentList,
                      ),
                      FloorTitle(img_url: floorData[0]['img']),
                      FloorContent(floorGoodsList: floorData[0]['floor_data']),
                      FloorTitle(img_url: floorData[0]['img']),
                      FloorContent(floorGoodsList: floorData[0]['floor_data']),
                      FloorTitle(img_url: floorData[0]['img']),
                      FloorContent(floorGoodsList: floorData[0]['floor_data']),
                      _hotGoods()
                    ],
                  ),
                  onLoad: () async {
                    var query = {'current': current};
                    await getHomeHotProduct(query).then((res) {
                      List<Map> data = (res['data'] as List).cast();
                      setState(() {
                        hotGoodsList.addAll(data);
                        current++;
                      });
                    });
                  });
            } else {
              return Center(
                child: Text('加载中...'),
              );
            }
          },
        ));
  }

  // void _getHotGoods() {
  //   var formData = {'page': page};
  //   getHomeHotProduct().then((res) {
  //     List<Map> data = (res['data'] as List).cast();
  //     setState(() {
  //       hotGoodsList.addAll(data);
  //       page++;
  //     });
  //   });
  // }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    color: Colors.transparent,
    child: Text('火爆专区'),
  );

  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((item) {
        return InkWell(
          onTap: () {
            Application.router
                .navigateTo(context, '/detail?id=${item['goodsId']}');
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(
                  item['img'],
                  width: ScreenUtil().setWidth(370),
                ),
                Text(item['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.pink, fontSize: ScreenUtil().setSp(26))),
                Row(
                  children: <Widget>[
                    Text('￥${item['mallPrice']}'),
                    Text('￥${item['price']}',
                        style: TextStyle(
                            color: Colors.black26,
                            decoration: TextDecoration.lineThrough))
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('接口出错');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[hotTitle, _wrapList()],
      ),
    );
  }
}

//首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  const SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            '${swiperDataList[index]['img']}',
            fit: BoxFit.fill,
          );
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key, this.navigatorList}) : super(key: key);
  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(children: <Widget>[
        Image.network(item['img'], width: ScreenUtil().setHeight(80)),
        Text(item['name'])
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(320),
        padding: EdgeInsets.all(3.0),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
          padding: EdgeInsets.all(5.0),
          children: navigatorList.map((item) {
            return _gridViewItemUI(context, item);
          }).toList(),
        ));
  }
}

class AdBanner extends StatelessWidget {
  final String adPicture;
  const AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(
        adPicture,
        height: ScreenUtil().setHeight(35),
      ),
    );
  }
}

class LeaderPhone extends StatelessWidget {
  final String leaderImage; //店长图片
  final String leaderPhone; //店长电话
  const LeaderPhone({Key key, this.leaderImage, this.leaderPhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchUrl,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchUrl() async {
    String url = 'tel:' + leaderPhone;
    if (await canLaunch((url))) {
      await launch(url);
    } else {
      throw 'url不合法';
    }
  }
}

// 推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key, this.recommendList}) : super(key: key);

  //标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  //单个列表
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(left: BorderSide(width: 0.5, color: Colors.black12))),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  //滚动列表
  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[_titleWidget(), _recommendList()],
      ),
    );
  }
}

//楼层标题
class FloorTitle extends StatelessWidget {
  final String img_url;
  const FloorTitle({Key key, this.img_url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(img_url),
    );
  }
}

//楼层内容
class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  const FloorContent({Key key, this.floorGoodsList}) : super(key: key);
  Widget _goodsItem(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {},
        child: Image.network(goods['img']),
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_firstRow(), _otherGoods()],
      ),
    );
  }
}

// class HotGoods extends StatefulWidget {
//   @override
//   _HotGoodsState createState() => _HotGoodsState();
// }

// class _HotGoodsState extends State<HotGoods> {
//   @override
//   void initState() {
//     super.initState();
//     getHomeHotProduct().then((val){
//       print(val);
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: Text('111'),
//     );
//   }
// }
