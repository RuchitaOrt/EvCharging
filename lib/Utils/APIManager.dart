import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:ev_charging_app/model/WalletListResponse.dart';
import 'package:ev_charging_app/model/WalletResponse.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import 'package:ev_charging_app/Utils/AppEror.dart';
import 'package:ev_charging_app/Utils/ShowDialog.dart';

import 'package:ev_charging_app/model/LoginResponse.dart';
import 'package:ev_charging_app/model/RegistrationResponse.dart';
import 'package:ev_charging_app/model/LogoutResponse.dart';
import 'package:ev_charging_app/model/ProfileResponse.dart';
import 'package:ev_charging_app/model/ChargingHubResponse.dart';
import 'package:ev_charging_app/model/ChargingListResponse.dart';
import 'package:ev_charging_app/model/ChargingStationListResponse.dart';

enum API {
  login,
  registration,
  logout,
  chargerList,
  chargingHubList,
  chargingStationList,
  profile,
  profileUpdate,
  profileDelete,
  addWalletCredits,
  walletDetails,
}

enum HTTPMethod { GET, POST, PUT, DELETE }

class APIManager {
  static Duration? timeout;
  static String? baseURL;
  static String? apiVersion;

  late Dio dio;
  static PersistCookieJar? cookieJar;

  /// 🔒 Singleton
  static final APIManager _instance = APIManager._privateConstructor();
  factory APIManager() => _instance;

  APIManager._privateConstructor() {
    dio = Dio(
      BaseOptions(
        responseType: ResponseType.json,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );

    _setupCookies();
    _addInterceptors();
  }

  /// 🍪 COOKIE SETUP (ONLY ONE JAR)
  Future<void> _setupCookies() async {
    final dir = await getApplicationDocumentsDirectory();

    cookieJar = PersistCookieJar(
      storage: FileStorage("${dir.path}/cookies"),
      ignoreExpires: true,
    );

    dio.interceptors.add(CookieManager(cookieJar!));
  }

  /// 🔍 LOGGING + ERROR INTERCEPTOR
  void _addInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final cookies = await cookieJar?.loadForRequest(options.uri);
          print("🍪 Request cookies: $cookies");
          handler.next(options);
        },
        onResponse: (response, handler) {
          print("🍪 Set-Cookie: ${response.headers['set-cookie']}");
          handler.next(response);
        },
        onError: (e, handler) {
          print("❌ API ERROR: ${e.response?.statusCode}");
          handler.next(e);
        },
      ),
    );
  }

  /// ⚙️ CONFIG
  void loadConfiguration(String configString) {
    final config = jsonDecode(configString);
    final env = config['environment'];

    baseURL = config[env]['hostUrl'];
    apiVersion = config['version'];
    timeout = Duration(seconds: config[env]['timeout']);

    dio.options
      ..baseUrl = baseURL!
      ..connectTimeout = timeout
      ..receiveTimeout = timeout;
  }

  /// 🧭 ENDPOINTS
  String apiEndPoint(API api) {
    switch (api) {
      case API.login:
        return "/User/login";
      case API.registration:
        return "/User/register";
      case API.logout:
        return "/User/logout";
      case API.chargerList:
        return "/ChargingHub/charger-list";
      case API.chargingHubList:
        return "/ChargingHub/charging-hub-list";
      case API.chargingStationList:
        return "/ChargingHub/charging-station-list";
      case API.profile:
        return "/User/profile";
      case API.profileUpdate:
        return "/User/profile-update";
       case API.addWalletCredits: // <-- endpoint
      return "/User/add-wallet-credits";

      case API.profileDelete:
        return "/User/profile-delete";
           case API.walletDetails:
      return "/User/wallet-details";
    }
  }

  /// 🔁 HTTP METHOD
  HTTPMethod apiHTTPMethod(API api) {
    switch (api) {
      case API.chargerList:
      case API.chargingHubList:
      case API.chargingStationList:
      case API.profile:
      case API.walletDetails:
        return HTTPMethod.GET;
      case API.profileUpdate:
        return HTTPMethod.PUT;
      case API.profileDelete:
        return HTTPMethod.DELETE;
      default:
        return HTTPMethod.POST;
    }
  }

  /// 🧩 PARSER
  dynamic parseResponse(API api, dynamic json) {
    switch (api) {
      case API.login:
        return LoginResponse.fromJson(json);
      case API.registration:
        return RegistrationResponse.fromJson(json);
      case API.logout:
        return LogoutResponse.fromJson(json);
      case API.profile:
      case API.profileUpdate:
        return ProfileResponse.fromJson(json);
      case API.chargingHubList:
        return ChargingHubResponse.fromJson(json);
      case API.chargerList:
        return ChargingListResponse.fromJson(json);
      case API.chargingStationList:
        return ChargingStationListResponse.fromJson(json);
        case API.addWalletCredits:
        return WalletResponse.fromJson(json);
          case API.walletDetails:
        return WalletListResponse.fromJson(json);
      default:
        return json;
    }
  }

  /// 🌐 MAIN REQUEST
  Future<dynamic> apiRequest(
    BuildContext context,
    API api, {
    dynamic jsonval,
    String? path,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.request(
        apiEndPoint(api) + (path ?? ""),
        data: jsonval,
        queryParameters: queryParams,
        options: Options(
          method: apiHTTPMethod(api).name,
          validateStatus: (_) => true,
        ),
      );
    print('Response code: ${response.statusCode}');
      if (response.statusCode == 200) {
        return parseResponse(api, response.data);
      }

      if (response.statusCode == 400) {
        throw BadRequestError(_serverMessage(response.data));
      }

      if (response.statusCode == 401) {
        infoNormalDialog(
          context,
          message: response.data['message']??'',
        );
        throw UnauthorisedError("Unauthorized");
      }

      throw FetchDataError(_serverMessage(response.data));
    } on DioException catch (e) {
      throw FetchDataError(
        e.response != null
            ? _serverMessage(e.response?.data)
            : e.message ?? "Network error",
      );
    }
  }

  /// 🧹 LOGOUT CLEAR
  static Future<void> clearCookies() async {
    await cookieJar?.deleteAll();
    print("🍪 Cookies cleared");
  }

  String _serverMessage(dynamic data) {
    if (data is Map) {
      return data['message'] ??
          data['desc'] ??
          data['status_Message'] ??
          "Something went wrong";
    }
    return data?.toString() ?? "Something went wrong";
  }


}
