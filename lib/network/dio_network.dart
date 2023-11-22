import 'dart:convert';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '/utils/constant.dart';
import 'dio_exception.dart';
import 'dio_response_model.dart';

class DioNetwork {
  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 30),
  ));

  static Future<DioResponseModel<T>> post<T extends dynamic>(
    String url,
    Map<String, dynamic> data,
  ) async {
    Response res;
    try {
      debugPrint("[POST] ${Constant.apiURL + url}");
      if (data != {}) {
        try {
          debugPrint("[Body] ${jsonEncode(data)}");
        } catch (_) {}
      }

      res = await _dio.post(
        Constant.apiURL + url,
        data: data,
      );

      if (res.data != null) {
        debugPrint("[RES] ${jsonEncode(res.data)}");
      }

      return await _processData<T>(res);
    } on DioException catch (dioErr) {
      return await handleError<T>(dioErr);
    } catch (ee) {
      return DioResponseModel<T>(
        success: false,
        msg: jsonEncode(ee),
      );
    }
  }

  static Future<DioResponseModel<T>> get<T extends dynamic>(
    String url, {
    Map<String, dynamic>? queryData,
  }) async {
    Response res;
    try {
      debugPrint("[GET] ${Constant.apiURL + url}");
      if (queryData != null && queryData != {}) {
        try {
          debugPrint("[Query] ${jsonEncode(queryData)}");
        } catch (_) {}
      }

      res = await _dio.get(
        Constant.apiURL + url,
        queryParameters: queryData,
        options: Options(
          headers: {"content-type": "application/json"},
        ),
      );

      if (res.data != null) {
        debugPrint("[RES] ${jsonEncode(res.data)}");
      }

      return await _processData<T>(res);
    } on DioException catch (dioErr) {
      return await handleError<T>(dioErr);
    } catch (ee) {
      return DioResponseModel<T>(
        success: false,
        msg: jsonEncode(ee),
      );
    }
  }

  static Future<DioResponseModel<T>> _processData<T extends dynamic>(
    Response? res, {
    String? errorMsg,
  }) async {
    try {
      return DioResponseModel<T>(
        success: true,
        data: res?.data as T,
      );
    } catch (err) {
      debugPrint("[ERR] $err $res");

      return DioResponseModel<T>(
        success: false,
        msg: errorMsg ?? "Unable to process data.",
      );
    }
  }
}
