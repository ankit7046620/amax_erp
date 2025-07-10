import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../manager/api_service.dart';
import 'app.dart';

class AppFunction {
  static void goToAndReplace(String routeName, {dynamic arguments}) {
    Get.offNamed(routeName, arguments: arguments);
  }

  static Map<String, String> defaultHeaders() {
    Map<String, String> headers = {};
    headers[HeadersKey.contentType] = HeadersKey.applicationJson;
    headers[HeadersKey.appSource] = Platform.isAndroid ? HeadersKey.android : HeadersKey.iOS;
    headers[HeadersKey.appVersion] = "30009";
    return headers;
  }





  static Future<void> setSessionFromLoginResponse(String responseText) async {
    final prefs = await SharedPreferences.getInstance();

    // Extract session ID
    final sessionIdMatch = RegExp(r'sid=([a-f0-9]+)').firstMatch(responseText);
    final sessionId = sessionIdMatch?.group(1) ?? '';

    // Extract full_name
    final fullNameMatch = RegExp(r'full_name=([^;,\}]+)').firstMatch(responseText);
    final fullName = fullNameMatch?.group(1) ?? '';

    // Extract user_id (email)
    final userIdMatch = RegExp(r'user_id=([^;,\}]+)').firstMatch(responseText);
    final userIdEncoded = userIdMatch?.group(1) ?? '';
    final userId = Uri.decodeComponent(userIdEncoded);

    // Store in SharedPreferences
    await prefs.setString('sid', sessionId);
    await prefs.setString('full_name', fullName);
    await prefs.setString('user_id', userId);

    // Also update Dio headers
    final cookieHeader =
        'sid=$sessionId; full_name=$fullName; system_user=yes; user_id=$userId; user_image=';
    ApiService.dio.options.headers['Cookie'] = cookieHeader;

    print('Session saved to local storage and headers set');
    print('${cookieHeader}');
  }


}