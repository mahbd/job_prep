import 'package:flutter/material.dart';

import '../screens/signup.dart';
import '../constants.dart';
import '../screens/login.dart';
import '../screens/home.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case NamedRoutes.home:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => const HomePage(),
      );
    case NamedRoutes.login:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => const LoginPage(),
      );
    case NamedRoutes.register:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => const RegisterPage(),
      );
    default:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}
