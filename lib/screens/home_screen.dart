import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jain_metals/components/category_card.dart';
import 'package:jain_metals/components/getItemDetails.dart';
import 'package:jain_metals/components/item_card.dart';
import 'package:url_launcher/url_launcher.dart';

String currentSelectedCategory = "Home";

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  final bool edit;
  HomeScreen(this.edit);
  @override
  _HomeScreenState createState() => _HomeScreenState(edit);
}

class _HomeScreenState extends State<HomeScreen> {
  //TODO:received data

  final ValueNotifier<bool> admin = ValueNotifier<bool>(false);
  final bool edit;
  _HomeScreenState(this.edit);
  int getItemCount(double aspectRatio) {
    int item = 4;
    if (aspectRatio < 0.55)
      item = 1;
    else if (aspectRatio < 1)
      item = 2;
    else if (aspectRatio < 1.5)
      item = 3;
    else if (aspectRatio > 2) item = 5;
    return item;
  }

  FirebaseApp app;
  @override
  void initState() {
    admin.addListener(() {});
    admin.value = edit;

    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    admin.notifyListeners();
    super.initState();
    initialize();
    getCategories();
  }

  List<CategoryCard> categoryCards = [];
  void getCategories() {
    for (var i = 0; i < categories.length + 1; i++) {
      CategoryCard categoryCard;
      if (i == 0)
        categoryCard = CategoryCard("Home", admin.value);
      else
        categoryCard = CategoryCard(categories[i - 1], admin.value);

      categoryCards.add(categoryCard);
    }
  }

  Future<void> initialize() async {
    app = await Firebase.initializeApp().whenComplete(() => setState(() {}));
  }

  List<ItemCard> allItemCard = [];
  List<ItemCard> currentItemCard = [];

  List<String> categories = [
    "Buddha Idol",
    "Ganesha Idol",
    "Lakshmi",
    "Saraswati",
    "Radha Krishna",
    "Durga",
    "Cow and Calf",
    "Wall Hanging",
    "Home Decor",
    "Urli",
    "Bronze Statue",
    "Copper",
    "Brass",
    "Others",
  ];
  @override
  Widget build(BuildContext context) {
    String title = 'Jain Metals';
    String address =
        "Gokula 1st Stage, Nanjappa Reddy Colony, Mathikere, Bengaluru, Karnataka - 560054";
    String contact = '7975538231';
    var instaUrl = 'https://www.instagram.com/jainmetals/';
    var googleMapUrl = 'https://g.page/jainmetalsstore?share';
    var whatsappUrl =
        'https://wa.me/91$contact?text=Hi.I had a query for a product.';

    Future<void> _launchInBrowser(String url) async {
      if (await canLaunch(url)) {
        await launch(
          url,
          forceSafariVC: false,
          forceWebView: false,
          headers: <String, String>{'my_header_key': 'my_header_value'},
        );
      } else {
        throw 'Could not launch $url';
      }
    }

    Future<void> _makePhoneCall(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    String user = "";
    String password = "";
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    final emailField = TextField(
      obscureText: false,
      style: style,
      onChanged: (text) {
        user = text;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "User Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      style: style,
      onChanged: (text) {
        password = text;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    showAlertDialog(BuildContext context) {
      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Wrong Details"),
        content: Text("Check your credentials"),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (user.toLowerCase() == "vivek" && password == "vivek@123")
            setState(() {
              if (admin.value == false) {
                admin.value = true;
                // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                admin.notifyListeners();
              }

              // Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(admin.value)));
            });
          else {
            showAlertDialog(context);
          }

          setState(() {});
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          floatingActionButton: ValueListenableBuilder<bool>(
              valueListenable: admin,
              builder: (BuildContext context, bool value, Widget child) {
                return (value)
                    ? FloatingActionButton(
                        child: Center(
                          child: Text(
                            "+",
                            style: TextStyle(fontSize: 35),
                          ),
                        ),
                        tooltip: "Add Item",
                        backgroundColor: Color(0xfff25f4c),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return GetItemDetails(
                                    app: app,
                                    dimension: null,
                                    category: categories[0],
                                    price: null,
                                    weight: null,
                                    description: null,
                                    name: null,
                                    docRef: null,
                                    edit: false);
                              });
                        })
                    : FloatingActionButton(
                        child: Center(child: Icon(Icons.call)),
                        tooltip: "Call us",
                        backgroundColor: Color(0xfff25f4c),
                        onPressed: () {
                          _makePhoneCall('tel:$contact');
                        });
              }),
          backgroundColor: Color(0xff0f0e17),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    padding: EdgeInsets.only(top: 100),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0, 0.6, 0.95],
                        colors: [
                          Color(0xfff25f4c),
                          Color(0xffff8906),
                          Color(0xfffffffe)
                        ],
                      ),
                    ),
                    child: Stack(children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: TextButton(
                          onPressed: (admin.value)
                              ? () {}
                              : () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Login"),
                                        content: Container(
                                          height: 250,
                                          width: 250,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              emailField,
                                              SizedBox(height: 25.0),
                                              passwordField,
                                              SizedBox(
                                                height: 35.0,
                                              ),
                                              loginButton,
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                          child: (kIsWeb)
                              ? Image.network(
                                  'https://firebasestorage.googleapis.com/v0/b/jainmetals-b875f.appspot.com/o/images%2Fjm_logo.jpeg?alt=media&token=f1da3bf9-3a7a-463c-94b5-61d36168da19',
                                  // 'http://lh3.googleusercontent.com/kOMaLghjP6cEOsrlVdVMS7ZWORdZUuS8g1NC5V-HsLBc2neZBObYQDuA8YuKnSjKxPa2mTTdcLQRXq4Acu2ERdnSvg',
                                  height: 80,
                                  width: 40,
                                  fit: BoxFit.fitWidth,
                                )
                              : Image.asset(
                                  'assets/jm_logo.jpeg',
                                  height: 80,
                                  width: 40,
                                  fit: BoxFit.fitWidth,
                                ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 35.0, bottom: 8),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color(0xfffffffe),
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    ])),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Shop by Category",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  height: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    width: 500,
                    height: MediaQuery.of(context).size.height + 400,
                    child: GestureDetector(
                      onTap: () async {
                        await Future.delayed(new Duration(seconds: 1), () {
                          setState(() {});
                        });
                        await Future.delayed(new Duration(seconds: 2), () {
                          setState(() {});
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: categoryCards,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  child: Text(
                    "Refund and Exchange",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          titleTextStyle: style.copyWith(
                              color: Color(0xfff25f4c),
                              fontWeight: FontWeight.w700),
                          title: Center(
                            child: Text(
                              "Refund and Exchange",
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: Container(
                              child: Text(
                                "Jain Metals is currently shipping all over India and select areas overseas.\n \nAvailable products will be shipped within 24 hours and made to order products will take 7-10 to make.\n\nIf the order is returned due to incorrect address or customer unavailability then customer has to pay for reshipping.\n\nExchange will be processed only for damaged goods. Proof of unboxing with a video should be provided.\n\nRefund will be initiated only if the product is received at our shop.",
                                softWrap: true,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Montserrat",
                                    fontSize: 15),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "OKAY",
                                  style: TextStyle(
                                    color: Color(0xffff8906),
                                  ),
                                ))
                          ],
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  height: 1,
                ),
              ],
            ),
          ),
          body: CustomScrollView(
            // physics:
            //     BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Color(0xfffffffe),
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    // children: (kIsWeb)
                    //     ? [
                    //         Row(
                    //           children: [
                    //             Flexible(
                    //                flex: 1,
                    //               child: TextButton(
                    //                 onPressed: () {
                    //                   showDialog<void>(
                    //                     context: context,
                    //                     builder: (BuildContext context) {
                    //                       return AlertDialog(
                    //                         title: Text("Login"),
                    //                         content: Container(
                    //                           height: 250,
                    //                           width: 250,
                    //                           child: Column(
                    //                             crossAxisAlignment:
                    //                                 CrossAxisAlignment.center,
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.center,
                    //                             children: <Widget>[
                    //                               emailField,
                    //                               SizedBox(height: 25.0),
                    //                               passwordField,
                    //                               SizedBox(
                    //                                 height: 35.0,
                    //                               ),
                    //                               loginButton,
                    //                               SizedBox(
                    //                                 height: 15.0,
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       );
                    //                     },
                    //                   );
                    //                 },
                    //                 child: Image.network(
                    //                   'http://lh3.googleusercontent.com/kOMaLghjP6cEOsrlVdVMS7ZWORdZUuS8g1NC5V-HsLBc2neZBObYQDuA8YuKnSjKxPa2mTTdcLQRXq4Acu2ERdnSvg',
                    //                   height: 50,
                    //                   width: 50,
                    //                   fit: BoxFit.fill,
                    //                 ),
                    //               ),
                    //               //CircleAvatar(
                    //               //     radius: 18,
                    //               //     backgroundImage:
                    //               //         AssetImage('jm_logo.jpeg'))),
                    //             ),
                    //             Flexible(
                    //               flex: 5,
                    //               child: Text(
                    //                 title,
                    //                 overflow: TextOverflow.ellipsis,
                    //                 style: TextStyle(
                    //                     color: Color(0xfffffffe),
                    //                     fontSize: 35,
                    //                     fontWeight: FontWeight.w900),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         TextButton(
                    //           child: Text(
                    //             address,
                    //             maxLines: 1,
                    //             overflow: TextOverflow.ellipsis,
                    //             style: TextStyle(
                    //                 color: Color(0xfffffffe),
                    //                 fontSize: 15,
                    //                 fontWeight: FontWeight.w500),
                    //           ),
                    //           onPressed: () {
                    //             _launchInBrowser(googleMapUrl);
                    //           },
                    //         ),
                    //         TextButton(
                    //           child: Text(
                    //             "Call @ " + contact,
                    //             maxLines: 1,
                    //             style: TextStyle(
                    //                 color: Color(0xfffffffe),
                    //                 fontSize: 15,
                    //                 fontWeight: FontWeight.w500),
                    //           ),
                    //           onPressed: () {
                    //             _makePhoneCall('tel:$contact');
                    //           },
                    //         ),
                    //       ]
                    //     :
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Expanded(
                          //   flex: 2,
                          //   child: TextButton(
                          //     onPressed: () {
                          //       showDialog<void>(
                          //         context: context,
                          //         builder: (BuildContext context) {
                          //           return AlertDialog(
                          //             title: Text("Login"),
                          //             content: Container(
                          //               height: 250,
                          //               width: 250,
                          //               child: Column(
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.center,
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.center,
                          //                 children: <Widget>[
                          //                   emailField,
                          //                   SizedBox(height: 25.0),
                          //                   passwordField,
                          //                   SizedBox(
                          //                     height: 35.0,
                          //                   ),
                          //                   loginButton,
                          //                   SizedBox(
                          //                     height: 15.0,
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //       );
                          //     },
                          //     child: (kIsWeb)
                          //         ? Image.network(
                          //             'https://firebasestorage.googleapis.com/v0/b/jainmetals-b875f.appspot.com/o/images%2Fjm_logo.jpeg?alt=media&token=f1da3bf9-3a7a-463c-94b5-61d36168da19',
                          //             // 'http://lh3.googleusercontent.com/kOMaLghjP6cEOsrlVdVMS7ZWORdZUuS8g1NC5V-HsLBc2neZBObYQDuA8YuKnSjKxPa2mTTdcLQRXq4Acu2ERdnSvg',
                          //             height: 80,
                          //             width: 80,
                          //             fit: BoxFit.contain,
                          //           )
                          //         : Image.asset(
                          //             'assets/jm_logo.jpeg',
                          //             height: 80,
                          //             width: 80,
                          //             fit: BoxFit.contain,
                          //           ),
                          //   ),
                          //   //CircleAvatar(
                          //   //     radius: 18,
                          //   //     backgroundImage:
                          //   //         AssetImage('jm_logo.jpeg'))),
                          // ),
                          // Flexible(
                          //     flex: 1,
                          //     child: SizedBox(
                          //       width: 5,
                          //     )),
                          Expanded(
                            flex: 7,
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color(0xfffffffe),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                floating: true,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0, 0.4, 0.8],
                      colors: [
                        Color(0xfff25f4c),
                        Color(0xffff8906),
                        Color(0xfffffffe)
                      ],
                    ),
                  ),
                ),
                // expandedHeight: 120,
                toolbarHeight: 80,
                // toolbarHeight: 150,
                // collapsedHeight: 100,
                actions: [
                  Flexible(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                          icon: Image.network(
                            'https://cdn4.iconfinder.com/data/icons/social-messaging-ui-color-shapes-2-free/128/social-instagram-new-square1-512.png',
                            // 'data:image/jpeg;base64,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',
                            height: 50,
                            width: 50,
                            fit: BoxFit.contain,
                          ),
                          splashRadius: 0.1,
                          tooltip: 'Instagram',
                          onPressed: () {
                            _launchInBrowser(instaUrl);
                          }),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                          icon: Image.network(
                            'https://cdn4.iconfinder.com/data/icons/miu-square-flat-social/60/whatsapp-square-social-media-512.png',
                            height: 50,
                            width: 50,
                            fit: BoxFit.contain,
                          ),
                          splashRadius: 0.1,
                          tooltip: 'WhatsApp',
                          onPressed: () {
                            _launchInBrowser(whatsappUrl);
                          }),
                    ),
                  )
                ],
              ),
              StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection('item').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          childCount: 1,
                        ),
                      );
                    }
                    // else {
                    // print(snapshot.data.docs.first);

                    final List<DocumentSnapshot> documents = snapshot.data.docs;
                    allItemCard.clear();

                    for (var doc in documents) {
                      final item = ItemCard(
                        name: doc['name'],
                        description: doc['description'],
                        imageUrl: doc['imageUrl'],
                        price: doc['price'],
                        weight: doc['weight'],
                        dimension: doc['dimension'],
                        category: doc['category'],
                        admin: admin.value,
                        docRef: doc.reference,
                      );

                      allItemCard.add(item);

                      if (currentSelectedCategory == "Home") {
                        currentItemCard.clear();
                        currentItemCard = List.of(allItemCard);
                      } else {
                        currentItemCard.clear();
                        for (var i in allItemCard) {
                          if (currentSelectedCategory == i.category)
                            currentItemCard.add(i);
                        }
                      }
                    }

                    // return SliverGrid.count(
                    //     crossAxisCount:
                    //         getItemCount(MediaQuery.of(context).size.aspectRatio),
                    //     // (kIsWeb)
                    //     //     ? 4
                    //     //     : (Platform.isAndroid || Platform.isIOS)
                    //     //         ? 2
                    //     //         : 4,
                    //     children: ListView());

                    return SliverGrid.count(
                      mainAxisSpacing: 0,
                      childAspectRatio: (kIsWeb) ? 0.75 : 1.2,
                      crossAxisCount:
                          getItemCount(MediaQuery.of(context).size.aspectRatio),
                      children: currentItemCard,
                    );
                  }),
              //SliverGrid.count(
              //
              //   // (kIsWeb)
              //   //     ? 4
              //   //     : (Platform.isAndroid || Platform.isIOS)
              //   //         ? 2
              //   //         : 4,
              //   children: List.generate(
              //     10,
              //     (index) {
              //       return Center(
              //         child: ItemCard(),
              //       );
              //     },
              //   ),
              // ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  // height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(
                    //   color: Colors.red[500],
                    // ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: TextButton(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Find us at: " + address,
                            maxLines: 2,
                            style: style.copyWith(
                              color: Color(0xffff8906),
                            ),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _launchInBrowser(googleMapUrl);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
