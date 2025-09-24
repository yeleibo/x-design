import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
///参照自[Tooltip],[XDTooltip2],如果只是简单的文字提示可以直接使用Tooltip，如果提示需要是复杂的组件则可以使用改组件
class XDTooltip extends StatefulWidget {
  final Widget child;
  /// 提示的组件
  final Widget tip;

  ///child的锚点，与tipAnchor一起用来定位用的
  final Alignment childAnchor;
  ///提示的锚点，与childAnchor一起用来定位用的
  final Alignment tipAnchor;
  /// 偏移
  final Offset offset;
  /// 鼠标悬停多久显示提示框
  final Duration waitDuration;
  /// 鼠标移除后提示显示的时间
  final Duration showDuration;
  /// 触发的模式
  final TooltipTriggerMode? triggerMode;
  const XDTooltip(
      {super.key,
        this.offset=Offset.zero,
        this.waitDuration=const Duration(seconds: 0),
        this.showDuration=const Duration(milliseconds: 500),
        this.triggerMode,
        this.childAnchor=Alignment.bottomCenter,
        this.tipAnchor=Alignment.topCenter,
        required this.child,
        required this.tip});
  @override
  State<XDTooltip> createState() => _XDTooltipState();
}

class _XDTooltipState extends State<XDTooltip> {

  final OverlayPortalController _overlayController = OverlayPortalController();

  final layerLink = LayerLink();
  // The ids of mouse devices that are keeping the tooltip from being dismissed.
  //
  // Device ids are added to this set in _handleMouseEnter, and removed in
  // _handleMouseExit. The set is cleared in _handleTapToDismiss, typically when
  // a PointerDown event interacts with some other UI component.
  final Set<int> _activeHoveringPointerDevices = <int>{};
  void _handleMouseEnter(PointerEnterEvent event) {
    // _handleMouseEnter is only called when the mouse starts to hover over this
    // tooltip (including the actual tooltip it shows on the overlay), and this
    // tooltip is the first to be hit in the widget tree's hit testing order.
    // See also _ExclusiveMouseRegion for the exact behavior.
    _activeHoveringPointerDevices.add(event.device);
    _timer?.cancel();
    _timer=Timer(widget.waitDuration, () {
      _overlayController.show();
    });

  }

  Timer? _timer;
  void _handleMouseExit(PointerExitEvent event) {
    if (_activeHoveringPointerDevices.isEmpty) {
      return;
    }
    _activeHoveringPointerDevices.remove(event.device);
    if (_activeHoveringPointerDevices.isEmpty) {
      _timer?.cancel();
      _timer=Timer(widget.showDuration, () {
        _overlayController.hide();
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder:(context)=> _TooltipOverlay(
        onEnter: _handleMouseEnter,
        onExit: _handleMouseExit,
        childAnchor:widget.childAnchor, tipAnchor: widget.tipAnchor, offset: widget.offset ,link: layerLink,
        child: widget.tip,

      ),
      child:  _ExclusiveMouseRegion(
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
    child:  CompositedTransformTarget(
        link: layerLink,
        child: widget.child,
      ),
    ));
  }
}



class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    required this.child,

    required this.childAnchor,
    required this.tipAnchor,
    required this.offset,
    required this.link,
    this.onEnter,
    this.onExit,
  });

  final Widget child;
  final LayerLink link;
  ///child的锚点，与tipAnchor一起用来定位用的
  final Alignment childAnchor;
  ///提示的锚点，与childAnchor一起用来定位用的
  final Alignment tipAnchor;

  /// 偏移
  final Offset offset;
  final PointerEnterEventListener? onEnter;
  final PointerExitEventListener? onExit;

  @override
  Widget build(BuildContext context) {
    Widget result =child;
    if (onEnter != null || onExit != null) {
      result = _ExclusiveMouseRegion(
        onEnter: onEnter,
        onExit: onExit,
        child: result,
      );
    }
    return  Material(
        type: MaterialType.transparency,
        child:Center(child: CompositedTransformFollower(
                link: link,
                offset: offset,
                followerAnchor:tipAnchor,
                targetAnchor: childAnchor,
                child:result)));
  }
}

class _ExclusiveMouseRegion extends MouseRegion {
  const _ExclusiveMouseRegion({
    super.onEnter,
    super.onExit,
    super.child,
  });

  @override
  _RenderExclusiveMouseRegion createRenderObject(BuildContext context) {
    return _RenderExclusiveMouseRegion(
      onEnter: onEnter,
      onExit: onExit,
    );
  }
}


class _RenderExclusiveMouseRegion extends RenderMouseRegion {
  _RenderExclusiveMouseRegion({
    super.onEnter,
    super.onExit,
  });

  static bool isOutermostMouseRegion = true;
  static bool foundInnermostMouseRegion = false;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    bool isHit = false;
    final bool outermost = isOutermostMouseRegion;
    isOutermostMouseRegion = false;
    if (size.contains(position)) {
      isHit =
          hitTestChildren(result, position: position) || hitTestSelf(position);
      if ((isHit || behavior == HitTestBehavior.translucent) &&
          !foundInnermostMouseRegion) {
        foundInnermostMouseRegion = true;
        result.add(BoxHitTestEntry(this, position));
      }
    }

    if (outermost) {
      // The outermost region resets the global states.
      isOutermostMouseRegion = true;
      foundInnermostMouseRegion = false;
    }
    return isHit;
  }
}