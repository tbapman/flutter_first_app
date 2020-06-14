import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';
import 'package:fluro/fluro.dart';
import './routers/routes.dart';
import './routers/application.dart';
void main() {
  var counter = Counter();
  var childCategory = ChildCategory();
  var providers = Providers();
  var categoryGoodsListProvide = CategoryGoodsListProvide();

  providers..provide(Provider<Counter>.value(counter));
  providers
    ..provide(
        Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide));
  providers..provide(Provider<ChildCategory>.value(childCategory));

  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router=router;
    return Container(
        child: MaterialApp(
      title: '百姓生活+',
      onGenerateRoute: Application.router.generator,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.pink),
      home: IndexPage(),
    ));
  }
}
