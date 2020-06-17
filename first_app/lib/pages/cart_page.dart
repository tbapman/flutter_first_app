import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<String> textList = [];
  @override
  Widget build(BuildContext context) {
    _show();
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 500.0,
            child: ListView.builder(
              itemCount: textList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(textList[index]),
                );
              },
            ),
          ),
          RaisedButton(
            onPressed: _add,
            child: Text('增加'),
          ),
          RaisedButton(
            onPressed: _clear,
            child: Text('清空'),
          ),
        ],
      ),
    );
  }

  //增加
  void _add() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String temp = '一给我里giao';
    textList.add(temp);

    prefs.setStringList('textInfo', textList);
    _show();
  }

  //查询
  void _show() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('textInfo') != null) {
      setState(() {
        textList = prefs.getStringList('textInfo');
      });
    }
  }

  //删除
  void _clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('textInfo');
    setState(() {
      textList = [];
    });
  }
}
