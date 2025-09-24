import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_controller.dart';

///主题设置页面
class XDThemeSettingPage extends StatelessWidget {
  const XDThemeSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Consumer<XDThemeController>(builder:
        (BuildContext context, XDThemeController controller, Widget? child) {
      return Scaffold(
      appBar: AppBar(
        title: const Text("主题颜色"),
      ),
      body: controller.supportedThemes?.isNotEmpty==true?ListView.separated(
          itemCount: controller.supportedThemes!.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, int index) {
            var e = controller.supportedThemes![index];
            var isSelected =
                controller.currentTheme?.primaryColor ==
                    e.primaryColor;
            return ListTile(
              leading: Container(
                margin: const EdgeInsets.all(5.0),
                width: 36.0,
                height: 36.0,
                color: e.primaryColor,
              ),
              onTap: () {
                controller.changeTheme(e);
              },
              trailing: isSelected
                  ? const Icon(Icons.done, color: Colors.blue)
                  : null,
            );
          }):const SizedBox());
      })
    ;
  }
}
