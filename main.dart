// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:tezdeneeme/canli_yayin.dart';
import 'firebase_options.dart';
import "package:flutter_colorpicker/flutter_colorpicker.dart";
import "package:numberpicker/numberpicker.dart";
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

final _messageStreamController = BehaviorSubject<RemoteMessage>();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }
  String? token = await messaging.getToken();

  if (kDebugMode) {
    print('Registration Token=$token');
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    _messageStreamController.sink.add(message);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ANASAYFA',
      home: Scaffold(
          appBar: AppBar(
            title: Center(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
              Container(
                  height: 120,
                  width: 60,
                  child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "lib/ohülogo.png",
                      ))),Center(child: 
              Text('AKILLI EV SİSTEMİ')), Container(
                  height: 50,
                  width: 78,
                  child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "lib/turkbayragi.png",
                      )))
            ])),
          ),
          body: AnaSayfa()),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}
// silinecek

class _AnaSayfaState extends State<AnaSayfa> {
  String _lastMessage = "1";
  _MyHomePageState() {
    _messageStreamController.listen((message) {
      setState(() {
        if (message.notification != null) {
          _lastMessage = 'Received a notification message:'
              '\nTitle=${message.notification?.title},'
              '\nBody=${message.notification?.body},'
              '\nData=${message.data}';
        } else {
          _lastMessage = 'Received a data message: ${message.data}';
        }
      });
    });
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Evprojesi').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection("Evprojesi");
  List<Widget> emirisim = <Widget>[
    Text('AC', style: TextStyle(height: 5, fontSize: 10)),
    Text('KAPA', style: TextStyle(height: 5, fontSize: 10)),
  ];

  var ISIK1 = List<bool>.empty();
  var fan1 = List<bool>.empty();
  var sumotor1 = List<bool>.empty();
  var panjur1 = List<bool>.empty();
  var yem1 = List<bool>.empty();
  var garaj1 = List<bool>.empty();

  //ISIK AYALARI
  Color ISIKRENGI = Color.fromARGB(255, 255, 255, 255);
  void renksecimi(Color color) {
    setState(() {
      ISIKRENGI = color;
      /* ref.doc("31dza2Q4I8FyjVOfeULQ").update({"RENK": ISIKRENGI.toString()}); */
    });
  }

  int ISIsecimi = 20;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Bir hata olustu');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Yukleniyor");
        }
        // databaseden gelen veriler sözlük olarak verilere işlenir veriler["YEM"]

        final veriler = snapshot.data!.docs[0];

        komutlar(String veriisim, var listeisim) {
          var deger1 = veriler[veriisim];
          var listesonuc = listeisim;

          if (deger1 == true) {
            listesonuc = <bool>[true, false];
          } else {
            listesonuc = <bool>[false, true];
          }
          return listesonuc;
        }

        return SingleChildScrollView(
            child: Center(
                child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: Center(
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("ISIK"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ToggleButtons(
                                      direction: Axis.horizontal,
                                      onPressed: (int index) {
                                        setState(() {
                                          if (index == 0) {
                                            ref
                                                .doc("31dza2Q4I8FyjVOfeULQ")
                                                .update({"ISIK": true});
                                          } else {
                                            ref
                                                .doc("31dza2Q4I8FyjVOfeULQ")
                                                .update({"ISIK": false});
                                          }
                                        });
                                      },
                                      children: emirisim,
                                      isSelected: komutlar("ISIK", ISIK1)),
                                ],
                              ),
                              OutlinedButton(
                                  onPressed: () => ISIKRENK(context),
                                  child: const Text("renk seçimi"))
                            ]),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("PANJUR"),
                            SizedBox(
                              height: 10,
                            ),
                            ToggleButtons(
                                direction: Axis.horizontal,
                                onPressed: (int index) {
                                  setState(() {
                                    if (index == 0) {
                                      ref
                                          .doc("31dza2Q4I8FyjVOfeULQ")
                                          .update({"PANJUR": true});
                                    } else {
                                      ref
                                          .doc("31dza2Q4I8FyjVOfeULQ")
                                          .update({"PANJUR": false});
                                    }
                                  });
                                },
                                children: emirisim,
                                isSelected: komutlar("PANJUR", panjur1))
                          ],
                        ),
                      ),
                    )),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: Center(
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("FAN"),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  ToggleButtons(
                                      direction: Axis.horizontal,
                                      onPressed: (int index) {
                                        setState(() {
                                          if (index == 0) {
                                            ref
                                                .doc("31dza2Q4I8FyjVOfeULQ")
                                                .update({"FAN": true});
                                          } else {
                                            ref
                                                .doc("31dza2Q4I8FyjVOfeULQ")
                                                .update({"FAN": false});
                                          }
                                        });
                                      },
                                      children: emirisim,
                                      isSelected: komutlar("FAN", fan1)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Column(children: [
                                    Text(
                                      "ODA SICAKLIĞI : ${veriler["ISIDEGER"]} \u2103 ",
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(fontSizeFactor: 0.75),
                                    ),
                                    OutlinedButton(
                                        onPressed: () => SICAKLIK(),
                                        child: const Text("ISI AYARI")),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "SECİLEN ISI DEĞERİ : ${veriler["SECILENISI"]} \u2103 ",
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(fontSizeFactor: 0.75),
                                    )
                                  ])
                                ],
                              )
                            ]),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      width: 100,
                      height: 90,
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: Center(
                        child: IconButton(
                            iconSize: 40,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => canli_yayin()),
                              );
                            },
                            icon: Icon(Icons.videocam)),
                      ),
                    )),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("HAYVAN YEMİ"),
                        SizedBox(
                          height: 10,
                        ),
                        ToggleButtons(
                            direction: Axis.horizontal,
                            onPressed: (int index) {
                              setState(() {
                                if (index == 0) {
                                  ref
                                      .doc("31dza2Q4I8FyjVOfeULQ")
                                      .update({"YEM": true});
                                } else {
                                  ref
                                      .doc("31dza2Q4I8FyjVOfeULQ")
                                      .update({"YEM": false});
                                }
                              });
                            },
                            children: emirisim,
                            isSelected: komutlar("YEM", yem1))
                      ],
                    ),
                  ),
                ),
                Container(
                    height: 100,
                    width: 220,
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("SON YEMLEME ZAMANI"),
                            Text((veriler["YEMT"] as Timestamp)
                                .toDate()
                                .toString())
                          ]),
                    ))
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(" SU POMPASI "),
                        SizedBox(
                          height: 10,
                        ),
                        ToggleButtons(
                            direction: Axis.horizontal,
                            onPressed: (int index) {
                              setState(() {
                                if (index == 0) {
                                  ref
                                      .doc("31dza2Q4I8FyjVOfeULQ")
                                      .update({"SUMOTOR": true});
                                } else {
                                  ref
                                      .doc("31dza2Q4I8FyjVOfeULQ")
                                      .update({"SUMOTOR": false});
                                }
                              });
                            },
                            children: emirisim,
                            isSelected: komutlar("SUMOTOR", sumotor1))
                      ],
                    ),
                  ),
                ),
                Container(
                    height: 100,
                    width: 220,
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("SON SULAMA ZAMANI"),
                            Text((veriler["SUMOTORT"] as Timestamp)
                                .toDate()
                                .toString())
                          ]),
                    )),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("GARAJ KAPISI"),
                    SizedBox(
                      height: 10,
                    ),
                    ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) {
                          setState(() {
                            if (index == 0) {
                              ref
                                  .doc("31dza2Q4I8FyjVOfeULQ")
                                  .update({"GARAJ": true});
                            } else {
                              ref
                                  .doc("31dza2Q4I8FyjVOfeULQ")
                                  .update({"GARAJ": false});
                            }
                          });
                        },
                        children: emirisim,
                        isSelected: komutlar("GARAJ", garaj1))
                  ],
                ),
              ),
            ),
          ],
        )));
      },
    );
  }

  Future<void> ISIKRENK(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('IŞIK RENGİ SEÇİNİZ'),
          content: SingleChildScrollView(
            child: HueRingPicker(
                pickerColor: ISIKRENGI, onColorChanged: renksecimi),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  ref
                      .doc("31dza2Q4I8FyjVOfeULQ")
                      .update({"RENK": ISIKRENGI.toString()});
                  Navigator.of(context).pop();
                },
                child: Text("ONAY"))
          ],
        );
      },
    );
  }

  void SICAKLIK() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("ISI DEGERİ SECİNİZ"),
            content: StatefulBuilder(builder: (context, setState) {
              return NumberPicker(
                selectedTextStyle: TextStyle(color: Colors.red),
                value: ISIsecimi,
                minValue: 1,
                maxValue: 40,
                onChanged: (value) => setState(() => ISIsecimi = value),
              );
            }),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  ref
                      .doc("31dza2Q4I8FyjVOfeULQ")
                      .update({"SECILENISI": ISIsecimi.toString()});
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
