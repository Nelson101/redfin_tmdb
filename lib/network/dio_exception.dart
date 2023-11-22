import 'package:dio/dio.dart';

import '/utils/shared_pref.dart';
import 'dio_response_model.dart';

Future<DioResponseModel<T>> handleError<T extends dynamic>(
  DioException dioError, {
  bool resetRouteAuthErr = true,
}) async {
  String? tmpErrMsg;

  if (dioError.type == DioExceptionType.badResponse) {
    if (dioError.response?.statusCode == 401) {
      SharedPref.clear();

      return DioResponseModel<T>(
        success: false,
        msg: tmpErrMsg ?? "Unauthorized",
      );
    } else {
      return DioResponseModel<T>(
        success: false,
        msg: _statusCodeMsg(dioError.response?.statusCode),
      );
    }
  } else {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        tmpErrMsg = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        tmpErrMsg = "Connection timeout with API server";
        break;
      case DioExceptionType.receiveTimeout:
        tmpErrMsg = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.sendTimeout:
        tmpErrMsg = "Send timeout in connection with API server";
        break;
      case DioExceptionType.unknown:
        if ((dioError.message ?? "").contains("SocketException")) {
          tmpErrMsg = 'No Internet';
          break;
        }
        tmpErrMsg = "Unexpected error occurred";
        break;
      case DioExceptionType.connectionError:
        tmpErrMsg = "No internet connection.";
        break;
      default:
        tmpErrMsg = dioError.message;
        break;
    }

    return DioResponseModel<T>(
      success: false,
      msg: tmpErrMsg,
    );
  }
}

String _statusCodeMsg(int? statusCode) {
  switch (statusCode) {
    case 400:
      return 'Bad request';
    case 401:
      return 'Unauthorized';
    case 403:
      return 'Forbidden';
    case 404:
      return 'API not found';
    case 500:
      return 'Internal server error';
    case 502:
      return 'Bad gateway';
    default:
      return 'Oops something went wrong';
  }
}
