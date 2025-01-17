import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class SwiperTest1Page extends StatefulWidget {
  @override
  _SwiperTest1PageState createState() => _SwiperTest1PageState();
}

class _SwiperTest1PageState extends State<SwiperTest1Page> {
  List imgList = [
    "https://gitee.com/iotjh/Picture/raw/master/cat.png",
    "https://gitee.com/iotjh/Picture/raw/master/lufei2.png",
    "https://gitee.com/iotjh/Picture/raw/master/swiper/picture0.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: backAppBar(context, 'flutter-swiper 1'),
      body: Container(
//        padding: EdgeInsets.fromLTRB(0, 10, 0, 50),
//        height: 280,
        child: Swiper(
          scrollDirection: Axis.horizontal,
          itemCount: imgList.length,
          autoplay: true,
          itemBuilder: (BuildContext context, int index) {
            return Image.network(imgList[index], fit: BoxFit.fill);
          },
          // 点击事件 onTap
          onTap: (index) {
            print('点击了第$index');
            Navigator.pop(context);
          },
          // 分页指示器
          pagination: SwiperPagination(
              // 位置 Alignment.bottomCenter 底部中间
              alignment: Alignment.bottomCenter,
              // 距离调整
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
              builder: DotSwiperPaginationBuilder(
                  // 点之间的间隔
                  space: 5,
                  // 没选中时的大小
                  size: 10,
                  // 选中时的大小
                  activeSize: 12,
                  // 没选中时的颜色
                  color: Colors.grey,
                  // 选中时的颜色
                  activeColor: Colors.white)),
          // 页面控制器 左右翻页按钮
//          control: new SwiperControl(color: Colors.pink),
//          scale: 0.95, // 两张图片之间的间隔
//          viewportFraction: 0.8,// 当前视窗展示比例 小于1可见上一个和下一个视窗
        ),
      ),
    );
  }
}

/*

Swiper(
  scrollDirection: Axis.horizontal,// 方向 Axis.horizontal  Axis.vertical
  itemCount: 4, // 展示数量
  autoplay: true,// 自动翻页
  itemBuilder:(){...},// 布局构建
  onTap:(){...}, // 点击时间
  pagination: SwiperPagination(), // 分页指示
  viewportFraction: 0.8, // 视窗比例
  layout: SwiperLayout.STACK, // 布局方式
  itemWidth: MediaQuery.of(context).size.width, // 条目宽度
  itemHeight: MediaQuery.of(context).size.height, // 条目高度
  autoplayDisableOnInteraction: true, // 用户进行操作时停止自动翻页
  loop: true, // 无限轮播
  indicatorLayout: PageIndicatorLayout.SLIDE, // 指标布局
)


* */
