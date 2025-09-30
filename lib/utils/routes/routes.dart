import 'package:fam_assignment/utils/routes/routes_name.dart';
import 'package:fam_assignment/view/home_view.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.home:
        {
          return MaterialPageRoute(
            builder: (BuildContext context) => HomeView(),
          );
        }
      default:
        {
          return MaterialPageRoute(
            builder: (_) {
              return const Scaffold(
                body: Center(child: Text("No Routes defined")),
              );
            },
          );
        }
    }
  }
}
