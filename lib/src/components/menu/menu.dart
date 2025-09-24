import 'package:flutter/material.dart';

import 'menu_model.dart';

const double XDMenuDefaultWidth = 220;

///菜单
class XDMenu extends StatefulWidget {
  final List<XDMenuModel> menus;
  final int defaultMenuIndex;

  XDMenu({Key? key, required this.menus, this.defaultMenuIndex = 0})
      : super(key: key);
  @override
  State<XDMenu> createState() => _XDMenuState();
}

class _XDMenuState extends State<XDMenu> {
  final PageController pageController = PageController();

  late List<XDMenuModel> pages;
  @override
  void initState() {
    super.initState();
    XDMenuModel.initDepth(widget.menus);
    pages = XDMenuModel.getLeafs(widget.menus);
  }

  final GlobalKey<NavigatorState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    if (widget.menus.isEmpty) {
      return SizedBox();
    }
    return Row(children: [
      Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/menu_bg.png',
                  package: "x_design"), // 替换为你的图片路径
              fit: BoxFit.fill,
            ),
          ),
          child: Ink(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: _PageMenuWidget(
                menus: widget.menus,
                defaultMenuIndex: widget.defaultMenuIndex,
                onChange: (item) {
                  key.currentState?.popUntil((route) => route.isFirst);
                  //退到首页
                  pageController.jumpToPage(pages.indexWhere(
                      (element) => element.code == item.code));
                },
              ))),
      Expanded(
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: pages.isEmpty
                  ? SizedBox()
                  : Navigator(
                      key: key,
                      initialRoute: '/',
                      onGenerateRoute: (RouteSettings routeSettings) {
                        return MaterialPageRoute(
                            builder: (context) => PageView(
                                  controller: pageController,
                                  children: pages
                                      .map((e) => _KeepPage(
                                            child: e.content ??
                                                const SizedBox(),
                                          ))
                                      .toList(),
                                ));
                      },
                    )))
    ]);
  }

  @override
  void didUpdateWidget(covariant XDMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.menus != widget.menus) {
      XDMenuModel.initDepth(widget.menus);
      pages = XDMenuModel.getLeafs(widget.menus);
    }
  }
}

class _KeepPage extends StatefulWidget {
  final Widget child;
  const _KeepPage({Key? key, required this.child}) : super(key: key);

  @override
  State<_KeepPage> createState() => _KeepPageState();
}

class _KeepPageState extends State<_KeepPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

class _PageMenuWidget extends StatefulWidget {
  final List<XDMenuModel> menus;
  final int defaultMenuIndex;

  final Function(XDMenuModel item)? onChange;
  const _PageMenuWidget(
      {Key? key, required this.menus, this.defaultMenuIndex = 0, this.onChange})
      : super(key: key);

  @override
  State<_PageMenuWidget> createState() => _PageMenuWidgetState();
}

class _PageMenuWidgetState extends State<_PageMenuWidget> {
  late XDMenuModel selected;
  @override
  void initState() {
    super.initState();
    if (widget.menus.isNotEmpty) {
      selected = widget.menus[widget.defaultMenuIndex];
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = ScrollController();
    return Ink(
        // color: Color(0xff001529),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu_bg.png',
                package: "x_design"), // 替换为你的图片路径
            fit: BoxFit.cover,
          ),
        ),
        width: XDMenuDefaultWidth,
        height: MediaQuery.of(context).size.height,
        child: Scrollbar(
            controller: controller,
            thumbVisibility: false,
            trackVisibility: false,
            thickness: 1,
            child: ListView(
              controller: controller,
              children: widget.menus.map((e) => getMenuWidget(e)).toList(),
            )));
  }

  Widget getMenuWidget(XDMenuModel menuItem) {
    Widget child;
    if (menuItem.children != null && menuItem.children!.isNotEmpty) {
      child = _ExpandListTitle(
          isSelected: selected == menuItem,
          onSelected: menuItem.content != null
              ? () {
                  setState(() {
                    selected = menuItem;
                    widget.onChange?.call(selected);
                  });
                }
              : null,
          title: Padding(
              padding: EdgeInsets.only(left: 20 * menuItem.depth.toDouble()),
              child: Text(
                menuItem.name,
                style: TextStyle(color: Colors.white),
              )),
          children: menuItem.children!.map((e) => getMenuWidget(e)).toList());
    } else {
      var listTitle = Container(
        decoration: BoxDecoration(
            gradient: selected == menuItem
                ? LinearGradient(stops: [
                    0,
                    0.03,
                    0.03,
                    1
                  ], colors: [
                    Color(0xFF00EDFF),
                    Color(0xFF00EDFF),
                    Color(0x5600EDFF),
                    Color(0x5600EDFF),
                  ])
                : null),
        child: ListTile(
          // selectedColor: Colors.transparent,
          // hoverColor: Color(0xff1890ff).withOpacity(0.7),
          selected: selected.code == menuItem.code,
          title: Padding(
            padding: EdgeInsets.only(left: 20 * menuItem.depth.toDouble()),
            child: Text(menuItem.name),
          ),
          onTap: () {
            setState(() {
              selected = menuItem;
              widget.onChange?.call(selected);
            });
          },
        ),
      );
      child = listTitle;
    }

    return ListTileTheme(
        textColor: Colors.white,
        selectedTileColor: Color(0xff1890ff),
        selectedColor: Colors.white,
        child: child);
  }
}

class _ExpandListTitle extends StatefulWidget {
  final Widget title;
  final bool isSelected;
  final List<Widget> children;
  final Function()? onSelected;
  const _ExpandListTitle(
      {Key? key,
      required this.children,
      required this.title,
      this.onSelected,
      required this.isSelected})
      : super(key: key);

  @override
  State<_ExpandListTitle> createState() => _ExpandListTitleState();
}

class _ExpandListTitleState extends State<_ExpandListTitle> {
  var isExpand = false;

  @override
  Widget build(BuildContext context) {
    Widget listTitle = Container(
        decoration: BoxDecoration(
            gradient: widget.isSelected
                ? LinearGradient(stops: [
                    0,
                    0.03,
                    0.03,
                    1
                  ], colors: [
                    Color(0xFF00EDFF),
                    Color(0xFF00EDFF),
                    Color(0x5600EDFF),
                    Color(0x5600EDFF),
                  ])
                : null),
        child: ListTile(
          title: widget.title,
          onTap: widget.onSelected ??
              () {
                setState(() {
                  isExpand = !isExpand;
                });
              },
          trailing: GestureDetector(
            onTap: () {
              setState(() {
                isExpand = !isExpand;
              });
            },
            child: isExpand
                ? Icon(
                    Icons.expand_less_outlined,
                    color: Colors.white,
                  )
                : Icon(Icons.expand_more_outlined, color: Color(0xff85a2d4)),
          ),
        ));

    return Column(
      children: [listTitle, if (isExpand) ...widget.children],
    );
  }

}
