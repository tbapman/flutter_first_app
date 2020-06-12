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
    res = await dio.get(servicePath['homePageContent']);
    return res.data;
  } catch (e) {
    print(e);
  }
}

//获取首页内容
Future getHomeHotProduct(data) async {
  Response res;
  try {
    Dio dio = new Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    res = await dio.get(servicePath['hotProduct'],queryParameters:data );
    print(res);
    return res.data;
  } catch (e) {
    print(e);
  }
}

//获取分类
Future getCategory() async {
  Response res;
  try {
    Dio dio = new Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    res = await dio.get(servicePath['getCategory']);
    return res.data;
  } catch (e) {
    print(e);
  }
}

//获取分类
Future getProduct(data) async {
  Response res;
  try {
    Dio dio = new Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    res = await dio.get(servicePath['getProduct'],queryParameters: data);
    return res.data;
  } catch (e) {
    print(e);
  }
}