import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:ev_charging_app/model/ChargingcomprehensiveHubResponse.dart';
import 'package:ev_charging_app/model/DeleteVehicleResponse.dart';
import 'package:ev_charging_app/model/EndChargingSessionResponse.dart';
import 'package:ev_charging_app/model/StartChargingSessionResponse.dart';
import 'package:ev_charging_app/model/UnlockConnectorResponse.dart';
import 'package:ev_charging_app/model/VehicleListResponse.dart';
import 'package:ev_charging_app/model/WalletListResponse.dart';
import 'package:ev_charging_app/model/WalletResponse.dart';
import 'package:ev_charging_app/model/user_vehicle_model.dart';
import 'package:ev_charging_app/model/user_vehicle_update_response.dart';
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
  userVehicleList,
  userVehicleAdd,
  carManufacturerList,
  evModelList,
  batteryCapacityList,
  batteryTypeList,
  chargerTypeList,
  userVehicleDelete,
  userVehicleUpdate,
  startChargingSession,
  endChargingSession,
  unlockConnector,
  comprehensivelist
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
          // Log request details
          _logRequest(options);

          final cookies = await cookieJar?.loadForRequest(options.uri);
          print("🍪 Request cookies: $cookies");
          handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response details
          _logResponse(response);

          print("🍪 Set-Cookie: ${response.headers['set-cookie']}");
          handler.next(response);
        },
        onError: (e, handler) {
          // Log error details
          _logError(e);
          print("❌ API ERROR: ${e.response?.statusCode}");
          handler.next(e);
        },
      ),
    );
  }

  /// 📝 REQUEST LOGGER
  void _logRequest(RequestOptions options) {
    print('\n' + '=' * 60);
    print('📤 API REQUEST');
    print('=' * 60);
    print('🌐 Method: ${options.method}');
    print('🔗 URL: ${options.baseUrl}${options.path}');
    print('🆔 API Endpoint: ${_getApiNameFromUrl(options.path)}');

    // Log headers (excluding sensitive info)
    if (options.headers.isNotEmpty) {
      print('📋 Headers:');
      final safeHeaders = Map<String, dynamic>.from(options.headers);
      // Remove or mask sensitive headers
      if (safeHeaders.containsKey('authorization')) {
        safeHeaders['authorization'] = 'Bearer ********';
      }
      safeHeaders.forEach((key, value) {
        print('  $key: $value');
      });
    }

    // Log query parameters
    if (options.queryParameters.isNotEmpty) {
      print('🔍 Query Parameters:');
      options.queryParameters.forEach((key, value) {
        print('  $key: $value');
      });
    }

    // Log request body
    if (options.data != null) {
      print('📦 Request Body:');
      if (options.data is Map) {
        final data = options.data as Map;
        // Mask sensitive fields
        final safeData = _maskSensitiveData(data);
        final prettyJson = JsonEncoder.withIndent('  ').convert(safeData);
        print(prettyJson);
      } else if (options.data is String) {
        try {
          final jsonData = jsonDecode(options.data as String);
          final safeData = _maskSensitiveData(jsonData);
          final prettyJson = JsonEncoder.withIndent('  ').convert(safeData);
          print(prettyJson);
        } catch (e) {
          print('  ${options.data}');
        }
      } else {
        print('  ${options.data}');
      }
    }

    print('=' * 60 + '\n');
  }

  /// 📝 RESPONSE LOGGER
  void _logResponse(Response response) {
    print('\n' + '=' * 60);
    print('📥 API RESPONSE');
    print('=' * 60);
    print('✅ Status Code: ${response.statusCode}');
    print(
        '🔗 URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}');
    print(
        '🆔 API Endpoint: ${_getApiNameFromUrl(response.requestOptions.path)}');

    // Log response headers
    if (response.headers.map.isNotEmpty) {
      print('📋 Response Headers:');
      response.headers.forEach((key, values) {
        print('  $key: $values');
      });
    }

    // Log response data
    if (response.data != null) {
      print('📦 Response Body:');
      try {
        if (response.data is Map) {
          final prettyJson =
              JsonEncoder.withIndent('  ').convert(response.data);
          print(prettyJson);
        } else if (response.data is String) {
          final jsonData = jsonDecode(response.data as String);
          final prettyJson = JsonEncoder.withIndent('  ').convert(jsonData);
          print(prettyJson);
        } else {
          print('  ${response.data}');
        }
      } catch (e) {
        print('  ${response.data}');
      }
    }

    // Log response time if available
    if (response.requestOptions.receiveTimeout != null) {
      print('⏱️ Receive Timeout: ${response.requestOptions.receiveTimeout}');
    }

    print('=' * 60 + '\n');
  }

  /// 📝 ERROR LOGGER
  void _logError(DioException error) {
    print('\n' + '=' * 60);
    print('❌ API ERROR');
    print('=' * 60);
    print(
        '🔗 URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}');
    print('🆔 API Endpoint: ${_getApiNameFromUrl(error.requestOptions.path)}');
    print('📤 Method: ${error.requestOptions.method}');
    print('⚠️ Error Type: ${error.type}');
    print('📊 Status Code: ${error.response?.statusCode}');

    // Log error message
    if (error.message != null) {
      print('💬 Error Message: ${error.message}');
    }

    // Log response data if available
    if (error.response?.data != null) {
      print('📦 Error Response:');
      try {
        if (error.response!.data is Map) {
          final prettyJson =
              JsonEncoder.withIndent('  ').convert(error.response!.data);
          print(prettyJson);
        } else if (error.response!.data is String) {
          final jsonData = jsonDecode(error.response!.data as String);
          final prettyJson = JsonEncoder.withIndent('  ').convert(jsonData);
          print(prettyJson);
        } else {
          print('  ${error.response!.data}');
        }
      } catch (e) {
        print('  ${error.response!.data}');
      }
    }

    // Log stack trace for debugging
    if (error.stackTrace != null) {
      print('🔍 Stack Trace:');
      print(error.stackTrace.toString());
    }

    print('=' * 60 + '\n');
  }

  /// 🎭 MASK SENSITIVE DATA
  /// 🎭 MASK SENSITIVE DATA
  Map<String, dynamic> _maskSensitiveData(dynamic data) {
    if (data is! Map) return {};

    final Map<String, dynamic> safeData = {};

    // Convert all keys to String
    for (var entry in data.entries) {
      final key = entry.key.toString();
      var value = entry.value;

      // Mask sensitive fields
      if (_isSensitiveField(key)) {
        safeData[key] = '********';
        continue;
      }

      // Handle nested maps
      if (value is Map) {
        safeData[key] = _maskSensitiveData(value);
      }
      // Handle lists
      else if (value is List) {
        final List<dynamic> safeList = [];
        for (var item in value) {
          if (item is Map) {
            safeList.add(_maskSensitiveData(item));
          } else {
            safeList.add(item);
          }
        }
        safeData[key] = safeList;
      }
      // Handle other types
      else {
        safeData[key] = value;
      }
    }

    return safeData;
  }

  /// 🔐 CHECK IF FIELD IS SENSITIVE
  bool _isSensitiveField(String fieldName) {
    final sensitiveFields = [
      'password',
      'token',
      'access_token',
      'refresh_token',
      'authorization',
      'credit_card',
      'cvv',
      'pin',
      'secret',
      'private_key',
      'otp',
      'social_security',
      'ssn',
      'bank_account',
      'api_key'
    ];

    return sensitiveFields.contains(fieldName.toLowerCase());
  }

  /// 🔍 GET API NAME FROM URL
  String _getApiNameFromUrl(String path) {
    for (var api in API.values) {
      if (apiEndPoint(api) == path) {
        return api.toString().split('.').last;
      }
    }
    return 'Unknown API';
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
      case API.addWalletCredits:
        return "/User/add-wallet-credits";
      case API.profileDelete:
        return "/User/profile-delete";
      case API.walletDetails:
        return "/User/wallet-details";
      case API.carManufacturerList:
        return "/HardwareMaster/car-manufacturer-list";
      case API.evModelList:
        return "/HardwareMaster/ev-model-list";
      case API.batteryCapacityList:
        return "/HardwareMaster/battery-capacity-list";
      case API.batteryTypeList:
        return "/HardwareMaster/battery-type-list";
      case API.chargerTypeList:
        return "/HardwareMaster/charger-type-list";

      case API.userVehicleList:
        return "/User/user-vehicle-list";
      case API.userVehicleAdd:
        return "/User/user-vehicle-add";
      case API.userVehicleDelete:
        return "/User/user-vehicle-delete";
      case API.userVehicleUpdate:
        return "/User/user-vehicle-update";
      case API.startChargingSession:
        return "/ChargingSession/start-charging-session";

      case API.endChargingSession:
        return "/ChargingSession/end-charging-session";

      case API.unlockConnector:
        return "/ChargingSession/unlock-connector";
         case API.comprehensivelist:
        return "/ChargingHub/comprehensive-list";
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
      case API.userVehicleList:
      case API.carManufacturerList:
      case API.batteryCapacityList:
      case API.batteryTypeList:
      case API.chargerTypeList:
      case API.evModelList:
        return HTTPMethod.GET;
      case API.profileUpdate:
      case API.userVehicleUpdate:
        return HTTPMethod.PUT;
      case API.profileDelete:
      case API.userVehicleDelete:
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
      case API.userVehicleList:
        return VehicleListResponse.fromJson(json);
      case API.userVehicleAdd:
        return UserVehicleResponse.fromJson(json);
      case API.userVehicleDelete:
        return DeleteVehicleResponse.fromJson(json);
      case API.userVehicleUpdate:
        return UserVehicleUpdateResponse.fromJson(json);
      case API.startChargingSession:
        return StartChargingSessionResponse.fromJson(json);
      case API.endChargingSession:
        return EndChargingSessionResponse.fromJson(json);
      case API.unlockConnector:
        return UnlockConnectorResponse.fromJson(json);
 case API.comprehensivelist:
        return ChargingcomprehensiveHubResponse.fromJson(json);
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
        print("response.statusCode ${response.statusCode}");
        // infoNormalDialog(
        //   context,
        //   message: response.data['message'] ?? '',
        // );
        unAthorizedTokenErrorDialog(context,
            message: "Your Session has Expired.Please Login Again");
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
