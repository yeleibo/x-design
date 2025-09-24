import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:x_design/src/components/setting/language/language_controller.dart';

import '../../../../l10n/intl/xd_localizations.dart';

///语言设置页面
///需要在app之前使用Provider((_)=>Language())
class XDLanguageSettingPage extends StatelessWidget {
  const XDLanguageSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<XDLanguageController>(
      builder: (BuildContext context, XDLanguageController languageController,
          Widget? child) {
        return Scaffold(
            appBar: AppBar(
              title: Text(XDLocalizations.of(context).language),
            ),
            body: ListView.separated(
                itemCount: languageController.supportedLocales.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, int index) {
                  var e = languageController.supportedLocales[index];
                  if(languageController.currentLocale?.languageCode==e.languageCode){
                     if(languageController.currentLocale?.countryCode !=null ){}
                  }
                  var isSelected = (languageController.currentLocale?.languageCode == e.languageCode) &&
                      (languageController.currentLocale?.countryCode == e.countryCode);
                  return ListTile(
                    title: Text(
                        XDLanguageController.languageString(e),
                      style: TextStyle(
                          color: isSelected ? Colors.blueAccent : null),
                    ),
                    onTap: () {
                      languageController.changeLanguage(e);
                    },
                    trailing: isSelected
                        ? const Icon(Icons.done, color: Colors.blue)
                        : null,
                  );
                }));
      },
    );
  }
}
