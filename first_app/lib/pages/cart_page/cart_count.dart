import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';

class CartCount extends StatelessWidget {
  var item;
  CartCount(this.item);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(165),
      margin: EdgeInsets.only(top: 5.0),
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
      child: Row(
        children: <Widget>[_minusBtn(context), _countArea(), _plusBtn(context)],
      ),
    );
  }

  //减
  Widget _minusBtn(context) {
    return InkWell(
      onTap: () {
        Provide.value<CartProvide>(context).plusOrMinus(item, 'minus');
      },
      child: Container(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: item.count > 1 ? Colors.white : Colors.black12,
            border: Border(right: BorderSide(width: 1, color: Colors.black12))),
        child: item.count > 1 ? Text('-') : Text(' '),
      ),
    );
  }

  //加
  Widget _plusBtn(context) {
    return InkWell(
      onTap: () {
        Provide.value<CartProvide>(context).plusOrMinus(item, 'plus');
      },
      child: Container(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(left: BorderSide(width: 1, color: Colors.black12))),
        child: Text('+'),
      ),
    );
  }

  //数量
  Widget _countArea() {
    return Container(
      width: ScreenUtil().setWidth(70),
      height: ScreenUtil().setHeight(45),
      alignment: Alignment.center,
      color: Colors.white,
      child: Text('${item.count}'),
    );
  }
}
