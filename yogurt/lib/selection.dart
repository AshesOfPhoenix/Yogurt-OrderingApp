import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yogurt/FireStore.dart';
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

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController controller = PageController();
  PageController itemView = PageController(viewportFraction: 0.95);
  ScrollController sc = ScrollController(initialScrollOffset: 70);

  //Map<String, Map<String, dynamic>> mapa = <String, Map<String, dynamic>>{};
  Map<String, dynamic> availableItems =
      <String, dynamic>{}; //!Mapa za izdelki ki so na voljo
  Map selectedItems = new Map(); //!Mapa z izbranimi izdelki
  //Map<String, String> slikeCached = <String, String>{};

  //var list_name = new List();
  //var currentPageValue = 0.0;
  //double _viewportScale = 1;
  Directory dir = Directory
      .systemTemp; //!Temporary system directory where the images are stored -> CACHED
  var myDir; //!Variable that holds the path to temporary directory

  String userID; //!FirebaseUser id <- currently loged user

  final Firestore yogurts = Firestore.instance;
  final Firestore users = Firestore.instance;
  Stream items; //!Stream for items
  Stream userData; //!Stream for userData

  List users_selectedItems;
  int cnt = 0;
  int current_page = 0;

  //!Hardcoded file paths
  var slike = ["assets/breskev.jpg", "assets/jagoda.jpg", "assets/vanilla_coko.jpg"];
  var slikeMap = {
    0: 'assets/breskev.jpg',
    1: 'assets/jagoda.jpg',
    2: "assets/vanilla_coko.jpg"
  };
  var iconsMap = {
    "Breskev": "assets/breskev.png",
    "Jagoda": "assets/jagoda.png",
    "Vanilija Coko": "assets/choco_vanilla.png"
  };
  var iconsCached = {
    "Breskev": '/data/user/0/com.example.yogurt/code_cache/breskev.png',
    "Jagoda": '/data/user/0/com.example.yogurt/code_cache/jagoda.png',
    "Vanilija Coko": '/data/user/0/com.example.yogurt/code_cache/choco_vanilla.png'
  };
  var slikeCached = {
    0: '/data/user/0/com.example.yogurt/code_cache/marelica.jpg',
    1: '/data/user/0/com.example.yogurt/code_cache/jagoda.jpg',
    2: '/data/user/0/com.example.yogurt/code_cache/vanilija_coko.jpg'
  };

  StreamController<Stream> _postStreamController = StreamController<Stream>();

  @override
  void initState() {
    super.initState();

    myDir = new Directory(dir.path);
    userID = user.uid;
    //items = FetchFromFirestore().queryItems() as Stream;
    //userData = FetchFromFirestore().queryUserData(userID) as Stream;
    queryItems(); //!Stream for items currently availble
    queryUserData(); //!Stream for userData of the loged user

    //!Page Controller za prehajanje med SelectionScreen in Cart
    controller = PageController(
      initialPage: 0,
      viewportFraction: 1,
    );

    itemView.addListener(() {
      int next = itemView.page.round();
      if (current_page != next) {
        setState(() {
          current_page = next;
        });
      }
    });
  }

  void queryItems() async {
    //!Fetch items
    try {
      Query query =
          await yogurts.collection('current_items').where("available", isEqualTo: true);
      //!Filter available izdelke
      //*QuerySnapshot contains zero or more QueryDocumentSnapshot objects representing the results of a query
      items = query.snapshots().map((list) {
        //!Convert stream to map on the fly ->
        return list.documents.map((doc) {
          //*For every document
          return doc.data; //*Data from every document
        });
      });
      _postStreamController.add(items);
    } catch (e) {
      print("Got error: ${e.error}");
    }
  }

  void queryUserData() async {
    //!Fetch userData
    try {
      Query query2 = users.collection('users').where("uid", isEqualTo: userID); //!Users
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

  //!ZOOMER
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

    //!Metoda za animiran transition med Selection in Cart screen-om
    bool onWillPop() {
      controller.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
      );
      return false;
    }

    //!BUILDS MAIN SELECTION SCREEN
    return Scaffold(
      key: scaffoldKey,
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
        child: Column(
          //!Nov stack za ListView izdelkov
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //!ZGORNJI CONTAINER V KATEREM SE NAHAJA SELECTION
            buildSelection(context),
            buildBonusCounter(
                context), //!Zgradi Row pod MainContainerjem na SelectionScreenu
          ],
        ),
      );

  Container buildSelection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.9, //!Višina containerja je 90% višine ekrana
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.9 * 0.08,
            child: Padding(
              //!Vrsta za orders in settings icone
              padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
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
          ),
          //!Stream builder za grajenje seznama izdelkov iz baze
          Container(
            height: MediaQuery.of(context).size.height * 0.9 * 0.8,
            child: StreamBuilder(
              //!Posluša in rebuilda seznam for every new event
              stream: items, //?single-subscription stream from the future
              initialData: [],
              builder: (context, AsyncSnapshot snap) {
                //*Rebuilds its childer whenever a new value gets emited by the stream
                List slideList = snap.data.toList(); //! Convert AsynSnapshot into List
                print("Number of all items:" + slideList.length.toString());
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                } else {
                  return Container(
                    child: PageView.builder(
                      onPageChanged: (num) {
                        print("Current index: " + num.toString());
                      },
                      controller: itemView, //!Pass PageView controller
                      scrollDirection: Axis.horizontal,
                      itemCount: slideList.length, //!Število elementov je dolžina lista
                      itemBuilder: (context, int currentIndex) {
                        //!Build current facing item
                        bool active = (currentIndex == current_page);
                        //print(active.toString());
                        print("Trenutni index: " +
                            currentIndex.toString() +
                            " Trenutna stran: " +
                            current_page.toString());
                        //?(Lastnosti izdelka kot Map, bool trenutno aktiven, trenutni facing element)
                        return buildProductListPage(
                            slideList[currentIndex], active, currentIndex);
                      },
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.9 * 0.12,
            child: InkWell(
              onTap: () {
                controller.animateTo(500.0,
                    curve: Curves.linear, duration: Duration(milliseconds: 500));
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
                        textStyle:
                            TextStyle(fontSize: 35.0, fontFamily: "MadeEvolveSans"),
                        textAlign: TextAlign.center,
                        alignment: AlignmentDirectional.topStart //! or Alignment.topLeft
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 34,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //!Build list view of products
  buildProductListPage(Map data, bool active, var index) {
    final double blur = active ? 5 : 0;
    final double offset = active ? 2 : 0;
    final double top = active ? 30 : 200;
    final double iconSize = active ? 50 : 0;
    final String ime = data['file_name'];
    final String path = "${dir.path}/$ime";
    print(path);
    return Expanded(
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width * 0.5,
        duration: Duration(milliseconds: 1200),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: top, bottom: 10, right: 15, left: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            image: DecorationImage(
                fit: BoxFit.cover, image: CachedNetworkImageProvider(data['slika'])),
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
                      if (selectedItems.containsKey(data['ime'])) {
                        selectedItems.update(data['ime'], (dynamic val) => ++val);
                      } else {
                        selectedItems[data['ime']] = 1;
                      }
                      print(selectedItems);
                    });
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: WHITE,
                    size: iconSize,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Text(
                  (selectedItems[data['ime']] == 0 || selectedItems[data['ime']] == null)
                      ? " "
                      : selectedItems[data['ime']].toString(),
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
                      if (selectedItems.containsKey(data['ime'])) {
                        selectedItems.update(data['ime'], (dynamic val) => --val);
                        if (selectedItems[data['ime']] == 0) {
                          selectedItems.remove(data['ime']);
                        }
                      }
                      print(selectedItems);
                    });
                  },
                  icon: Icon(
                    Icons.do_not_disturb_on,
                    color: WHITE,
                    size: iconSize,
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
  Container buildBonusCounter(BuildContext context) => Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height * 0.1,
        child: ListView.builder(
          itemCount: selectedItems.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
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
            );
          },
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
                                    var list = selectedItems.keys.toList();
                                    if (list.length == 0) {
                                      return null;
                                    } else {
                                      return new OrderItem(
                                        selectedItems: selectedItems,
                                        ime_jogurta: list[position],
                                        iconsMap: iconsCached,
                                        slikeMap: slikeMap,
                                      );
                                    }
                                  },
                                  itemCount: selectedItems.length,
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
                          selectedItems.clear();
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

  void showInSnackBar(String value) {
    //!Pokaži sporočilo po opravljenem naročilu
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

  //!AssetImage assetImage(var n) => AssetImage(slikeMap[n]);   Icon Yogurt
  AssetImage assetImage(var n) => AssetImage("assets/breskev.jpg");
}

class ItemSlideshow extends StatefulWidget {
  createState() => ItemSlideshowState();
}

class ItemSlideshowState extends State<ItemSlideshow> {
  final PageController ctrl = PageController(viewportFraction: 0.7);
  final Firestore fireInstance = Firestore.instance;
  Stream slides;
  String activeTag = 'available';
  int currentPage = 0;
  Directory dir = Directory.systemTemp;
  var myDir;
  var slikeCached = {
    'Breskev': '/data/user/0/com.example.yogurt/code_cache/marelica.jpg',
    'Jagoda': '/data/user/0/com.example.yogurt/code_cache/jagoda.jpg',
    'Vanilija Coko': '/data/user/0/com.example.yogurt/code_cache/vanilija_coko.jpg'
  };

  @override
  void initState() {
    // TODO: implement initState
    queryYogurts();
    myDir = new Directory(dir.path);
    ctrl.addListener(() {
      int next = ctrl.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: slides,
      initialData: [],
      builder: (context, AsyncSnapshot snap) {
        List slideList = snap.data.toList();

        return PageView.builder(
          controller: ctrl,
          itemCount: slideList.length + 1,
          itemBuilder: (context, int currentIdx) {
            if (currentIdx == 0) {
              return _buildTagPage();
            } else if (slideList.length >= currentIdx) {
              bool active = currentIdx == currentPage;
              return _buildStoryPage(slideList[currentIdx - 1], active);
            }
          },
        );
      },
    );
  }

  Stream queryYogurts() {
    //!Fetch items
    try {
      Query query =
          fireInstance.collection('current_items').where("available", isEqualTo: true);
      //!Filter available izdelke
      //*QuerySnapshot contains zero or more QueryDocumentSnapshot objects representing the results of a query
      slides = query.snapshots().map((list) {
        //!Convert stream to map on the fly ->
        return list.documents.map((doc) {
          //*For every document
          return doc.data; //*Data from every document
        });
      });
    } catch (e) {
      print("Got error: ${e.error}");
    }
  }

  _buildTagPage() {}

  _buildStoryPage(Map data, bool active) {
    final double blur = active ? 30 : 0;
    final double offset = active ? 15 : 5;
    final double top = active ? 150 : 200;
    final double iconSize = active ? 50 : 0;

    String ime = data['ime'];
    String path = slikeCached[ime];

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('/data/user/0/com.example.yogurt/code_cache/marelica.jpg'),
          ),
          boxShadow: [
            BoxShadow(
                color: THEME_COLOR, blurRadius: blur, offset: Offset(offset, offset))
          ]),
    );
  }
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
  final FirebaseUser user;
  const OrdersIcon({Key key, @required this.user}) : super(key: key);

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
String showQuantity(ime_jogurta, Map selectedItems) {
  if (selectedItems.containsKey(ime_jogurta)) {
    return selectedItems[ime_jogurta].toString();
  }
}

//!Izdelek prikazan na CartScreen-u (Košarici)
class OrderItem extends StatelessWidget {
  final Map selectedItems;
  final String ime_jogurta;
  final Map iconsMap;
  final Map slikeMap;

  const OrderItem(
      {Key key,
      @required this.selectedItems,
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
                      (selectedItems[ime_jogurta] * 1.4).toStringAsFixed(2) + "€",
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
                    "Qty:  " + selectedItems[ime_jogurta].toString(),
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
