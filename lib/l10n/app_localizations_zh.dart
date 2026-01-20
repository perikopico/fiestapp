// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'QuePlan';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get confirm => '确认';

  @override
  String get continueText => '继续';

  @override
  String get back => '返回';

  @override
  String get next => '下一步';

  @override
  String get done => '完成';

  @override
  String get search => '搜索';

  @override
  String get filter => '筛选';

  @override
  String get settings => '设置';

  @override
  String get profile => '个人资料';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get logout => '登出';

  @override
  String get createAccount => '创建账户';

  @override
  String get saveFavoritesCreateEvents => '保存您的收藏并创建活动';

  @override
  String get continueWithoutAccount => '不使用账户继续';

  @override
  String get signUp => '注册';

  @override
  String get signIn => '登录';

  @override
  String get allCategories => '全部';

  @override
  String get allCategoriesLabel => '所有类别';

  @override
  String get viewFeaturedEvents => '查看精选活动';

  @override
  String get enableLocationServices => '请在设置中启用位置服务以使用无线电模式。';

  @override
  String get locationPermissionsDisabled => '位置权限已禁用。请在设置中启用它们以使用无线电模式。';

  @override
  String get locationPermissionRequired => '需要位置权限才能使用无线电模式。';

  @override
  String errorLoadingData(String error) {
    return '加载数据错误：$error';
  }

  @override
  String get retry => '重试';

  @override
  String get errorConnection => '连接错误。请检查您的互联网连接。';

  @override
  String get errorPermissions => '需要权限才能继续。请在设置中检查权限。';

  @override
  String get errorAuthentication => '身份验证错误。请重新登录。';

  @override
  String get errorDatabase => '加载数据错误。请稍后再试。';

  @override
  String get errorUnknown => '发生意外错误。请重试。';

  @override
  String get mustAcceptTerms => '您必须接受条款和隐私政策才能继续';

  @override
  String get consentsSaved => '同意已成功保存';

  @override
  String errorSaving(String error) {
    return '保存错误：$error';
  }

  @override
  String get dataConsent => '数据同意';

  @override
  String get acceptTerms => '我接受条款和条件';

  @override
  String get readTerms => '阅读条款';

  @override
  String get acceptPrivacy => '我接受隐私政策';

  @override
  String get readPrivacy => '阅读隐私政策';

  @override
  String get location => '位置';

  @override
  String get notifications => '通知';

  @override
  String get profileAndFavorites => '个人资料和收藏';

  @override
  String get analytics => '分析';

  @override
  String get saveAndContinue => '保存并继续';

  @override
  String get acceptAll => '全部接受';

  @override
  String get aboutQuePlan => '关于QuePlan';

  @override
  String get contact => '联系方式';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsAndConditions => '条款和条件';

  @override
  String get manageConsents => '管理同意';

  @override
  String get modifyPrivacyPreferences => '修改您的隐私偏好';

  @override
  String get noEventsFound => '未找到活动';

  @override
  String get noEventsFoundDescription => '使用所选筛选器未找到活动';

  @override
  String get noSearchResults => '无结果';

  @override
  String get noSearchResultsDescription => '尝试调整您的搜索筛选器';
}
