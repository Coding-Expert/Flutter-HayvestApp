import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/UI/CheckRegistration.dart';
import 'package:flutter_classifiedappclone/UI/Pages/LoginPage.dart';
import 'package:flutter_classifiedappclone/UI/Pages/NewLogin.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:graphql/client.dart' show Cache;
import 'dart:io';

class DecisionPage extends StatefulWidget {
  @override
  _DecisionPageState createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  String firebaseFCMToken = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    String phone = user == null ? "" : user.phoneNumber;
    final HttpLink _httplink =
        HttpLink(uri: "http://34.76.96.215:8000/graphql/");
    final Link _link = _httplink;
    final GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: _link,
    );
//    print("${user.uid}");
    final String query = '''
                {
                  membersPhone(phone: "$phone"){
                      id
                      uid
                      phoneNumber
                      fcmId
                  }
                }
                ''';
    final String userMutation = r'''
      mutation create_User($fcmId: String!, $uid: String!, $phoneNumber: String!){
        createUser(uid: $uid, fcmId: $fcmId, phoneNumber: $phoneNumber){
          member{
            id
            uid
            fcmId
            phoneNumber
          }
        }
      }
    ''';

    final String UpdateMutation = r''' 
      mutation($memberId: Int!, $phoneNumber: String, $uid: String, $fcmId: String ){
        updateUser(memberId: $memberId, fcmId: $fcmId, uid: $uid, phoneNumber: $phoneNumber){
          member{
            id
            phoneNumber
            uid
            fcmId
          }
        }
      }  
    ''';
    bool loggedin = user != null;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Query(
          options: QueryOptions(document: query),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {
            if (result.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (result.data == null) {
              print("Data is Null");
            } else {
              if (result.data['membersPhone'].length == 0) {
                _messaging.getToken().then((fcm) {
                  final MutationOptions options = MutationOptions(
                      document: userMutation,
                      variables: <String, dynamic>{
                        "uid": user.uid,
                        "fcmId": fcm,
                        "phoneNumber": user.phoneNumber
                      });
                  _client.mutate(options).then((result) {
                    if (result.loading) {
                      print("Loading");
                    }
                    if (result.errors != null) {
                      print(result.errors);
                    }
                    if (result.data != null) {
                      print(result.data);
                    }
                  });
                });
              }
            }
            _messaging.getToken().then((token) {
              print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
              print(token);
              print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
              MutationOptions updateOptions = MutationOptions(
                  document: UpdateMutation,
                  variables: <String, dynamic>{
                    "memberId": result.data["membersPhone"][0]["id"],
                    "fcmId": token,
                  });
              _client.mutate(updateOptions);
            });
            return new Center(
              child: loggedin ? CheckRegistration() : NewLogin(),
            );
          },
        ));
  }
}
