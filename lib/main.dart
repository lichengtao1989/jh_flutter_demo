// ignore_for_file: unused_import, unnecessary_import

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flustars/flustars.dart';
import 'package:package_info/package_info.dart';
import 'package:oktoast/oktoast.dart';

import 'package:jhtoast/jhtoast.dart';
import 'jh_common/widgets/jh_alert.dart';
import 'jh_common/utils/jh_storage_utils.dart';
import 'jh_common/utils/jh_screen_utils.dart';
import 'project/routes/not_found_page.dart';
import 'project/routes/routes.dart';
import 'project/routes/routes_old.dart' as luyou;
import 'project/base_tabbar.dart';
import 'project/login/pages/login_page.dart';
import 'project/new_feature/new_feature_page.dart';
import 'project/configs/project_config.dart';
import 'project/model/user_model.dart';

/*
    屏幕宽度高度：MediaQuery.of(context).size.width
    屏幕宽度高度：MediaQuery.of(context).size.height
    屏幕状态栏高度：MediaQueryData.fromWindow(WidgetBinding.instance.window).padding.top。

    MediaQueryData mq = MediaQuery.of(context);
    // 屏幕密度
    pixelRatio = mq.devicePixelRatio;
    // 屏幕宽(注意是dp, 转换px 需要 screenWidth * pixelRatio)
    screenWidth = mq.size.width;
    // 屏幕高(注意是dp)
    screenHeight = mq.size.height;
    // 顶部状态栏, 随着刘海屏会增高
    statusBarHeight = mq padding.top;
    // 底部功能栏, 类似于iPhone XR 底部安全区域
    bottomBarHeight = mq.padding.bottom;

*/

//void main() => runApp(MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();

//  debugProfileBuildsEnabled = true;
//  debugPaintLayerBordersEnabled = true;
//  debugProfilePaintsEnabled = true;
//  debugRepaintRainbowEnabled = true;

  runApp(MyApp());

  if (Platform.isAndroid) {
    print("Android");
  } else if (Platform.isIOS) {
    print("iOS");
  }

  // 透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _currentVersion = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    LogUtils.init();
    HttpUtils.initDio();
    Routes.initRoutes();
    _getInfo(); // 获取设备信息
  }

  @override
  Widget build(BuildContext context) {
    JhScreenUtils.init(context);
    return OKToast(
//          dismissOtherOnShow: true,
        child: _buildMaterialApp());
  }

  Widget _buildMaterialApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
//                brightness: // 深色还是浅色
//                primarySwatch: Colors.blue // 主题颜色样本
        primaryColor: KColors.kThemeColor, // 主色，决定导航栏颜色
        // 次级色，决定大多数Widget的颜色，如进度条、开关等。
        primaryIconTheme: IconThemeData(color: KColors.wxTitleColor),
      ),
//            home: IndexPage(),
//            home: BaseTabBar(),
      home: _switchRootWidget(),
      // 注册路由
//    routes: luyou.routes,
      onGenerateRoute: Routes.router.generator,
      onUnknownRoute: (RouteSettings settings) =>
          MaterialPageRoute(builder: (context) => const NotFoundPage()),
      //        locale: Locale('en','US'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
//    GlobalEasyRefreshLocalizations.delegate,
        const FallbackCupertinoLocalisationsDelegate()
      ],
      supportedLocales: [
        Locale('zh', 'CN'),
//        Locale('en', 'US'),
      ],
    );
  }

  void _getInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _currentVersion = packageInfo.version;
    });
  }

  Widget _switchRootWidget() {
    var lastVersion = JhStorageUtils.getStringWithKey(kUserDefault_LastVersion);
//    print('lastVersion 版本号：$lastVersion');
    if (lastVersion == null || lastVersion == '') {
//      print('首次安装');
      return NewFeaturePage();
    } else {
//      print(oldVersion.compareTo(_currentVersion)); // 字符串 比较大小, 0:相同、1:大于、-1:小于
      if (lastVersion.compareTo(_currentVersion) < 0) {
//        print('新版本安装');
        return NewFeaturePage();
      } else {
//        print('正常启动');
//        userModel model =
//            SpUtil.getObj(kUserDefault_UserInfo, (v) => userModel.fromJson(v));
        var modelJson = JhStorageUtils.getModelWithKey(kUserDefault_UserInfo);
        if (modelJson != null) {
          UserModel model = UserModel.fromJson(modelJson);
          print('本地取出的 userName:' + model.userName!);
          return BaseTabBar();
        } else {
          return LoginPage();
        }
      }
    }
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}

//void main() => runApp(MyApp());
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Welcome to Flutter',
//      home: new Scaffold(
//        appBar: new AppBar(
//          title: new Text('Welcome to Flutter'),
//        ),
//        body: new Center(
//          child: new Text('Hello World'),
//        ),
//      ),
//    );
//  }
//}
