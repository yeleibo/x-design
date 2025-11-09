import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'xd_localizations_en.dart';
import 'xd_localizations_id.dart';
import 'xd_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of XDLocalizations
/// returned by `XDLocalizations.of(context)`.
///
/// Applications need to include `XDLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'intl/xd_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: XDLocalizations.localizationsDelegates,
///   supportedLocales: XDLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the XDLocalizations.supportedLocales
/// property.
abstract class XDLocalizations {
  XDLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static XDLocalizations of(BuildContext context) {
    return Localizations.of<XDLocalizations>(context, XDLocalizations)!;
  }

  static const LocalizationsDelegate<XDLocalizations> delegate =
      _XDLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// 查询
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// 重置
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// 登录
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// 请输入密码
  ///
  /// In en, this message translates to:
  /// **'please enter password'**
  String get pleaseEnterPassword;

  /// 请输入用户名
  ///
  /// In en, this message translates to:
  /// **'please enter user name'**
  String get pleaseEnterUserName;

  /// 请输入
  ///
  /// In en, this message translates to:
  /// **'Please Enter'**
  String get pleaseEnter;

  /// 推荐使用
  ///
  /// In en, this message translates to:
  /// **'It is recommended to use '**
  String get suggestBrowserTip1;

  /// 新版 Microsoft Edge 浏览器
  ///
  /// In en, this message translates to:
  /// **' latest Microsoft Edge '**
  String get suggestBrowserTip2;

  /// 访问本系统
  ///
  /// In en, this message translates to:
  /// **' to access this system '**
  String get suggestBrowserTip3;

  /// 撤销
  ///
  /// In en, this message translates to:
  /// **'undo'**
  String get undo;

  /// 取消
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// 确定
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// 已选
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @clearList.
  ///
  /// In en, this message translates to:
  /// **'Clear List'**
  String get clearList;

  /// 合计
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// 定位
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// 获取失败
  ///
  /// In en, this message translates to:
  /// **'Get Failed'**
  String get getFailed;

  /// 网络错误
  ///
  /// In en, this message translates to:
  /// **'Network Error'**
  String get networkError;

  /// 上传
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// 旋转90度
  ///
  /// In en, this message translates to:
  /// **'Rotate 90 degrees'**
  String get rotate;

  /// 重命名
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// 重命名
  ///
  /// In en, this message translates to:
  /// **'Please enter a new name'**
  String get pleaseEnterANewName;

  /// 输入不能为空
  ///
  /// In en, this message translates to:
  /// **'Input cannot be empty'**
  String get inputCannotBeEmpty;

  /// 放大
  ///
  /// In en, this message translates to:
  /// **'ZoomIn'**
  String get zoomIn;

  /// 缩小
  ///
  /// In en, this message translates to:
  /// **'ZoomOut'**
  String get zoomOut;

  /// 详情
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// 没有新版本
  ///
  /// In en, this message translates to:
  /// **'no new version'**
  String get noNewVersion;

  /// 忽略这个版本
  ///
  /// In en, this message translates to:
  /// **'ignore this version'**
  String get ignoreThisVersion;

  /// 更新
  ///
  /// In en, this message translates to:
  /// **'update'**
  String get update;

  /// 检查到新版本
  ///
  /// In en, this message translates to:
  /// **'Check a new version'**
  String get appUpdateAsk;

  /// 我的位置
  ///
  /// In en, this message translates to:
  /// **'my position'**
  String get myPosition;

  /// mapCenter
  ///
  /// In en, this message translates to:
  /// **'mapCenter'**
  String get mapCenter;

  /// 请先输入查询关键字
  ///
  /// In en, this message translates to:
  /// **'Please enter the query keyword first'**
  String get pleaseEnterTheQueryKeywordFirst;

  /// 关键字
  ///
  /// In en, this message translates to:
  /// **'keyword'**
  String get keyword;

  /// 语言
  ///
  /// In en, this message translates to:
  /// **'language'**
  String get language;

  /// 主题
  ///
  /// In en, this message translates to:
  /// **'theme'**
  String get theme;

  /// 设置
  ///
  /// In en, this message translates to:
  /// **'setting'**
  String get setting;

  /// 请先安装地图软件
  ///
  /// In en, this message translates to:
  /// **'please install map app'**
  String get installMapApp;

  /// 图层
  ///
  /// In en, this message translates to:
  /// **'layers'**
  String get layers;

  /// No description provided for @releaseToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Release to refresh'**
  String get releaseToRefresh;

  /// No description provided for @startRefreshing.
  ///
  /// In en, this message translates to:
  /// **'Start refreshing'**
  String get startRefreshing;

  /// No description provided for @refreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing'**
  String get refreshing;

  /// 正在加载中
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @refreshSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Refresh successful'**
  String get refreshSuccessful;

  /// 加载完成
  ///
  /// In en, this message translates to:
  /// **'Loading completed'**
  String get loadingCompleted;

  /// No description provided for @refreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Refresh failed'**
  String get refreshFailed;

  /// No description provided for @noMore.
  ///
  /// In en, this message translates to:
  /// **'No More'**
  String get noMore;

  /// 页数
  ///
  /// In en, this message translates to:
  /// **'/page'**
  String get pageNumber;

  /// 请开启定位服务
  ///
  /// In en, this message translates to:
  /// **'Please open location service'**
  String get pleaseOpenLocationService;
}

class _XDLocalizationsDelegate extends LocalizationsDelegate<XDLocalizations> {
  const _XDLocalizationsDelegate();

  @override
  Future<XDLocalizations> load(Locale locale) {
    return SynchronousFuture<XDLocalizations>(lookupXDLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_XDLocalizationsDelegate old) => false;
}

XDLocalizations lookupXDLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return XDLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return XDLocalizationsEn();
    case 'id':
      return XDLocalizationsId();
    case 'zh':
      return XDLocalizationsZh();
  }

  throw FlutterError(
    'XDLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
