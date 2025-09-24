import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_design/src/widgets/setting/index.dart';

import '../../../l10n/intl/xd_localizations.dart';

///设置页面
class XDSettingPage extends StatelessWidget {
  const XDSettingPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(XDLocalizations.of(context).setting),
      ),
      body: ListView(
        children: ListTile.divideTiles(
            color: DividerTheme.of(context).color,
            context: context,
            tiles: [
              ListTile(
                title: Text(XDLocalizations.of(context).language),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return const XDLanguageSettingPage();
                  }));
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.read<XDLanguageController>().currentLocaleName),
                    const Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
              ListTile(
                title: Text(XDLocalizations.of(context).theme),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return const XDThemeSettingPage();
                  }));
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 20,height: 20,color: context.read<XDThemeController>().currentTheme?.primaryColor,),
                    const Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
            ]).toList(),
      ),
    );
  }
}
