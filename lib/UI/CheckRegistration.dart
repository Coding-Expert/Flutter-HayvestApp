import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/UI/FarmUI.dart';
import 'package:flutter_classifiedappclone/UI/Pages/Registration/RegistrationDecision.dart';
import 'package:flutter_classifiedappclone/UI/main_ui.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class CheckRegistration extends StatefulWidget {
  @override
  _CheckRegistrationState createState() => _CheckRegistrationState();
}

class _CheckRegistrationState extends State<CheckRegistration> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  String firebaseFCMToken = "";

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

  final String query = r""" 
                query get_user($phone: String!){
                  membersPhone(phone: $phone){
                    id
                    uid
                    phoneNumber
                    farms{
                      id
                    }
                    buyingProfile{
                      id
                      name
                      buyerChats{
                        id
                        partyA{
                          name
                        }
                        partyB{
                          name
                        }
                        docId
                      }
                    }
                  }
                } """;

  check_registered(String uid) async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final HttpLink _httplink = HttpLink(uri: "http://34.76.96.215:8000/graphql/");
    final Link _link = _httplink;
    final GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: _link,
    );
    var user = Provider.of<FirebaseUser>(context);
    return Query(
      options: QueryOptions(
          document: query, variables: <String, dynamic>{"phone": user.phoneNumber}),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.loading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[CircularProgressIndicator(),SizedBox(height: 30.0,), Text("Loading")],
            ),
          );
        }
        if (result.data == null) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.error,
                  color: Colors.redAccent,
                ),
                Text("Please Check your Internet Connection")
              ],
            ),
          );
        } else {
          print(result.data.data);
          if(result.data.data["membersPhone"].length == 0){
            print("Here");
            _messaging.getToken().then((fcm) {
              print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
              print(fcm);
              print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
              final MutationOptions options = MutationOptions(
                  document: userMutation,
                  variables: <String, dynamic>{
                    "uid": user.uid,
                    "fcmId": fcm,
                    "phoneNumber": user.phoneNumber
                  });
              _client.mutate(options).then((result){
                if(result.loading){
                  print("Loading");
                }
                if(result.errors != null){
                  print(result.errors);
                }
                if(result.data != null){
                  print(result.data);
                }
              });
            });
            return RegDecision();
          }
          var data = result.data["membersPhone"][0].data;
          if (data["farms"].length != 0) {
            return FarmUI(user.phoneNumber);
          }
          else if (data["buyingProfile"].length != 0) {
            return BuyerUI(data["buyingProfile"]);
          }else {
            return RegDecision();
          }
        }
      },
    );
  }
}
