import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:koto/const.dart';
import 'package:koto/pages/home.dart';
import 'package:koto/pages/news_det.dart';
import 'package:koto/pages/start.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uni_links/uni_links.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Uri? link;
  Future<void> initUniLinks() async {
    /*StreamSubscription _sub;*/
    try {
      final initialLink = await getInitialLink();
      /*_sub = linkStream.listen((String? link) {
        print(link);
      });*/
      if (initialLink != null) {
        final PendingDynamicLinkData? dynamicLink = await FirebaseDynamicLinks
            .instance
            .getDynamicLink(Uri.parse(initialLink.toString()));
        if (dynamicLink != null) {
          link = dynamicLink.link;
        }
      }
    } on FormatException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  await initUniLinks();

  runApp(MyApp(link: link));

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("eb9eaadf-fdf1-4c8b-ad2f-beed7118c8c3");
  // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
    try {
      final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks
          .instance
          .getDynamicLink(Uri.parse(result.notification.launchUrl.toString()));
      if (initialLink != null) {
        print("bildirimden gitti");
        Get.off(NewsDet(initialLink.link.toString()));
      }
    } catch (e) {
      print(e);
    }
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    // Will be called whenever the permission changes
    // (ie. user taps Allow on the permission prompt in iOS)
    print(changes);
  });
}

class MyApp extends StatelessWidget {
  final Uri? link;
  const MyApp({this.link, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Koto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: mainColor,
        accentColor: mainColor,
        primaryColorLight: mainColor,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Start(),
        '/start': (context) => const Start(),
        '/home': (context) => const Home(),
      },
    );
  }
}
