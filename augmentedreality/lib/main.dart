import 'dart:async';
import 'package:flutter/cupertino.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:bottom_navy_bar/bottom_navy_bar.dart";
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.black.withOpacity(0.7),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      title: "AungmentedR",
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  final String? payload;
  const MyHome({Key? key, this.payload}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
  )..repeat(reverse: true);
  late final pos = Tween<Offset>(
    begin: Offset.zero,
    end: Offset(0.05, 0.1),
  ).animate(controller);

  late final pos2 = Tween<Offset>(
    begin: Offset(0, 0),
    end: Offset(0.05, -0.05),
  ).animate(controller);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<dynamic> onSelectNotification(String? payload) =>
      //j'utilise => au lieu de {} pour un probleme de null safety
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MyHome(payload: payload);
          },
        ),
      );

  shownotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("id", "poyochanel", "aller sur l'appli");
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
      presentSound: true,
      subtitle: "poyoAppli",
      presentAlert: true,
    );
    NotificationDetails platform = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      0, "PoyoNotif", "voir ahaha", platform, // NotificationDetails
      payload: "hi poyo payload",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Augmented Reality"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SlideTransition(
                position: pos,
                child: Container(
                  padding: EdgeInsets.only(right: 90),
                  child: Image.asset("asset/img (2).png"),
                ),
              ),
              SizedBox(
                height: 90,
              ),
              InkWell(
                onTap: shownotification,
                child: SlideTransition(
                  position: pos2,
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Image.asset("asset/img (1).png"),
                  ),
                ),
              ),
              SizedBox(
                height: 90,
              ),
              ClipPath(
                clipper: ClipperMy(),
                child: Container(
                  color: Colors.teal,
                  width: double.infinity,
                  height: 200,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// CLIPPATH
class ClipperMy extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height);
    // path.quadraticBezierTo(
    //     size.width / 2, size.height / 2, size.width, size.height);

    path.lineTo(size.width, size.height / 3.5);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
// je lance actuellement avec flutter run --no-sound-null-safety a cause d'un probleme de null safety
