import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../xd_design.dart';
import '../widgets/message/message.dart';
import '../widgets/update_dialog/update_dialog.dart';

class ApplicationUtil {
  ///检查软件更新
  ///getLastAppVersion获取最新应用版本的信息
  ///forceShow是否强制展示弹窗
  static Future<void> checkAppUpdateOfMobile(
      {required FutureOr<AppVersionInfo> Function() getLastAppVersion,
      bool forceShowDialog = false}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      var lastAppVersion = await getLastAppVersion();
      if (lastAppVersion.appUpdateType == AppUpdateType.unnecessaryUpdate) {
        if (forceShowDialog) {
          message.info(content: XDLocalizations.of(xdContext).noNewVersion);
        }
        return;
      } else {
        if (lastAppVersion.appUpdateType == AppUpdateType.notForceUpdate &&
            !forceShowDialog) {
          var ignoreUpdateAppVersion =
              dataCacheService.getDataByDataName('ignoreUpdateAppVersion');
          if (ignoreUpdateAppVersion == lastAppVersion.newAppVersion &&
              !forceShowDialog) {
            return;
          }
        }
        late OverlayEntry updateOverlay;

        if (Platform.isIOS) {
          updateOverlay = OverlayEntry(
              builder: (context) => UpdateWidget(
                    progress: -1,
                    themeColor: Theme.of(context).primaryColor,
                    title:
                        "${XDLocalizations.of(xdContext).appUpdateAsk}：${lastAppVersion.newAppVersion}",
                    updateContent: lastAppVersion.updateMessage,
                    isForce: lastAppVersion.appUpdateType ==
                        AppUpdateType.forceUpdate,
                    ignoreButtonText:
                        XDLocalizations.of(xdContext).ignoreThisVersion,
                    enableIgnore: lastAppVersion.appUpdateType ==
                        AppUpdateType.notForceUpdate,
                    onIgnore: lastAppVersion.appUpdateType ==
                            AppUpdateType.notForceUpdate
                        ? () {
                            updateOverlay.remove();
                            dataCacheService.saveData('ignoreUpdateAppVersion',
                                lastAppVersion.newAppVersion);
                          }
                        : null,
                    updateButtonText: XDLocalizations.of(xdContext).update,
                    onUpdate: () {
                      launchUrl(Uri.parse(lastAppVersion.downUrl));
                    },
                    onClose: () {
                      updateOverlay.remove();
                    },
                  ));
        } else {
          updateOverlay = OverlayEntry(
            builder: (context) => _UpgradeOverlay(
              updateOverlay: updateOverlay,
              versionInfo: lastAppVersion,
              cache: dataCacheService,
              themeColor: Theme.of(context).primaryColor,
            ),
          );
          // updateOverlay=OverlayEntry(
          //     builder: (context) =>  StreamBuilder<DownloadInfo>(stream: RUpgrade.stream, builder: (context,downloadInfo){
          //       if(downloadInfo.data?.id!=null){
          //         dataCacheService.saveData(newVersionUpgradeIdCacheString,downloadInfo.data!.id!);
          //       }
          //       return UpdateWidget(
          //         progress: downloadInfo.data?.percent!=null?downloadInfo.data!.percent!/100:-1,
          //         themeColor: Theme.of(context).primaryColor,
          //         title: "${XDLocalizations.of(xdContext).appUpdateAsk}:${lastAppVersion.newAppVersion}",
          //         updateContent:lastAppVersion.updateMessage,
          //         isForce:lastAppVersion.appUpdateType ==
          //             AppUpdateType.forceUpdate,
          //         ignoreButtonText: XDLocalizations.of(xdContext).ignoreThisVersion,
          //         enableIgnore:lastAppVersion.appUpdateType ==
          //             AppUpdateType.notForceUpdate,
          //         onIgnore:lastAppVersion.appUpdateType ==
          //             AppUpdateType.notForceUpdate
          //             ? () {
          //           updateOverlay.remove();
          //           dataCacheService.saveData(
          //               'ignoreUpdateAppVersion', lastAppVersion.newAppVersion);
          //         }
          //             : null,
          //         updateButtonText:  XDLocalizations.of(xdContext).update,
          //         onManualUpdate: (){
          //           launchUrl(Uri.parse(lastAppVersion.downUrl));
          //         },
          //         onUpdate: ()  async {
          //           void upgradeError(err){
          //             dataCacheService.deleteDataByDataName(newVersionUpgradeIdCacheString);
          //             launchUrl(Uri.parse(lastAppVersion.downUrl));
          //           }
          //           var newVersionUpgradeId=dataCacheService.getDataByDataName(newVersionUpgradeIdCacheString);
          //           if(newVersionUpgradeId==null){
          //             RUpgrade.upgrade(notificationVisibility:NotificationVisibility.VISIBILITY_HIDDEN,lastAppVersion.downUrl,fileName: lastAppVersion.downUrl.getFileName()).catchError(upgradeError);
          //           }else{
          //             RUpgrade.upgradeWithId(newVersionUpgradeId).catchError(upgradeError);
          //           }
          //
          //
          //
          //         },onClose: (){
          //         updateOverlay.remove();
          //       },);
          //     }));
        }
        xdNavigatorKey.currentState!.overlay!.insert(updateOverlay);
      }
    }
  }
}

class _UpgradeOverlay extends StatefulWidget {
  const _UpgradeOverlay({
    required this.updateOverlay,
    required this.versionInfo,
    required this.cache,
    required this.themeColor,
  });

  final OverlayEntry? updateOverlay;
  final AppVersionInfo versionInfo;
  final DataCacheService cache;
  final Color themeColor;

  @override
  State<_UpgradeOverlay> createState() => _UpgradeOverlayState();
}

class _UpgradeOverlayState extends State<_UpgradeOverlay> {
  late final StreamSubscription<DownloadInfo> _sub;
  double _progress = -1.0;

  @override
  void initState() {
    super.initState();
    _sub = RUpgrade.stream.listen((info) {
      if (info.id != null) {
        widget.cache.saveData(widget.versionInfo.newAppVersion, info.id!);
      }
      if (info.percent == null) {
        return;
      }
      final p = info.percent! < 0 ? -1.0 : (info.percent! / 100);
      if (p != _progress) setState(() => _progress = p);
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.versionInfo;
    final isForce = v.appUpdateType == AppUpdateType.forceUpdate;

    return UpdateWidget(
      themeColor: widget.themeColor,
      title: "${XDLocalizations.of(context).appUpdateAsk}: ${v.newAppVersion}",
      updateContent: v.updateMessage,
      isForce: false,
      enableIgnore: !isForce,
      ignoreButtonText: XDLocalizations.of(context).ignoreThisVersion,
      onIgnore: !isForce
          ? () {
              widget.updateOverlay?.remove();
              widget.cache.saveData('ignoreUpdateAppVersion', v.newAppVersion);
            }
          : null,
      updateButtonText: XDLocalizations.of(context).update,
      onManualUpdate: () => launchUrl(Uri.parse(v.downUrl)),
      onUpdate: _startUpgrade,
      onClose: () {
        widget.updateOverlay?.remove();
      },
      // progress: _progress,
    );
  }

  void _startUpgrade() {
    // 与方案A相同的升级逻辑 ...
    void upgradeError(err) {
      dataCacheService.deleteDataByDataName(widget.versionInfo.newAppVersion);
      launchUrl(Uri.parse(widget.versionInfo.downUrl));
    }

    var newVersionUpgradeId =
        dataCacheService.getDataByDataName(widget.versionInfo.newAppVersion);
    if (newVersionUpgradeId == null) {
      widget.updateOverlay?.remove();
      message.info(content: '后台更新中，请稍等...');
      RUpgrade.upgrade(
              notificationVisibility: NotificationVisibility.VISIBILITY_HIDDEN,
              widget.versionInfo.downUrl,
              fileName: widget.versionInfo.downUrl.getFileName())
          .catchError(upgradeError);
    } else {
      RUpgrade.upgradeWithId(newVersionUpgradeId).catchError(upgradeError);
    }
  }
}
