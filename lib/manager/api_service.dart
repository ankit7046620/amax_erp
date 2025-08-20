// lib/services/api_service.dart

import 'dart:io';

import 'package:amax_hr/main.dart';
import 'package:amax_hr/vo/WarehouseModel.dart' show WarehouseModel;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://plastic.techcloudamax.ai/',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  /// 🔹 GET Method
  static Future<Response?> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      await _attachSession(); // Load session before every request
      final response = await dio.get(endpoint, queryParameters: params);
      print("❌ ($endpoint): $response");
      return response;
    } catch (e) {
      print("❌ GET Error ($endpoint): $e");
      return null;
    }
  }

  /// 🔹 POST Method
  // static Future<Response?> post(String endpoint, Map<String, dynamic> data) async {
  //   try {
  //     await _attachSession(); // Load session before every request
  //     final response = await dio.post(endpoint, data: data);
  //     return response;
  //   } catch (e) {
  //     print("❌ POST Error ($endpoint): $e");
  //     return null;
  //   }
  // }

  static Future<Response?> post(String endpoint, {required Map<String, dynamic> data}) async {
    try {
      await _attachSession(); // Load session before every request
      final response = await dio.post(endpoint, data: data);
      return response;
    } catch (e) {
      print("❌ POST Error ($endpoint): $e");
      return null;
    }
  }

  static Future<Response?> postWithFile(
      String endpoint, {
        required Map<String, dynamic> data,
        File? file,
        String fileField = 'attachment',
      }) async {
    try {
      await _attachSession();

      // ERPNext requires "doctype" in the payload
      if (!data.containsKey('doctype')) {
        data['doctype'] = 'Task';
      }

      dynamic postData;

      if (file != null) {
        // Create FormData for file + fields
        FormData formData = FormData();

        // Add fields
        data.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });

        // Add file
        formData.files.add(
          MapEntry(
            fileField,
            await MultipartFile.fromFile(file.path,
                filename: file.path.split('/').last),
          ),
        );

        postData = formData;
      } else {
        // Send fields as FormData even without file (ERPNext prefers FormData for POST)
        FormData formData = FormData();
        data.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
        postData = formData;
      }

      final response = await dio.post(endpoint, data: postData);

      debugPrint("✅ POST Response ($endpoint): ${response.data}");
      return response;
    } catch (e) {
      print("❌ POST Error ($endpoint): $e");
      return null;
    }
  }




  static Future<Response?> put(String endpoint, {required Map<String, dynamic> data}) async {
    try {
      await _attachSession(); // Make sure session headers/cookies are attached

      final response = await dio.put(
        endpoint,
        data: data,
        options: Options(
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        // Server responded with error (4xx or 5xx)
        print("❌ PUT Error → ${e.requestOptions.uri}");
        print("📦 Status: ${e.response?.statusCode}");
        print("📄 Body: ${e.response?.data}");
      } else {
        // Network error, timeout, etc.
        print("❌ PUT Network Error → ${e.requestOptions.uri}");
        print("📄 Message: ${e.message}");
      }
      return null;
    } catch (e) {
      // Unexpected error
      print("❌ PUT Unexpected Error → $endpoint");
      print("📄 Exception: $e");
      return null;
    }
  }



  static Future<Response?> delete(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      await _attachSession();
      final response = await dio.delete(endpoint, data: data);
      return response;
    } catch (e) {
      print("❌ DELETE Error ($endpoint): $e");
      return null;
    }
  }

  /// 🔐 Save session and set headers
  static Future<void> setSessionFromLoginResponse(String responseText) async {
    final prefs = await SharedPreferences.getInstance();

    // Extract session info
    final sidMatch = RegExp(r'sid=([a-f0-9]+)').firstMatch(responseText);
    final fullNameMatch = RegExp(r'full_name=([^;,\}]+)').firstMatch(responseText);
    final userIdMatch = RegExp(r'user_id=([^;,\}]+)').firstMatch(responseText);

    final sid = sidMatch?.group(1) ?? '';
    final fullName = fullNameMatch?.group(1) ?? '';
    final userIdEncoded = userIdMatch?.group(1) ?? '';
    final userId = Uri.decodeComponent(userIdEncoded);

    await prefs.setString('sid', sid);
    await prefs.setString('full_name', fullName);
    await prefs.setString('user_id', userId);

    _updateCookieHeader(sid, fullName, userId);
  }

  /// ✅ Called automatically before any request
  static Future<void> _attachSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sid = prefs.getString('sid');
    final fullName = prefs.getString('full_name');
    final userId = prefs.getString('user_id');

    if (sid != null && fullName != null && userId != null) {
      _updateCookieHeader(sid, fullName, userId);
    }
  }

  /// 🔄 Apply header to Dio
  static void _updateCookieHeader(String sid, String fullName, String userId) {
    final cookie =
        'sid=$sid; full_name=$fullName; system_user=yes; user_id=$userId; user_image=';
    dio.options.headers['Cookie'] = cookie;
  }

  /// 🔓 Optional: Clear session
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sid');
    await prefs.remove('full_name');
    await prefs.remove('user_id');
    dio.options.headers.remove('Cookie');
  }
}
