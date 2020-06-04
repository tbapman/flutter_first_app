import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

//获取首页内容
Future getHomePageContent() async {
  Response res;
  try {
    Dio dio = new Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    res = await dio.get(servicePath['homePageContent']);
    print('-------------------');
    print(res);
    return res.data;
  //   if (res.statusCode == 200) {
  //     return res;
  //   } else {
  //     throw Exception('后台服务异常');
  //   }
  } catch (e) {
    print(e);
  }
}
