import 'package:yogurt/selection.dart';

import 'Colors.dart';
import 'package:flutter/material.dart';

class OrderMain extends StatefulWidget {
  static const String routeName = "/OrderMain";

  @override
  _OrderMainState createState() => _OrderMainState();
}

class _OrderMainState extends State<OrderMain> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
              elevation: 2,
              backgroundColor: WHITE,
              bottom: TabBar(
                indicatorColor: LIGHT_GRAY,
                labelColor: LIGHT_GRAY,
                tabs: [
                  Tab(icon: Icon(Icons.shopping_basket)),
                  Tab(icon: Icon(Icons.list)),
                  Tab(icon: Icon(Icons.settings)),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.directions_car),
              Container(color: THEME_COLOR,),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
