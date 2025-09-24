

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/intl/xd_localizations.dart';
import '../../models/network_state.dart';
import 'network_request_controller.dart';

class XDNetworkRequest<T> extends StatefulWidget {
  final XDNetworkRequestController<T> controller;

  final Widget Function(BuildContext context, T data) builder;
  const XDNetworkRequest({super.key,required this.controller, required this.builder});

  @override
  State<XDNetworkRequest<T>> createState() => _XDNetworkRequestState<T>();
}

class _XDNetworkRequestState<T> extends State<XDNetworkRequest<T>> {
  late XDNetworkRequestController<T> controller;
  @override
  void initState() {
    super.initState();
    controller=widget.controller;
    controller.fetchData();
  }
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider.value(
        value: controller,
        child:Consumer<XDNetworkRequestController<T>>(
        builder: (context, controller, child) {

          if (controller.networkState == NetworkRequestStatus.requesting && controller.initialValue==null) {
            return Material(color:  Colors.white,child: const Center(child: CircularProgressIndicator()));
          }
          if (controller.networkState == NetworkRequestStatus.requestFail) {
            return Material(
              color: Colors.white70,
              child: GestureDetector(
                child:  Center(child: Text(XDLocalizations.of(context).networkError)),
                onTap: () {
                  controller.fetchData();
                },
              ),
            );
          }
          if (controller.networkState == NetworkRequestStatus.requestSuccess) {
            return widget.builder(context, controller.data as T);
          }

          return widget.controller.initialValue!=null?widget.builder(context, (controller.data??widget.controller.initialValue) as T ): const SizedBox();
        }) );
  }
}
