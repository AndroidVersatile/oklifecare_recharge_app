import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants/api_urls.dart';


class APIService {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseUrl,
      validateStatus: (status) => true,
      followRedirects: true,
      maxRedirects: 3,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 50000),
    ),
  );

  static final APIService _apiService = APIService._internal();

  Map<String, String> header = {"Content-type": "application/json"};
  final Connectivity _connectivity = Connectivity();
  bool isConnected = true;
  BuildContext? context;

  factory APIService.ApiClient() {
    return _apiService;
  }

  APIService._internal() {
    init();
    dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        validateStatus: (status) => true,
        followRedirects: true,
        maxRedirects: 3,
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 50000),
      ),
    );
  }

  void setToken(String token) {
    header = {
      "content-type": "application/json",
      "accept": "*/*",
      "authorization": "Bearer $token"
    };
    dio.options.headers = header;
  }

  getToken() => header["authorization"]?.replaceAll("Bearer ", "");

  Future<void> init() async {
    isConnected =
        (await _connectivity.checkConnectivity()) != ConnectivityResult.none;
    _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        isConnected = false;
        showSnackBar(msg: 'Not Connected to internet');
      } else {
        isConnected = true;
      }
    });
  }
  void showLog(String message) {
    if (kDebugMode) {
      print(message);
      print(
        "RESPONSE MESSAGE_____!!!!!!!!!__<<<<<<<<<____<<<<<<<<<<<<<<<<<<<<<",
      );
    }
  }

  showSnackBar({String msg = ''}) {
    Fluttertoast.showToast(msg: msg);
  }
  Future<Response> post(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) {
    return dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
