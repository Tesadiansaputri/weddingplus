import 'package:flutter/material.dart';

abstract final class AppRoutes {
  static const home = '/home';
  static const rencana = '/rencana';
  static const chat = '/chat';
  static const user = '/user';
}

void navigateToBottomTab(
  BuildContext context,
  String routeName, {
  bool isCurrent = false,
}) {
  if (isCurrent || ModalRoute.of(context)?.settings.name == routeName) {
    return;
  }

  Navigator.of(context).pushNamedAndRemoveUntil(
    routeName,
    (route) => false,
  );
}
