    
import 'package:flutter/material.dart';
import 'package:yogurt/loadingScreen.dart';
import 'package:yogurt/authentication.dart';
import 'package:yogurt/order_list.dart';
import 'authentication.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    Home.routeName: (BuildContext context) => new Home(),
    Login.routeName: (BuildContext context) => new Login(),
    Register.routeName: (BuildContext context) => new Register(),
    OrderMain.routeName: (BuildContext context) => new OrderMain(),
    ResetPass.routeName: (BuildContext context) => new ResetPass(),
    SplashScreen.routeName: (BuildContext context) => new SplashScreen(),
  };

  Routes () {
    runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Yogurt",
      routes: routes,
      initialRoute: SplashScreen.routeName,
      onGenerateRoute: (RouteSettings settings){
      },
      onUnknownRoute: (RouteSettings settings){
      },
    ));
  }
}