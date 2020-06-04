import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              List<Map> swiper =
                  (snapshot.data['data'] as List).take(3).toList().cast();
              List<Map> navigatorList = (snapshot.data['data'] as List).cast();
              String adPicture =
                  (snapshot.data['data'] as List)[0]['bannerUrl'];
              String leaderImage =
                  (snapshot.data['data'] as List)[0]['leaderImage'];
              String leaderPhone =
                  (snapshot.data['data'] as List)[0]['leaderPhone'];

              List<dynamic> recommentList =
                  (snapshot.data['data'] as List)[0]['recommend'];
              return SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  SwiperDiy(
                    swiperDataList: swiper,
                  ),
                  TopNavigator(
                    navigatorList: navigatorList,
                  ),
                  AdBanner(adPicture: adPicture),
                  LeaderPhone(
                    leaderImage: leaderImage,
                    leaderPhone: leaderPhone,
                  ),
                  Recommend(
                    recommendList: recommentList,
                  )
                ],
              ));
            } else {
              return Center(
                child: Text('加载中...'),
              );
            }
          },
        ));
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
            '${swiperDataList[index]['image']}',
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
        Image.network(item['category']['image'],
            width: ScreenUtil().setHeight(80)),
        Text(item['category']['name'])
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(320),
        padding: EdgeInsets.all(3.0),
        child: GridView.count(
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
// [
//   {
//     "image":"http://img12.360buyimg.com/n1/s450x450_jfs/t1/79668/22/9987/159271/5d780915Ebf9bf3f4/6a1b2703a9ed8737.jpg",
//     "mallPrice":1,
//     "price":1
//   },
//   {
//     "image":"http://img12.360buyimg.com/n1/s450x450_jfs/t1/79668/22/9987/159271/5d780915Ebf9bf3f4/6a1b2703a9ed8737.jpg",
//     "mallPrice":1,
//     "price":1
//   },
//   {
//     "image":"http://img12.360buyimg.com/n1/s450x450_jfs/t1/79668/22/9987/159271/5d780915Ebf9bf3f4/6a1b2703a9ed8737.jpg",
//     "mallPrice":1,
//     "price":1
//   },
// ]
