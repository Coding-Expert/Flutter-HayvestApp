import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_classifiedappclone/Constants/constants.dart';
import 'package:flutter_classifiedappclone/UI/DecisionPage.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/splash_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';



void main() {
  final HttpLink httpLink = HttpLink(uri: "http://34.76.96.215:8000/graphql/");

  final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
          link: httpLink as Link,
          cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject)));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(providers: [
      StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged)
    ], child: GraphQLProvider(client: client, child: new MyApp())));
  });
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Classified App Clone',
      theme: ThemeData(primaryColor: Colors.orange[200]),
      routes: <String, WidgetBuilder>{
        MAIN_UI: (BuildContext context) => DecisionPage(),
        SPLASH_SCREEN: (BuildContext context) => AnimatedSplashScreen(),
      },
      initialRoute: SPLASH_SCREEN,
    );
  }
}
