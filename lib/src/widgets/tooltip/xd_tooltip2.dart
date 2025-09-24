// // Copyright 2014 The Flutter Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.
//
// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
//
// /// Signature for when a tooltip is triggered.
// typedef TooltipTriggeredCallback = void Function();
//
// /// A special [MouseRegion] that when nested, only the first [_ExclusiveMouseRegion]
// /// to be hit in hit-testing order will be added to the BoxHitTestResult (i.e.,
// /// child over parent, last sibling over first sibling).
// ///
// /// The [onEnter] method will be called when a mouse pointer enters this
// /// [MouseRegion], and there is no other [_ExclusiveMouseRegion]s obstructing
// /// this [_ExclusiveMouseRegion] from receiving the events. This includes the
// /// case where the mouse cursor stays within the paint bounds of an outer
// /// [_ExclusiveMouseRegion], but moves outside of the bounds of the inner
// /// [_ExclusiveMouseRegion] that was initially blocking the outer widget.
// ///
// /// Likewise, [onExit] is called when the a mouse pointer moves out of the paint
// /// bounds of this widget, or moves into another [_ExclusiveMouseRegion] that
// /// overlaps this widget in hit-testing order.
// ///
// /// This widget doesn't affect [MouseRegion]s that aren't [_ExclusiveMouseRegion]s,
// /// or other [HitTestTarget]s in the tree.
// class _ExclusiveMouseRegion extends MouseRegion {
//   const _ExclusiveMouseRegion({
//     super.onEnter,
//     super.onExit,
//     super.child,
//   });
//
//   @override
//   _RenderExclusiveMouseRegion createRenderObject(BuildContext context) {
//     return _RenderExclusiveMouseRegion(
//       onEnter: onEnter,
//       onExit: onExit,
//     );
//   }
// }
//
// class _RenderExclusiveMouseRegion extends RenderMouseRegion {
//   _RenderExclusiveMouseRegion({
//     super.onEnter,
//     super.onExit,
//   });
//
//   static bool isOutermostMouseRegion = true;
//   static bool foundInnermostMouseRegion = false;
//
//   @override
//   bool hitTest(BoxHitTestResult result, {required Offset position}) {
//     bool isHit = false;
//     final bool outermost = isOutermostMouseRegion;
//     isOutermostMouseRegion = false;
//     if (size.contains(position)) {
//       isHit =
//           hitTestChildren(result, position: position) || hitTestSelf(position);
//       if ((isHit || behavior == HitTestBehavior.translucent) &&
//           !foundInnermostMouseRegion) {
//         foundInnermostMouseRegion = true;
//         result.add(BoxHitTestEntry(this, position));
//       }
//     }
//
//     if (outermost) {
//       // The outermost region resets the global states.
//       isOutermostMouseRegion = true;
//       foundInnermostMouseRegion = false;
//     }
//     return isHit;
//   }
// }
//
// ///参照自[Tooltip],如果只是简单的文字提示可以直接使用Tooltip，如果提示需要是复杂的组件则可以使用改组件
// class XDTooltip2 extends StatefulWidget {
//   /// Creates a tooltip.
//   ///
//   /// By default, tooltips should adhere to the
//   /// [Material specification](https://material.io/design/widgets/tooltips.html#spec).
//   /// If the optional constructor parameters are not defined, the values
//   /// provided by [TooltipTheme.of] will be used if a [TooltipTheme] is present
//   /// or specified in [ThemeData].
//   ///
//   /// All parameters that are defined in the constructor will
//   /// override the default values _and_ the values in [TooltipTheme.of].
//   ///
//   /// Only one of [message] and [richMessage] may be non-null.
//   const XDTooltip2(
//       {super.key,
//       this.offset=Offset.zero,
//       this.waitDuration,
//       this.showDuration,
//       this.triggerMode,
//       this.enableFeedback,
//       this.onTriggered,
//        this.childAnchor=Alignment.bottomCenter,
//         this.tipAnchor=Alignment.topCenter,
//       required this.child,
//       required this.tip});
//
//   /// 提示的组件
//   final Widget tip;
//
//   ///child的锚点，与tipAnchor一起用来定位用的
//   final Alignment childAnchor;
//   ///提示的锚点，与childAnchor一起用来定位用的
//   final Alignment tipAnchor;
//
//   /// 偏移
//   final Offset offset;
//
//
//
//   /// The widget below this widget in the tree.
//   ///
//   /// {@macro flutter.widgets.ProxyWidget.child}
//   final Widget child;
//
//
//
//   /// The length of time that a pointer must hover over a tooltip's widget
//   /// before the tooltip will be shown.
//   ///
//   /// Defaults to 0 milliseconds (tooltips are shown immediately upon hover).
//   /// 鼠标悬停多久显示提示框
//   final Duration? waitDuration;
//
//   /// The length of time that the tooltip will be shown after a long press is
//   /// released (if triggerMode is [TooltipTriggerMode.longPress]) or a tap is
//   /// released (if triggerMode is [TooltipTriggerMode.tap]) or mouse pointer
//   /// exits the widget.
//   ///
//   /// Defaults to 1.5 seconds for long press and tap released or 0.1 seconds
//   /// for mouse pointer exits the widget.
//   /// 鼠标移除后提示显示的时间
//   final Duration? showDuration;
//
//   /// The [TooltipTriggerMode] that will show the tooltip.
//   ///
//   /// If this property is null, then [TooltipThemeData.triggerMode] is used.
//   /// If [TooltipThemeData.triggerMode] is also null, the default mode is
//   /// [TooltipTriggerMode.longPress].
//   ///
//   /// This property does not affect mouse devices. Setting [triggerMode] to
//   /// [TooltipTriggerMode.manual] will not prevent the tooltip from showing when
//   /// the mouse cursor hovers over it.
//   /// 触发的模式
//   final TooltipTriggerMode? triggerMode;
//
//   /// Whether the tooltip should provide acoustic and/or haptic feedback.
//   ///
//   /// For example, on Android a tap will produce a clicking sound and a
//   /// long-press will produce a short vibration, when feedback is enabled.
//   ///
//   /// When null, the default value is true.
//   ///
//   /// See also:
//   ///
//   ///  * [Feedback], for providing platform-specific feedback to certain actions.
//   ///  是否启用触觉反馈
//   final bool? enableFeedback;
//
//   /// Called when the Tooltip is triggered.
//   ///
//   /// The tooltip is triggered after a tap when [triggerMode] is [TooltipTriggerMode.tap]
//   /// or after a long press when [triggerMode] is [TooltipTriggerMode.longPress].
//   final TooltipTriggeredCallback? onTriggered;
//
//   static final List<XDTooltip2State> _openedTooltips = <XDTooltip2State>[];
//
//   /// Dismiss all of the tooltips that are currently shown on the screen,
//   /// including those with mouse cursors currently hovering over them.
//   ///
//   /// This method returns true if it successfully dismisses the tooltips. It
//   /// returns false if there is no tooltip shown on the screen.
//   static bool dismissAllToolTips() {
//     if (_openedTooltips.isNotEmpty) {
//       // Avoid concurrent modification.
//       final List<XDTooltip2State> openedTooltips = _openedTooltips.toList();
//       for (final XDTooltip2State state in openedTooltips) {
//         assert(state.mounted);
//         state._scheduleDismissTooltip(withDelay: Duration.zero);
//       }
//       return true;
//     }
//     return false;
//   }
//
//   @override
//   State<XDTooltip2> createState() => XDTooltip2State();
//
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//
//     properties.add(DiagnosticsProperty<Duration>('wait duration', waitDuration,
//         defaultValue: null));
//     properties.add(DiagnosticsProperty<Duration>('show duration', showDuration,
//         defaultValue: null));
//     properties.add(DiagnosticsProperty<TooltipTriggerMode>(
//         'triggerMode', triggerMode,
//         defaultValue: null));
//     properties.add(FlagProperty('enableFeedback',
//         value: enableFeedback, ifTrue: 'true', showName: true));
//   }
// }
//
// /// Contains the state for a [XDTooltip2].
// ///
// /// This class can be used to programmatically show the Tooltip, see the
// /// [ensureTooltipVisible] method.
// class XDTooltip2State extends State<XDTooltip2>
//     with SingleTickerProviderStateMixin {
//   static const double _defaultVerticalOffset = 24.0;
//   static const bool _defaultPreferBelow = true;
//   static const EdgeInsetsGeometry _defaultMargin = EdgeInsets.zero;
//   static const Duration _fadeInDuration = Duration(milliseconds: 150);
//   static const Duration _fadeOutDuration = Duration(milliseconds: 75);
//   static const Duration _defaultShowDuration = Duration(milliseconds: 1500);
//   static const Duration _defaultHoverShowDuration = Duration(milliseconds: 100);
//   static const Duration _defaultWaitDuration = Duration.zero;
//   static const bool _defaultExcludeFromSemantics = false;
//   static const TooltipTriggerMode _defaultTriggerMode =
//       TooltipTriggerMode.longPress;
//   static const bool _defaultEnableFeedback = true;
//   static const TextAlign _defaultTextAlign = TextAlign.start;
//
//   final layerLink = LayerLink();
//
//   final OverlayPortalController _overlayController = OverlayPortalController();
//
//   // From InheritedWidgets
//   late bool _visible;
//   late TooltipThemeData _tooltipTheme;
//
//   Duration get _showDuration =>
//       widget.showDuration ?? _tooltipTheme.showDuration ?? _defaultShowDuration;
//   Duration get _hoverShowDuration =>
//       widget.showDuration ??
//       _tooltipTheme.showDuration ??
//       _defaultHoverShowDuration;
//   Duration get _waitDuration =>
//       widget.waitDuration ?? _tooltipTheme.waitDuration ?? _defaultWaitDuration;
//   TooltipTriggerMode get _triggerMode =>
//       widget.triggerMode ?? _tooltipTheme.triggerMode ?? _defaultTriggerMode;
//   bool get _enableFeedback =>
//       widget.enableFeedback ??
//       _tooltipTheme.enableFeedback ??
//       _defaultEnableFeedback;
//
//   Timer? _timer;
//   AnimationController? _backingController;
//   AnimationController get _controller {
//     return _backingController ??= AnimationController(
//       duration: _fadeInDuration,
//       reverseDuration: _fadeOutDuration,
//       vsync: this,
//     )..addStatusListener(_handleStatusChanged);
//   }
//
//   LongPressGestureRecognizer? _longPressRecognizer;
//   TapGestureRecognizer? _tapRecognizer;
//
//   // The ids of mouse devices that are keeping the tooltip from being dismissed.
//   //
//   // Device ids are added to this set in _handleMouseEnter, and removed in
//   // _handleMouseExit. The set is cleared in _handleTapToDismiss, typically when
//   // a PointerDown event interacts with some other UI component.
//   final Set<int> _activeHoveringPointerDevices = <int>{};
//
//   static bool _isTooltipVisible(AnimationStatus status) {
//     return switch (status) {
//       AnimationStatus.completed ||
//       AnimationStatus.forward ||
//       AnimationStatus.reverse =>
//         true,
//       AnimationStatus.dismissed => false,
//     };
//   }
//
//   AnimationStatus _animationStatus = AnimationStatus.dismissed;
//   void _handleStatusChanged(AnimationStatus status) {
//     assert(mounted);
//     switch ((_isTooltipVisible(_animationStatus), _isTooltipVisible(status))) {
//       case (true, false):
//         XDTooltip2._openedTooltips.remove(this);
//         _overlayController.hide();
//       case (false, true):
//         _overlayController.show();
//         XDTooltip2._openedTooltips.add(this);
//       case (true, true) || (false, false):
//         break;
//     }
//     _animationStatus = status;
//   }
//
//   void _scheduleShowTooltip(
//       {required Duration withDelay, Duration? showDuration}) {
//     assert(mounted);
//     void show() {
//       assert(mounted);
//       if (!_visible) {
//         return;
//       }
//       _controller.forward();
//       _timer?.cancel();
//       _timer = showDuration == null
//           ? null
//           : Timer(showDuration, _controller.reverse);
//     }
//
//     assert(
//       !(_timer?.isActive ?? false) ||
//           _controller.status != AnimationStatus.reverse,
//       'timer must not be active when the tooltip is fading out',
//     );
//     switch (_controller.status) {
//       case AnimationStatus.dismissed when withDelay.inMicroseconds > 0:
//         _timer ??= Timer(withDelay, show);
//       // If the tooltip is already fading in or fully visible, skip the
//       // animation and show the tooltip immediately.
//       case AnimationStatus.dismissed:
//       case AnimationStatus.forward:
//       case AnimationStatus.reverse:
//       case AnimationStatus.completed:
//         show();
//     }
//   }
//
//   void _scheduleDismissTooltip({required Duration withDelay}) {
//     assert(mounted);
//     assert(
//       !(_timer?.isActive ?? false) ||
//           _backingController?.status != AnimationStatus.reverse,
//       'timer must not be active when the tooltip is fading out',
//     );
//
//     _timer?.cancel();
//     _timer = null;
//     // Use _backingController instead of _controller to prevent the lazy getter
//     // from instaniating an AnimationController unnecessarily.
//     switch (_backingController?.status) {
//       case null:
//       case AnimationStatus.reverse:
//       case AnimationStatus.dismissed:
//         break;
//       // Dismiss when the tooltip is fading in: if there's a dismiss delay we'll
//       // allow the fade in animation to continue until the delay timer fires.
//       case AnimationStatus.forward:
//       case AnimationStatus.completed:
//         if (withDelay.inMicroseconds > 0) {
//           _timer = Timer(withDelay, _controller.reverse);
//         } else {
//           _controller.reverse();
//         }
//     }
//   }
//
//   void _handlePointerDown(PointerDownEvent event) {
//     assert(mounted);
//     // PointerDeviceKinds that don't support hovering.
//     const Set<PointerDeviceKind> triggerModeDeviceKinds = <PointerDeviceKind>{
//       PointerDeviceKind.invertedStylus,
//       PointerDeviceKind.stylus,
//       PointerDeviceKind.touch,
//       PointerDeviceKind.unknown,
//       // MouseRegion only tracks PointerDeviceKind == mouse.
//       PointerDeviceKind.trackpad,
//     };
//     switch (_triggerMode) {
//       case TooltipTriggerMode.longPress:
//         final LongPressGestureRecognizer recognizer =
//             _longPressRecognizer ??= LongPressGestureRecognizer(
//           debugOwner: this,
//           supportedDevices: triggerModeDeviceKinds,
//         );
//         recognizer
//           ..onLongPressCancel = _handleTapToDismiss
//           ..onLongPress = _handleLongPress
//           ..onLongPressUp = _handlePressUp
//           ..addPointer(event);
//       case TooltipTriggerMode.tap:
//         final TapGestureRecognizer recognizer = _tapRecognizer ??=
//             TapGestureRecognizer(
//                 debugOwner: this, supportedDevices: triggerModeDeviceKinds);
//         recognizer
//           ..onTapCancel = _handleTapToDismiss
//           ..onTap = _handleTap
//           ..addPointer(event);
//       case TooltipTriggerMode.manual:
//         break;
//     }
//   }
//
//   // For PointerDownEvents, this method will be called after _handlePointerDown.
//   void _handleGlobalPointerEvent(PointerEvent event) {
//     assert(mounted);
//     if (_tapRecognizer?.primaryPointer == event.pointer ||
//         _longPressRecognizer?.primaryPointer == event.pointer) {
//       // This is a pointer of interest specified by the trigger mode, since it's
//       // picked up by the recognizer.
//       //
//       // The recognizer will later determine if this is indeed a "trigger"
//       // gesture and dismiss the tooltip if that's not the case. However there's
//       // still a chance that the PointerEvent was cancelled before the gesture
//       // recognizer gets to emit a tap/longPress down, in which case the onCancel
//       // callback (_handleTapToDismiss) will not be called.
//       return;
//     }
//     if ((_timer == null && _controller.status == AnimationStatus.dismissed) ||
//         event is! PointerDownEvent) {
//       return;
//     }
//     _handleTapToDismiss();
//   }
//
//   // The primary pointer is not part of a "trigger" gesture so the tooltip
//   // should be dismissed.
//   void _handleTapToDismiss() {
//     _scheduleDismissTooltip(withDelay: Duration.zero);
//     _activeHoveringPointerDevices.clear();
//   }
//
//   void _handleTap() {
//     if (!_visible) {
//       return;
//     }
//     final bool tooltipCreated = _controller.status == AnimationStatus.dismissed;
//     if (tooltipCreated && _enableFeedback) {
//       assert(_triggerMode == TooltipTriggerMode.tap);
//       Feedback.forTap(context);
//     }
//     widget.onTriggered?.call();
//     _scheduleShowTooltip(
//       withDelay: Duration.zero,
//       // _activeHoveringPointerDevices keep the tooltip visible.
//       showDuration:
//           _activeHoveringPointerDevices.isEmpty ? _showDuration : null,
//     );
//   }
//
//   // When a "trigger" gesture is recognized and the pointer down even is a part
//   // of it.
//   void _handleLongPress() {
//     if (!_visible) {
//       return;
//     }
//     final bool tooltipCreated =
//         _visible && _controller.status == AnimationStatus.dismissed;
//     if (tooltipCreated && _enableFeedback) {
//       assert(_triggerMode == TooltipTriggerMode.longPress);
//       Feedback.forLongPress(context);
//     }
//     widget.onTriggered?.call();
//     _scheduleShowTooltip(withDelay: Duration.zero);
//   }
//
//   void _handlePressUp() {
//     if (_activeHoveringPointerDevices.isNotEmpty) {
//       return;
//     }
//     _scheduleDismissTooltip(withDelay: _showDuration);
//   }
//
//   // # Current Hovering Behavior:
//   // 1. Hovered tooltips don't show more than one at a time, for each mouse
//   //    device. For example, a chip with a delete icon typically shouldn't show
//   //    both the delete icon tooltip and the chip tooltip at the same time.
//   // 2. Hovered tooltips are dismissed when:
//   //    i. [dismissAllToolTips] is called, even these tooltips are still hovered
//   //    ii. a unrecognized PointerDownEvent occured withint the application
//   //    (even these tooltips are still hovered),
//   //    iii. The last hovering device leaves the tooltip.
//   void _handleMouseEnter(PointerEnterEvent event) {
//     // _handleMouseEnter is only called when the mouse starts to hover over this
//     // tooltip (including the actual tooltip it shows on the overlay), and this
//     // tooltip is the first to be hit in the widget tree's hit testing order.
//     // See also _ExclusiveMouseRegion for the exact behavior.
//     _activeHoveringPointerDevices.add(event.device);
//     final List<XDTooltip2State> openedTooltips =
//         XDTooltip2._openedTooltips.toList();
//     bool otherTooltipsDismissed = false;
//     for (final XDTooltip2State tooltip in openedTooltips) {
//       assert(tooltip.mounted);
//       final Set<int> hoveringDevices = tooltip._activeHoveringPointerDevices;
//       final bool shouldDismiss = tooltip != this &&
//           (hoveringDevices.length == 1 &&
//               hoveringDevices.single == event.device);
//       if (shouldDismiss) {
//         otherTooltipsDismissed = true;
//         tooltip._scheduleDismissTooltip(withDelay: Duration.zero);
//       }
//     }
//     _scheduleShowTooltip(
//         withDelay: otherTooltipsDismissed ? Duration.zero : _waitDuration);
//   }
//
//   void _handleMouseExit(PointerExitEvent event) {
//     if (_activeHoveringPointerDevices.isEmpty) {
//       return;
//     }
//     _activeHoveringPointerDevices.remove(event.device);
//     if (_activeHoveringPointerDevices.isEmpty) {
//       _scheduleDismissTooltip(withDelay: _hoverShowDuration);
//     }
//   }
//
//   /// Shows the tooltip if it is not already visible.
//   ///
//   /// After made visible by this method, The tooltip does not automatically
//   /// dismiss after `waitDuration`, until the user dismisses/re-triggers it, or
//   /// [XDTooltip2.dismissAllToolTips] is called.
//   ///
//   /// Returns `false` when the tooltip shouldn't be shown or when the tooltip
//   /// was already visible.
//   bool ensureTooltipVisible() {
//     if (!_visible) {
//       return false;
//     }
//
//     _timer?.cancel();
//     _timer = null;
//     switch (_controller.status) {
//       case AnimationStatus.dismissed:
//       case AnimationStatus.reverse:
//         _scheduleShowTooltip(withDelay: Duration.zero);
//         return true;
//       case AnimationStatus.forward:
//       case AnimationStatus.completed:
//         return false;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Listen to global pointer events so that we can hide a tooltip immediately
//     // if some other control is clicked on. Pointer events are dispatched to
//     // global routes **after** other routes.
//     GestureBinding.instance.pointerRouter
//         .addGlobalRoute(_handleGlobalPointerEvent);
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _visible = TooltipVisibility.of(context);
//     _tooltipTheme = TooltipTheme.of(context);
//   }
//
//   // https://material.io/widgets/tooltips#specs
//   double _getDefaultTooltipHeight() {
//     return switch (Theme.of(context).platform) {
//       TargetPlatform.macOS ||
//       TargetPlatform.linux ||
//       TargetPlatform.windows =>
//         24.0,
//       TargetPlatform.android ||
//       TargetPlatform.fuchsia ||
//       TargetPlatform.iOS =>
//         32.0,
//     };
//   }
//
//   EdgeInsets _getDefaultPadding() {
//     return switch (Theme.of(context).platform) {
//       TargetPlatform.macOS ||
//       TargetPlatform.linux ||
//       TargetPlatform.windows =>
//         const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//       TargetPlatform.android ||
//       TargetPlatform.fuchsia ||
//       TargetPlatform.iOS =>
//         const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
//     };
//   }
//
//   static double _getDefaultFontSize(TargetPlatform platform) {
//     return switch (platform) {
//       TargetPlatform.macOS ||
//       TargetPlatform.linux ||
//       TargetPlatform.windows =>
//         12.0,
//       TargetPlatform.android ||
//       TargetPlatform.fuchsia ||
//       TargetPlatform.iOS =>
//         14.0,
//     };
//   }
//
//   Widget _buildTooltipOverlay(BuildContext context) {
//     final OverlayState overlayState =
//         Overlay.of(context, debugRequiredFor: widget);
//     final RenderBox box = this.context.findRenderObject()! as RenderBox;
//     final Offset target = box.localToGlobal(
//       box.size.center(Offset.zero),
//       ancestor: overlayState.context.findRenderObject(),
//     );
//
//     final (TextStyle defaultTextStyle, BoxDecoration defaultDecoration) =
//         switch (Theme.of(context)) {
//       ThemeData(
//         brightness: Brightness.dark,
//         :final TextTheme textTheme,
//         :final TargetPlatform platform
//       ) =>
//         (
//           textTheme.bodyMedium!.copyWith(
//               color: Colors.black, fontSize: _getDefaultFontSize(platform)),
//           BoxDecoration(
//               color: Colors.white.withOpacity(0.9),
//               borderRadius: const BorderRadius.all(Radius.circular(4))),
//         ),
//       ThemeData(
//         brightness: Brightness.light,
//         :final TextTheme textTheme,
//         :final TargetPlatform platform
//       ) =>
//         (
//           textTheme.bodyMedium!.copyWith(
//               color: Colors.white, fontSize: _getDefaultFontSize(platform)),
//           BoxDecoration(
//               color: Colors.grey[700]!.withOpacity(0.9),
//               borderRadius: const BorderRadius.all(Radius.circular(4))),
//         ),
//     };
//     // 方案1:
//     // final TooltipThemeData tooltipTheme = _tooltipTheme;
//     //
//     // final _TooltipOverlay overlayChild = _TooltipOverlay(
//     //   child: widget.tip,
//     //   onEnter: _handleMouseEnter,
//     //   onExit: _handleMouseExit,
//     //   animation:
//     //       CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
//     //   target: target,
//     //   verticalOffset: widget.offset.dx ??
//     //       tooltipTheme.verticalOffset ??
//     //       _defaultVerticalOffset,
//     //   preferBelow:
//     //       widget.preferBelow ?? tooltipTheme.preferBelow ?? _defaultPreferBelow,
//     // );
//   // 方案2
//     final _TooltipOverlay overlayChild = _TooltipOverlay(
//       child: widget.tip,
//       onEnter: _handleMouseEnter,
//       onExit: _handleMouseExit,
//       animation:
//       CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn), childAnchor:widget.childAnchor, tipAnchor: widget.tipAnchor, offset: widget.offset ,link: layerLink,
//
//     );
//
//
//     return SelectionContainer.maybeOf(context) == null
//         ? overlayChild
//         : SelectionContainer.disabled(child: overlayChild);
//   }
//
//   @override
//   void dispose() {
//     GestureBinding.instance.pointerRouter
//         .removeGlobalRoute(_handleGlobalPointerEvent);
//     XDTooltip2._openedTooltips.remove(this);
//     // _longPressRecognizer.dispose() and _tapRecognizer.dispose() may call
//     // their registered onCancel callbacks if there's a gesture in progress.
//     // Remove the onCancel callbacks to prevent the registered callbacks from
//     // triggering unnecessary side effects (such as animations).
//     _longPressRecognizer?.onLongPressCancel = null;
//     _longPressRecognizer?.dispose();
//     _tapRecognizer?.onTapCancel = null;
//     _tapRecognizer?.dispose();
//     _timer?.cancel();
//     _backingController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     assert(debugCheckHasOverlay(context));
//     Widget result = CompositedTransformTarget(
//       link: layerLink,
//       child: widget.child,
//     );
//
//     // Only check for gestures if tooltip should be visible.
//     if (_visible) {
//       result = _ExclusiveMouseRegion(
//         onEnter: _handleMouseEnter,
//         onExit: _handleMouseExit,
//         child: Listener(
//           onPointerDown: _handlePointerDown,
//           behavior: HitTestBehavior.opaque,
//           child: result,
//         ),
//       );
//     }
//     return OverlayPortal(
//       controller: _overlayController,
//       overlayChildBuilder: _buildTooltipOverlay,
//       child: result,
//     );
//   }
// }
//
//
//
// //方式1：自己计算位置，只计算了垂直的方向，后面需要自己计算水平方向的
// // class _TooltipOverlay extends StatelessWidget {
// //   const _TooltipOverlay({
// //     required this.child,
// //     required this.animation,
// //     required this.target,
// //     required this.verticalOffset,
// //     required this.preferBelow,
// //     this.onEnter,
// //     this.onExit,
// //   });
// //
// //   final Widget child;
// //
// //   final Animation<double> animation;
// //   final Offset target;
// //   final double verticalOffset;
// //   final bool preferBelow;
// //   final PointerEnterEventListener? onEnter;
// //   final PointerExitEventListener? onExit;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     Widget result = FadeTransition(
// //       opacity: animation,
// //       child: child,
// //     );
// //     if (onEnter != null || onExit != null) {
// //       result = _ExclusiveMouseRegion(
// //         onEnter: onEnter,
// //         onExit: onExit,
// //         child: result,
// //       );
// //     }
// //     return Positioned.fill(
// //       bottom: MediaQuery.maybeViewInsetsOf(context)?.bottom ?? 0.0,
// //       child: CustomSingleChildLayout(
// //         delegate: _TooltipPositionDelegate(
// //           target: target,
// //           verticalOffset: verticalOffset,
// //           preferBelow: preferBelow,
// //         ),
// //         child: result,
// //       ),
// //     );
// //   }
// // }
// /// A delegate for computing the layout of a tooltip to be displayed above or
// /// below a target specified in the global coordinate system.
// class _TooltipPositionDelegate extends SingleChildLayoutDelegate {
//   /// Creates a delegate for computing the layout of a tooltip.
//   _TooltipPositionDelegate({
//     required this.target,
//     required this.verticalOffset,
//     required this.preferBelow,
//   });
//
//   /// The offset of the target the tooltip is positioned near in the global
//   /// coordinate system.
//   final Offset target;
//
//   /// The amount of vertical distance between the target and the displayed
//   /// tooltip.
//   final double verticalOffset;
//
//   /// Whether the tooltip is displayed below its widget by default.
//   ///
//   /// If there is insufficient space to display the tooltip in the preferred
//   /// direction, the tooltip will be displayed in the opposite direction.
//   final bool preferBelow;
//
//   @override
//   BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
//       constraints.loosen();
//
//   @override
//   Offset getPositionForChild(Size size, Size childSize) {
//     return positionDependentBox(
//       size: size,
//       childSize: childSize,
//       target: target,
//       verticalOffset: verticalOffset,
//       preferBelow: preferBelow,
//     );
//   }
//
//   @override
//   bool shouldRelayout(_TooltipPositionDelegate oldDelegate) {
//     return target != oldDelegate.target ||
//         verticalOffset != oldDelegate.verticalOffset ||
//         preferBelow != oldDelegate.preferBelow;
//   }
// }
//
// // ///方案2 通过CompositedTransform与CompositedTransformFollower
// class _TooltipOverlay extends StatelessWidget {
//   const _TooltipOverlay({
//     required this.child,
//     required this.animation,
//     required this.childAnchor,
//     required this.tipAnchor,
//      required this.offset,
//     required this.link,
//     this.onEnter,
//     this.onExit,
//   });
//
//   final Widget child;
//   final LayerLink link;
//   final Animation<double> animation;
//   ///child的锚点，与tipAnchor一起用来定位用的
//   final Alignment childAnchor;
//   ///提示的锚点，与childAnchor一起用来定位用的
//   final Alignment tipAnchor;
//
//   /// 偏移
//   final Offset offset;
//   final PointerEnterEventListener? onEnter;
//   final PointerExitEventListener? onExit;
//
//   @override
//   Widget build(BuildContext context) {
//     Widget result = FadeTransition(
//       opacity: animation,
//       child: child,
//     );
//     if (onEnter != null || onExit != null) {
//       result = _ExclusiveMouseRegion(
//         onEnter: onEnter,
//         onExit: onExit,
//         child: result,
//       );
//     }
//     return      Material(
//         type: MaterialType.transparency,
//         child: Center(
//         child:CompositedTransformFollower(
//         link: link,
//         offset: offset,
//         followerAnchor:tipAnchor,
//         targetAnchor: childAnchor,
//         child:result)));
//   }
// }
