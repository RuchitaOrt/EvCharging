import 'dart:convert';
import 'dart:io';

import 'package:HyCharge/model/ForgetPasswordResponse.dart';
import 'package:HyCharge/model/estimate_charging_response.dart';
import 'package:HyCharge/model/resend_otp_response.dart';
import 'package:HyCharge/model/send_otp_response.dart';
import 'package:HyCharge/model/verify_otp_response.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:HyCharge/Utils/InternetConnection.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/model/ActiveSessionResponse.dart';
import 'package:HyCharge/model/AddReviewResponse.dart';
import 'package:HyCharge/model/ChargingGunStatusRefreshResponse.dart';
import 'package:HyCharge/model/ChargingGunStatusResponse.dart';
import 'package:HyCharge/model/ChargingHubReviewResponse.dart';
import 'package:HyCharge/model/ChargingHistorySessionResponse.dart';
import 'package:HyCharge/model/ChargingcomprehensiveHubResponse.dart';
import 'package:HyCharge/model/CreateOrderResponse.dart';
import 'package:HyCharge/model/DeleteAccountResponse.dart';
import 'package:HyCharge/model/DeleteReviewResponse.dart';
import 'package:HyCharge/model/DeleteVehicleResponse.dart';
import 'package:HyCharge/model/EndChargingSessionResponse.dart';
import 'package:HyCharge/model/RazorpayKeyResponse.dart';
import 'package:HyCharge/model/RefreshTokenResponse.dart';
import 'package:HyCharge/model/ResetPasswordResponse.dart';
import 'package:HyCharge/model/SessionDetailResponse.dart';
import 'package:HyCharge/model/StartChargingSessionResponse.dart';
import 'package:HyCharge/model/UnlockConnectorResponse.dart';
import 'package:HyCharge/model/VehicleListResponse.dart';
import 'package:HyCharge/model/WalletListResponse.dart';
import 'package:HyCharge/model/WalletResponse.dart';
import 'package:HyCharge/model/user_vehicle_model.dart';
import 'package:HyCharge/model/user_vehicle_update_response.dart';
import 'package:HyCharge/model/verify_payment_response.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import 'package:HyCharge/Utils/AppEror.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';

import 'package:HyCharge/model/LoginResponse.dart';
import 'package:HyCharge/model/RegistrationResponse.dart';
import 'package:HyCharge/model/LogoutResponse.dart';
import 'package:HyCharge/model/ProfileResponse.dart';
import 'package:HyCharge/model/ChargingHubResponse.dart';
import 'package:HyCharge/model/ChargingListResponse.dart';
import 'package:HyCharge/model/ChargingStationListResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  comprehensivelist,
  startChargingSession,
  endChargingSession,
  unlockConnector,
  //
  charginggunstatus,
  chargingsessiondetails,
  chargingsessions,
  chargingHubReviewList,
  chargingHubReviewAdd,
  charginghubreviewupdate,
  charginghubreviewdelete,
  resetPassword,
  deleteAccount,
  refreshToken,
  fileUpload,
  razorpayKey,
  createRazorpayOrder,
  verifyRazorpayPayment,
  sendOtp,
  verifyOtp,
  resendOtp,
  estimateCharging,
  forgetPassword
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
        // onRequest: (options, handler) async {
        //   // Log request details
        //   _logRequest(options);

        //   final cookies = await cookieJar?.loadForRequest(options.uri);
        //   print("🍪 Request cookies: $cookies");
        //   handler.next(options);
        // },
        onRequest: (options, handler) async {
          final hasInternet = await hasInternetConnection();

          if (!hasInternet) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                error: "No internet connection",
              ),
            );

            // Optional: show dialog / snackbar
            // infoNormalDialog(
            //   routeGlobalKey.currentContext!,
            //   message: "No internet connection. Please check your network.",
            // );
            FocusScope.of(routeGlobalKey.currentContext!).unfocus();
            showToast("No internet connection. Please check your network.");
            return;
          }

          _logRequest(options);
          handler.next(options);
        },

        onResponse: (response, handler) {
          // Log response details
          _logResponse(response);

          print("🍪 Set-Cookie: ${response.headers['set-cookie']}");
          handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            print("🔒 401 detected");

            // If refresh already failed → logout immediately
            if (_refreshFailed) {
              await clearCookies();
              unAthorizedTokenErrorDialog(
                routeGlobalKey.currentContext!,
                message: "Your Session has Expired. Please Login Again",
              );
              return handler.reject(e);
            }

            final refreshed = await _refreshToken();

            if (refreshed) {
              final requestOptions = e.requestOptions;

              try {
                final retryResponse = await dio.request(
                  requestOptions.path,
                  data: requestOptions.data,
                  queryParameters: requestOptions.queryParameters,
                  options: Options(
                    method: requestOptions.method,
                    headers: requestOptions.headers,
                  ),
                );

                return handler.resolve(retryResponse);
              } catch (_) {
                return handler.reject(e);
              }
            } else {
              // ❌ Refresh failed → logout
              await clearCookies();
              unAthorizedTokenErrorDialog(
                routeGlobalKey.currentContext!,
                message: "Your Session has Expired. Please Login Again",
              );
              return handler.reject(e);
            }
          }

          handler.next(e);
        },

        // onError: (DioException e, handler) async {
        //   print("Errorcode");
        //   print(e.response?.statusCode);
        //   if (e.response?.statusCode == 401) {
        //     print("🔒 401 detected, attempting refresh token");

        //     final refreshed = await _refreshToken();

        //     if (refreshed) {
        //       final requestOptions = e.requestOptions;

        //       try {
        //         final retryResponse = await dio.request(
        //           requestOptions.path,
        //           data: requestOptions.data,
        //           queryParameters: requestOptions.queryParameters,
        //           options: Options(
        //             method: requestOptions.method,
        //             headers: requestOptions.headers,
        //           ),
        //         );

        //         return handler.resolve(retryResponse);
        //       } catch (retryError) {
        //         return handler.reject(e);
        //       }
        //     } else {
        //       print("Statuscode ${refreshed}");
        //       print("Statuscode Coming Here");
        //       unAthorizedTokenErrorDialog(routeGlobalKey.currentContext!,
        //           message: "Your Session has Expired.Please Login Again");
        //     }

        //     // Refresh failed → force logout
        //     await clearCookies();
        //     unAthorizedTokenErrorDialog(routeGlobalKey.currentContext!,
        //         message: "Your Session has Expired.Please Login Again");
        //   }

        //   handler.next(e);
        // },

        // onError: (e, handler) {
        //   // Log error details
        //   _logError(e);
        //   print("❌ API ERROR: ${e.response?.statusCode}");
        //   handler.next(e);
        // },
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
        return "/Payment/add-credits";
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
      case API.charginggunstatus:
        return "/ChargingSession/charging-gun-status";
      case API.chargingsessiondetails:
        return "/ChargingSession/charging-session-details";
      case API.chargingsessions:
        return "/ChargingSession/charging-sessions";

      case API.chargingHubReviewList:
        return "/ChargingHub/charging-hub-review-list";
      case API.chargingHubReviewAdd:
        return "/ChargingHub/charging-stn-review-add";
      case API.charginghubreviewupdate:
        return "/ChargingHub/charging-hub-review-update";
      case API.charginghubreviewdelete:
        return "/ChargingHub/charging-hub-review-delete";
      case API.resetPassword:
        return "/User/reset-password";

      case API.deleteAccount:
        return "/User/user-delete";
      case API.refreshToken:
        return "/User/refresh-token";
      case API.fileUpload:
        return "/FileStorage/upload";
      case API.razorpayKey:
        return "/Payment/razorpay-key";
      case API.createRazorpayOrder:
        return "/Payment/create-order";
      case API.verifyRazorpayPayment:
        return "/Payment/verify-payment";
      case API.sendOtp:
        return "/User/send-otp";
      case API.verifyOtp:
        return "/User/verify-otp";
      case API.resendOtp:
        return "/User/resend-otp";
      case API.estimateCharging:
        return "/ChargingSession/estimate-charging";
      case API.forgetPassword:
        return "/User/forgot-password";
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
      case API.chargingsessiondetails:
      case API.chargingHubReviewList:
      case API.chargingsessions:
      case API.charginggunstatus:
      case API.razorpayKey:
        return HTTPMethod.GET;
      case API.profileUpdate:
      case API.userVehicleUpdate:
      case API.charginghubreviewupdate:
        return HTTPMethod.PUT;
      case API.profileDelete:
      case API.userVehicleDelete:
      case API.charginghubreviewdelete:
      case API.deleteAccount:
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
        return UnlockResponse.fromJson(json);
      case API.comprehensivelist:
        return ChargingcomprehensiveHubResponse.fromJson(json);
      case API.chargingsessiondetails:
        return SessionDetailResponse.fromJson(json);
      case API.chargingHubReviewList:
        return ChargingHubReviewResponse.fromJson(json);
      case API.charginggunstatus:
        return ChargingGunStatusResponse.fromJson(json);

      case API.chargingsessions:
        return ActiveSessionResponse.fromJson(json);
      case API.chargingHubReviewAdd:
      case API.charginghubreviewupdate:
        return AddReviewResponse.fromJson(json);
      case API.charginghubreviewdelete:
        return DeleteReviewResponse.fromJson(json);
      case API.resetPassword:
        return ResetPasswordResponse.fromJson(json);
      case API.forgetPassword:
        return ForgetPasswordResponse.fromJson(json);

      case API.deleteAccount:
        return DeleteAccountResponse.fromJson(json);
      case API.refreshToken:
        return RefreshTokenResponse.fromJson(json);
      case API.razorpayKey:
        return RazorpayKeyResponse.fromJson(json);
      case API.createRazorpayOrder:
        return CreateOrderResponse.fromJson(json);
      case API.verifyRazorpayPayment:
        return VerifyPaymentResponse.fromJson(json);

      case API.sendOtp:
        return SendOtpResponse.fromJson(json);
      case API.verifyOtp:
        return VerifyOtpResponse.fromJson(json);

      case API.resendOtp:
        return ResendOtpResponse.fromJson(json);
      case API.estimateCharging:
        return EstimateChargingResponse.fromJson(json);

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
          // validateStatus: (_) => true,
        ),
      );
      print('Response code: ${response.statusCode}');
       print('Response code: ${response}');
      if (response.statusCode == 200) {
        return parseResponse(api, response.data);
      }

      if (response.statusCode == 400) {
        throw BadRequestError(_serverMessage(response.data));
      }
// if (response.statusCode == 401) {
//   throw UnauthorisedError("Unauthorized");
// }

      // if (response.statusCode == 401) {
      //   print("response.statusCode ${response.statusCode}");
      //   // infoNormalDialog(
      //   //   context,
      //   //   message: response.data['message'] ?? '',
      //   // );
      //    print("🔒 401 detected, attempting token");
      //   unAthorizedTokenErrorDialog(context,
      //       message: "Your Session has Expired.Please Login Again");
      //   throw UnauthorisedError("Unauthorized");
      // }

      throw FetchDataError(_serverMessage(response.data));
    } on DioException catch (e) {
      print(e.error.toString());
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

  bool _isRefreshingToken = false;
  bool _refreshFailed = false;
  Future<bool> _refreshToken() async {
    if (_isRefreshingToken || _refreshFailed) {
      return false;
    }

    _isRefreshingToken = true;

    try {
      final response = await dio.post(
        apiEndPoint(API.refreshToken),
      );

      if (response.statusCode == 200) {
        final refreshResponse = RefreshTokenResponse.fromJson(response.data);

        if (refreshResponse.success == true && refreshResponse.user != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            "userId",
            refreshResponse.user!.recId!,
          );

          print("🔁 Token refreshed successfully");
          _isRefreshingToken = false;
          return true;
        } else {
          // ❌ Refresh token invalid
          print("❌ Refresh token failed: ${refreshResponse.message}");
          _refreshFailed = true;
        }
      }
    } catch (e) {
      print("❌ Refresh token exception: $e");
      _refreshFailed = true;
    }

    _isRefreshingToken = false;
    return false;
  }

  // Future<bool> _refreshToken() async {
  //   try {
  //     final response = await dio.post(
  //       apiEndPoint(API.refreshToken),
  //       // options: Options(validateStatus: (_) => true),
  //     );

  //     if (response.statusCode == 200) {
  //       final refreshResponse = RefreshTokenResponse.fromJson(response.data);

  //       // Cookies are already updated automatically by CookieManager
  //       print("🔁 Token refreshed successfully");
  //       if (refreshResponse.success == false) {
  //         unAthorizedTokenErrorDialog(routeGlobalKey.currentContext!,
  //             message: "Your Session has Expired.Please Login Again");
  //       } else {
  //         final prefs = await SharedPreferences.getInstance();
  //         await prefs.setString("userId", refreshResponse!.user!.recId!);
  //       }
  //       return true;
  //     } else {
  //        unAthorizedTokenErrorDialog(routeGlobalKey.currentContext!,
  //             message: "Your Session has Expired.Please Login Again");
  //     }
  //   } catch (e) {
  //     print("❌ Refresh token failed: $e");
  //   }
  //   return false;
  // }
}
