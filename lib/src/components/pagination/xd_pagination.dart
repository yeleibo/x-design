import 'package:flutter/material.dart';
import '../../../l10n/intl/xd_localizations.dart';
import '../../../xd_design.dart';
import 'hover_replace_widget.dart';

///分页器
class XDPagination extends StatefulWidget {

  ///当前页数
  final int initialPage;
  ///没有条数
  final int initialPageSize;

  ///指定每页可以显示多少条
  final List<int> pageSizeOptions;

  ///数据总数
  final int total;

  /// 切换页面回调
  final void Function(int pageNumber,int pageSize)? onChange;

  ///切换页码
  final void Function(int pageNumber)? onCurrentChange;

  ///切换每页显示条目
  final void Function(int pageSize)? onPageSizeChange;

  const XDPagination(
      {Key? key,
      this.initialPageSize = 10,

      this.initialPage=1,
      this.pageSizeOptions = const [10, 20, 50, 100],
      this.onChange,
      required this.total, this.onCurrentChange, this.onPageSizeChange,})
      : super(key: key);

  @override
  State<XDPagination> createState() => _XDPaginationState();
}

class _XDPaginationState extends State<XDPagination> {
  final int pageButtonSize=7;
  late int currentPageSize;
  late int current;

  @override
  void initState(){
    super.initState();
    currentPageSize = widget.initialPageSize;
    current = widget.initialPage;
  }


  @override
  Widget build(BuildContext context) {
    var totalPage = calculateTotalPage();
    return SingleChildScrollView(scrollDirection: Axis.horizontal,child:  Row(children: [

      Text('${XDLocalizations.of(context).total}：${widget.total}'),
      //上一页
      PageItem(
        selected: false,
        onTap: () {
          changePage(current-1);
        },
        disabled: current==1,
        child: Icon(Icons.navigate_before_outlined,color: current==1?Colors.grey.shade400:null,),
      ),
      //首页
      if(totalPage>pageButtonSize)
      PageItem(
          selected:  current==1,
          onTap: () {
            changePage(1);
          },
          child: const Text("1"),
        ),
      //上n页
      if(totalPage>pageButtonSize && current>3)
        HoverReplaceWidget(
          hoverChild: Icon(Icons.keyboard_double_arrow_left,
              color: Theme.of(context).primaryColor),
          onTap: () {
            changePage(current - 3);
          },
          width: 50,
          height: 50,
          child: Icon(
            Icons.more_horiz,
            color: Colors.grey.shade400,
          ),
        ),
      //中间的页面
      ...centerPageNum().map((e) => PageItem(

        selected:  current==e,
        onTap: () {
          changePage(e);
        },
        child: Text(e.toString()),
      )),
      //下n页
      if(totalPage>pageButtonSize && current<=totalPage-3)
        HoverReplaceWidget(
          hoverChild: Icon(
            Icons.keyboard_double_arrow_right,
            color: Theme.of(context).primaryColor,
          ),
          onTap: () {
            changePage(current + 3);
          },
          width: 50,
          height: 50,
          child: Icon(
            Icons.more_horiz,
            color: Colors.grey.shade400,
          ),
        ),
      //末页
      if(totalPage>pageButtonSize)
        PageItem(

          selected:  current==totalPage,
          onTap: () {
            changePage(totalPage);
          },
          child: Text(totalPage.toString()),
        ),
      //下一页
      PageItem(
        selected: false,
        onTap: () {
          changePage(current+1);
        },
        disabled: current==totalPage ,
        child: Icon(Icons.navigate_next_outlined,color: current==totalPage?Colors.grey.shade400:null,),
      ),
      SizedBox(
        width: 30,
      ),
      // SizedBox(
      //   width: 120,
      //   height: 45,
      //   child: XDDropDown<int>(
      //     showClearIcon: false,
      //     searchEnabled: false,
      //     items: widget.pageSizeOptions.map((e) => XDDropDownItem(label: '${e.toString()} ${XDLocalizations.of(context).pageNumber}', value: e)).toList(),
      //     initialValue: [currentPageSize],
      //     onChange: (v) {
      //       changePageSize(v!.first);
      //     },
      //   ),
      // ),
    ]),);
  }

  List<int> centerPageNum(){
    var totalPage = (widget.total / currentPageSize).ceil();
    if(totalPage<=pageButtonSize){
      return List.generate(totalPage, (index) => index+1);
    }else{
      if(current<=3){
        return [2,3,4,5];
      }else if(current>=totalPage-2){
        return [totalPage-4,totalPage-3,totalPage-2,totalPage-1];
      }else{
        return [current-1,current,current+1];
      }
    }
  }


  ///计算总共多少页
  int calculateTotalPage() {
    return (widget.total / currentPageSize).ceil();
  }

  void changePage(int toPageNum) {
    current = toPageNum;
    widget.onChange?.call(toPageNum,currentPageSize);
    widget.onCurrentChange?.call(toPageNum);
    setState(() {

    });
  }

  /// 改变每页显示多少条
  void changePageSize(int newSize) {
    currentPageSize = newSize;
    widget.onChange?.call(current ,newSize);
    widget.onPageSizeChange?.call(newSize);
    calculateTotalPage();

    recalculateCurrentPage(newSize);
    setState(() {

    });
  }


  void recalculateCurrentPage(int newSize) {
    // 重新计算总页数
    var newTotalPage = (widget.total / newSize).ceil();

    // 如果当前页码超过新的总页数，则将当前页码调整为新的总页数
    if (current > newTotalPage) {
      changePage(newTotalPage);
    }
  }
}



///具体页码
class PageItem extends StatelessWidget {
  final Widget child;
  final bool selected;
  final VoidCallback? onTap;
  final bool disabled;
  const PageItem(
      {Key? key,
      required this.child,
      required this.selected,
      this.onTap,
      this.disabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
  //  return   Padding(padding:  EdgeInsets.symmetric(horizontal: 10),child:Container(constraints:BoxConstraints(minWidth: 50,minHeight: 50),child: Button(block: true, onClick: onTap,child:child,),));
    return Container(
       margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 45,
        height: 45,
      child: OutlinedButton(

          onPressed:disabled?null: onTap,
          style: OutlinedButton.styleFrom(
              enabledMouseCursor: SystemMouseCursors.click,
              disabledMouseCursor: SystemMouseCursors.forbidden,
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              side: BorderSide(
                  color: selected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300),
              foregroundColor: selected ? null : Colors.black),
          child: child),
    );
  }
}
