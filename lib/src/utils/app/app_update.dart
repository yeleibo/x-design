
///app的版本信息
class AppVersionInfo {
  //是否需要更新
  AppUpdateType appUpdateType;
  // /**更新路径*/
  String downUrl;
  // /**更新信息*/

  String updateMessage;
  // /**app新版本信息*/

  String newAppVersion;
  AppVersionInfo({required this.appUpdateType, required this.newAppVersion, this.updateMessage='',
      required this.downUrl});

  ///解析json转换成对象
  factory AppVersionInfo.fromJson(Map<String, dynamic> json) => AppVersionInfo(
    appUpdateType: AppUpdateType.values[json['appUpdateType']],
    newAppVersion: (json['newAppVersion'] as String?)?? (json['lastAppVersion'] as String),
    updateMessage:json['updateMessage'] as String,
    downUrl: json['downUrl'] as String,
  );


}

///app更新类型
enum AppUpdateType {
  //不需要更新
  unnecessaryUpdate,
  //不强制
  notForceUpdate,
  //强制更新
  forceUpdate,
}
