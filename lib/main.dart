import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:techgrains/com/techgrains/util/tg_flavor.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  TGFlavor.init("assets/config/flavors.json");

  runApp(
    ScreenUtilInit(
      designSize: MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return const MyApp();
      },
    ),
  );
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