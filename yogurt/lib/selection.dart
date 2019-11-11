import 'dart:core';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yogurt/images.dart';

import 'package:yogurt/settings.dart';
import 'package:yogurt/past_orders.dart';
import 'Colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:path_provider/path_provider.dart';

class OrderList extends StatefulWidget {
  static const String routeName = "/OrderList";
  final FirebaseUser user;

  OrderList(this.user);

  @override
  _OrderListState createState() => _OrderListState(user: user);
}

class _OrderListState extends State<OrderList> {
  FirebaseUser user;

  _OrderListState({this.user});

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController controller = PageController();
  PageController itemView = PageController(viewportFraction: 0.95);
  ScrollController sc = ScrollController(initialScrollOffset: 70);

  //Map<String, Map<String, dynamic>> mapa = <String, Map<String, dynamic>>{};
  Map<String, dynamic> izdelki = <String, dynamic>{}; //Mapa za izdelke
  //var tempDir;

  //var list_name = new List();
  //var currentPageValue = 0.0;
  //double _viewportScale = 1;
  var order_list;

  var slike = ["assets/breskev.jpg", "assets/jagoda.jpg", "assets/vanilla_coko.jpg"];
  var slikeMap = {
    'Breskev': 'assets/breskev.jpg',
    'Jagoda': 'assets/jagoda.jpg',
    'Vanilija Coko': "assets/vanilla_coko.jpg"
  };
  var iconsMap = {
    "Breskev": "assets/breskev.png",
    "Jagoda": "assets/jagoda.png",
    "Vanilija Coko": "assets/choco_vanilla.png"
  };

  final Firestore db = Firestore.instance;
  final Firestore dbb = Firestore.instance;

  var userID; //!Uporabnik
  Stream items; //!Stream for items
  Stream userData; //!Stream for userData
  List users_order_list;
  int cnt = 0;
  int current_page = 0;
  var dir = Directory.systemTemp;
  List<FileSystemEntity> _images;

  
  

  @override
  void initState(){
    super.initState();

    final myDir = new Directory(dir.path);
    
    //_images = myDir.listSync(recursive: true, followLinks: false);
    print(myDir);
    print(_images);

    userID = user.uid; //!FirebaseUser

    order_list = new Map(); //?Init Map

    queryItems(); //!Call query function for getting items
    queryUserData(); //!Call query function for getting user data

    itemView.addListener(() {
      int next = itemView.page.round();
      if (current_page != next) {
        setState(() {
          current_page = next;
        });
      }
    });
  }

  /*
  void assignItems() {
    FilterIfAvailable() //!klici metodo za filtriranje izdelkov ki pretvori Firestore.instance v QuerySnapshot
        .getImages()
        .then((QuerySnapshot docs) async {
      if (docs.documents.isNotEmpty) {
        //!If dacuments not empty
        for (var i = 0; i < docs.documents.length; i++) {
          var itemData = docs.documents[i].data;
          izdelki[itemData['ime']] =
              itemData; //!Napolni Map z izdelki ..... jagoda.jpg :  item_data
        }
      }
    }).catchError((e) {
      print("Got error: ${e.error}");
    });
  }
  */

 
  

  void showInSnackBar(String value) {
    //!Pokaži sporočilo po opravljenem sporočilu
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<Stream> queryItems() async {
    //!Fetch items
    try {
      Query query = db.collection('current_items').where("available", isEqualTo: true);
      //!Filter available izdelke
      items = query.snapshots().map((list) {
        return list.documents.map((doc) {
          return doc.data;
        });
      });
    } catch (e) {
      print("Got error: ${e.error}");
    }
  }

  Future<Stream> queryUserData() async {
    //!Fetch userData
    try {
      Query query2 = dbb.collection('users'); //!Users
      userData = query2.snapshots().map((list) {
        return list.documents.map((doc) {
          return doc.data;
        });
      });
    } catch (e) {
      print("Got error: ${e.error}");
    }
  }

  @override
  void dispose() {
    controller.dispose();
    itemView.dispose();
    sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zoomItem = Hero(
      tag: "jagoda",
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height / 1.5,
        decoration: new BoxDecoration(
            image: new DecorationImage(
                fit: BoxFit.fill, image: AssetImage("assets/jagoda.jpg"))),
      ),
    );

    this.controller = PageController(
      //!Page Controller za prehajanje med SelectionScreen in Cart
      initialPage: 0,
      viewportFraction: 1,
    );
    bool onWillPop() {
      //!Metoda za animiran transition med Selection in Cart screen-om
      controller.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
      );
      return false;
    }

    //!BUILDS MAIN SELECTION SCREEN
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: WHITE,
      body: PageView(
        //*PageView za prehajanje iz seznama izdelkov v košarico
        onPageChanged: (num) {
          print("Current page number is: " + num.toString());
        },
        //?physics: BouncingScrollPhysics(),
        controller: controller,
        scrollDirection: Axis.vertical,
        pageSnapping: true,

        children: <Widget>[
          buildSelectionMenu(context), //!SelectionScreen
          buildCartPage(onWillPop, context), //!Cart Screen
        ],
      ),
    );
  }

  Container buildSelectionMenu(BuildContext context) => Container(
        //!Ustvari main page
        height: MediaQuery.of(context).size.height, //*Višina zaslona
        width: MediaQuery.of(context).size.width, //*Širina zaslona
        color: Colors.transparent,
        child: Stack(
          //!Nov stack za ListView izdelkov
          children: <Widget>[
            //!ZGORNJI CONTAINER V KATEREM SE NAHAJA SELECTION
            Align(
              alignment: Alignment.topCenter, //*Poravnaj na vrh-center zaslona
              child: Container(
                decoration: new BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black.withOpacity(0.6), //*Black shadow okoli
                        offset: new Offset(1.0, 2.0), //*z offsetom
                        blurRadius: 15.0,
                      )
                    ],
                    color: THEME_COLOR.withOpacity(0.9), //*Tema
                    borderRadius: new BorderRadius.only(
                        //*Oglati robovi
                        bottomLeft: const Radius.circular(55.0),
                        bottomRight: const Radius.circular(55.0))),
                height: MediaQuery.of(context).size.height *
                    0.90, //!Višina containerja je 90% višine ekrana
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        //!Vrsta za orders in settings icone
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, //!Porazdeli ikone levo in desno z spaco-om vmes
                          children: <Widget>[
                            new OrdersIcon(user: user),
                            new SettingsIcon(user: user),
                          ],
                        ),
                      ),
                      //!Stream builder za grajenje seznama izdelkov iz baze
                      StreamBuilder(
                        //!Posluša in rebuilda seznam for every new event
                        stream: items,
                        //!Vzame zgoraj filtriran seznam izdelkov kot Stream
                        initialData: [],
                        builder: (context, AsyncSnapshot snap) {
                          List slideList =
                              snap.data.toList(); //! Convert AsynSnapshot into List
                          print("Število elementov:" + slideList.length.toString());
                          if (snap.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: Text(
                                "Loading",
                                style: TextStyle(fontSize: 30),
                              ),
                            );
                          } else {
                            return Container(
                              //!Vrni container ki vsebuje PageView
                              height: MediaQuery.of(context).size.height /
                                  1.5, //!Velikost polovice ekrana
                              child: PageView.builder(
                                onPageChanged: (num) {
                                  var fIndex = num + 1;
                                  print("Trenutni index izdelka: " + fIndex.toString());
                                },
                                controller: itemView, //!Pass PageView controller
                                scrollDirection: Axis.horizontal,
                                itemCount: slideList
                                    .length, //!Število elementov je dolžina lista
                                itemBuilder: (context, int currentIndex) {
                                  //!Build current facing item
                                  bool active = currentIndex == current_page;
                                  //print(active.toString());
                                  //print("Trenutni index: " + currentIndex.toString() + " Trenutna stran: " + current_page.toString());
                                  return buildProductListPage(
                                      slideList[currentIndex], active, currentIndex);

                                  //?(Lastnosti izdelka kot Map, bool trenutno aktiven, trenutni facing element)
                                },
                              ),
                            );
                          }
                        },
                      ),
                      Align(
                        //!Cart pod containerjem
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: InkWell(
                            onTap: () {
                              controller.animateTo(500.0,
                                  curve: Curves.linear,
                                  duration: Duration(milliseconds: 500));
                            },
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                SizedBox(
                                  //!Box ki vsebuje animiran text in te vrze na CartScreen
                                  child: ScaleAnimatedTextKit(
                                      onTap: () {
                                        controller.animateTo(500.0,
                                            curve: Curves.linear,
                                            duration: Duration(milliseconds: 500));
                                      },
                                      text: ["Cart"],
                                      textStyle: TextStyle(
                                          fontSize: 35.0, fontFamily: "MadeEvolveSans"),
                                      textAlign: TextAlign.center,
                                      alignment: AlignmentDirectional
                                          .topStart //! or Alignment.topLeft
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 24.0),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 34,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            buildBonusCounter(
                context), //!Zgradi Row pod MainContainerjem na SelectionScreenu
          ],
        ),
      );

  //!Build list view of products
  Widget buildProductListPage(Map data, bool active, var index) {
    final double blur = active ? 5 : 0;
    final double offset = active ? 2 : 0;
    final double top = active ? 30 : 200;
    final double icon_size = active ? 50 : 0;
    final String ime = data['file_name'];
    final String path = "${dir.path}/$ime";
    return InkWell(
      onTap: () {
        print("This does nothing, absolutly nothing!!");
      },
      child: AnimatedContainer(
        height: 600,
        width: 400,
        duration: Duration(milliseconds: 1200),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: top, bottom: 10, right: 15, left: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("$path")),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                offset: new Offset(offset / 2, offset),
                blurRadius: blur,
              )
            ]),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      data['ime'],
                      style: TextStyle(
                          fontFamily: 'MadeEvolveSans', fontSize: 50, color: WHITE),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    data['volume'].toString() + "ml",
                    style: TextStyle(
                        fontFamily: 'MadeEvolveSans', fontSize: 25, color: WHITE),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0, right: 17.0),
                child: IconButton(
                  
                  onPressed: () {
                    
                    setState(() {
                      if (order_list.containsKey(data['ime'])) {
                        order_list.update(data['ime'], (dynamic val) => ++val);
                      } else {
                        order_list[data['ime']] = 1;
                      }
                      print(order_list);
                    });
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: WHITE,
                    size: icon_size,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Text(
                  (order_list[data['ime']] == 0 || order_list[data['ime']] == null)
                      ? " "
                      : order_list[data['ime']].toString(),
                  style:
                      TextStyle(fontFamily: 'MadeEvolveSans', fontSize: 60, color: WHITE),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0, left: 0.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (order_list.containsKey(data['ime'])) {
                        order_list.update(data['ime'], (dynamic val) => --val);
                        if (order_list[data['ime']] == 0) {
                          order_list.remove(data['ime']);
                        }
                      }
                      print(order_list);
                    });
                  },
                  icon: Icon(
                    Icons.do_not_disturb_on,
                    color: WHITE,
                    size: icon_size,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //!Builds LowerPart of the selection screen
  Align buildBonusCounter(BuildContext context) => Align(
        alignment: Alignment(0.0, 1),
        child: Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height * 0.1,
          child: ListView.builder(
            itemCount: order_list.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: new Stack(
                      children: <Widget>[
                        Center(
                          child: new Image.asset(
                            "assets/firstScreenYogurt.png",
                            width: MediaQuery.of(context).size.height * 0.1 * 0.8,
                            height: MediaQuery.of(context).size.height * 0.1 * 0.8,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );

  //!Builds CartScreen
  WillPopScope buildCartPage(bool onWillPop(), BuildContext context) => WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: Container(
          color: WHITE,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Cart",
                        style: TextStyle(fontSize: 35, fontFamily: 'MadeEvolveSans'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Container(
                        color: Colors.transparent,
                        height: 500,
                        width: double.infinity,
                        child: StreamBuilder(
                            initialData: [],
                            stream: userData,
                            builder: (context, snap) {
                              if (snap.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: Text("Loading"),
                                );
                              } else {
                                return ListView.builder(
                                  itemBuilder: (context, int position) {
                                    var list = order_list.keys.toList();
                                    if (list.length == 0) {
                                      return null;
                                    } else {
                                      return new OrderItem(
                                        order_list: order_list,
                                        ime_jogurta: list[position],
                                        iconsMap: iconsMap,
                                        slikeMap: slikeMap,
                                      );
                                    }
                                  },
                                  itemCount: order_list.length,
                                );
                              }
                            }),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          order_list.clear();
                        });
                        showInSnackBar(
                            "Your order has been dispatched. Thanks for ordering.");
                      },
                      height: 56,
                      minWidth: MediaQuery.of(context).size.width / 1.2,
                      color: THEME_COLOR,
                      child: Text(
                        "Confirm Order",
                        style: TextStyle(color: WHITE),
                      ),
                      elevation: 2,
                      highlightColor: THEME_COLOR,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: THEME_COLOR)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  //!AssetImage assetImage(var n) => AssetImage(slikeMap[n]);   Icon Yogurt
  AssetImage assetImage(var n) => AssetImage("assets/breskev.jpg");
}

class SettingsIcon extends StatelessWidget {
  const SettingsIcon({
    Key key,
    @required this.user,
  }) : super(key: key);

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 2),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    //!Jump to settings
                    builder: (context) => Settings(user)));
          },
          child: Icon(
            Icons.settings_input_composite,
            size: 35,
          ),
        ),
      ],
    );
  }
}

class OrdersIcon extends StatelessWidget {
  const OrdersIcon({
    Key key,
    @required this.user,
  }) : super(key: key);

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 2),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    //!Jump to past orders
                    builder: (context) => Orders(user)));
          },
          child: Icon(
            Icons.timer,
            size: 35,
          ),
        ),
      ],
    );
  }
}

//!Metoda za printanje trenutnega števila izbranih izdelkov
String showQuantity(ime_jogurta, Map order_list) {
  if (order_list.containsKey(ime_jogurta)) {
    return order_list[ime_jogurta].toString();
  }
}

//!Izdelek prikazan na CartScreen-u (Košarici)
class OrderItem extends StatelessWidget {
  final Map order_list;
  final String ime_jogurta;
  final Map iconsMap;
  final Map slikeMap;

  const OrderItem(
      {Key key,
      @required this.order_list,
      @required this.ime_jogurta,
      @required this.iconsMap,
      @required this.slikeMap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, left: 15, right: 15),
      child: Container(
        decoration: new BoxDecoration(boxShadow: [
          new BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: new Offset(1.0, 2.0),
            blurRadius: 5.0,
          )
        ], color: WHITE, borderRadius: new BorderRadius.all(Radius.circular(12))),
        height: 110,
        width: 100,
        child: Padding(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ime_jogurta,
                      style: TextStyle(fontSize: 27),
                    ),
                    Text(
                      (order_list[ime_jogurta] * 1.4).toStringAsFixed(2) + "€",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: new Image.asset(
                  iconsMap[ime_jogurta],
                  width: 110 * 0.6,
                  height: 110 * 0.6,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  onPressed: () {
                    //!_sendToServerLogin(myControllerLogin.text, myControllerPass.text);
                  },
                  height: 20,
                  minWidth: 70,
                  color: THEME_COLOR,
                  child: Text(
                    "Qty:  " + order_list[ime_jogurta].toString(),
                    style: TextStyle(color: WHITE),
                  ),
                  elevation: 2,
                  highlightColor: THEME_COLOR,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: THEME_COLOR)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}