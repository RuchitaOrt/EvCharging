class AppVersionResponse {
  bool? status;
  AppVersionData? data;

  AppVersionResponse({this.status, this.data});

  AppVersionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null
        ? AppVersionData.fromJson(json['data'])
        : null;
  }
}

class AppVersionData {
  String? latestVersionAndroid;
  String? latestVersionIos;
  bool? forceUpdate;
  String? message;
  String? androidStoreUrl;
  String? iosStoreUrl;

  AppVersionData({
    this.latestVersionAndroid,
    this.latestVersionIos,
    this.forceUpdate,
    this.message,
    this.androidStoreUrl,
    this.iosStoreUrl,
  });

  AppVersionData.fromJson(Map<String, dynamic> json) {
    latestVersionAndroid = json['latest_version_android'];
    latestVersionIos = json['latest_version_ios'];
    forceUpdate = json['force_update'];
    message = json['message'];
    androidStoreUrl = json['android_store_url'];
    iosStoreUrl = json['ios_store_url'];
  }
}