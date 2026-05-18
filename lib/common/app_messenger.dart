import 'package:flutter/material.dart';

/// Global key so snackbars work from ViewModels without BuildContext.
class AppMessenger {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
}
