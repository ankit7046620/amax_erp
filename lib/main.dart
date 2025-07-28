import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:logger/logger.dart';
import 'package:techgrains/com/techgrains/util/tg_flavor.dart';

import 'app/routes/app_pages.dart';

var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  TGFlavor.init("assets/config/flavors.json");

  configLoading(); // ✅ call this BEFORE runApp

  runApp(
    ScreenUtilInit(
      designSize: MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.first,
      ).size,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return const MyApp();
      },
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorWidget = Center(
      child: Image.asset(
        'assets/images/tech_cloud1.gif', // ✅ Make sure this path is correct
        width: 150,
        height: 150,
        fit: BoxFit.contain,
      ),
    )
    ..maskColor = Colors.black.withOpacity(0.3)
    ..backgroundColor = Colors.transparent
    ..indicatorSize = 150
    ..userInteractions = false
    ..dismissOnTap = false;
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      theme: ThemeData(useMaterial3: false, primaryColor: Colors.white),
      title: "GETX DEMO",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
