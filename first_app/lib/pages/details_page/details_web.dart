import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailsWeb extends StatelessWidget {
  const DetailsWeb({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var goodsDetails = Provide.value<DetailsInfoProvide>(context)
        .goodsInfo
        .data
        .goodsInfo
        .goodsDetail;

    return Provide<DetailsInfoProvide>(
      builder: (context, child, val) {
        var isLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
        if (isLeft) {
          return Container(
            child: Html(
              data:
                  '''<div class="content ke-post" style="height: auto;"><p style="text-align: center;"><img src="https://img.alicdn.com/imgextra/i3/2206507193056/O1CN01rbDE0O1YRgw6QW9fr_!!2206507193056.jpg" align="absmiddle" class="img-ks-lazyload" data-spm-anchor-id="a220o.1000855.0.i0.4d1a60e6Sr8JCJ"><img src="https://img.alicdn.com/imgextra/i3/2206507193056/O1CN01iOOOgO1YRgw8bp9Ya_!!2206507193056.jpg" align="absmiddle" class="img-ks-lazyload"><img src="https://img.alicdn.com/imgextra/i2/2206507193056/O1CN01SbS6iA1YRgw7erkLM_!!2206507193056.jpg" align="absmiddle" class="img-ks-lazyload"><img src="https://img.alicdn.com/imgextra/i1/2206507193056/O1CN01ZeGkyD1YRgw7esU5L_!!2206507193056.jpg" align="absmiddle" class="img-ks-lazyload"><img src="https://img.alicdn.com/imgextra/i1/2206507193056/O1CN01T46XcL1YRgw7esxBJ_!!2206507193056.jpg" align="absmiddle" class="img-ks-lazyload"> </p></div>''',
            ),
          );
        } else {
          return Container(
            width: ScreenUtil().setWidth(750),
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text('评论页面'),
          );
        }
      },
    );
  }
}
