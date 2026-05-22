import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'auth_screen.dart';

Future<String> getAccessToken() async {
  final serviceAccountJson = {
    "type": "service_account",
    "project_id": "notification-demo-cb536",
    "private_key_id": "d7f09ac43dc2fd8b1dbe667dc47916496d674630",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDPBdM01enQWAkw\nGvJ9BBKx8df9JWZqlDzYWbbBAVh4uRwvEeCSff/y8d5SvJd7pkhnyz7aBaLg2MP4\npdN6EwEOc7G9RIPQqWkU+0kHgOXAc50/6Jqd6LahmzfFnFrEKZ/ubNITMgnV00zf\nKZHEGQ6Y1QfWyrA2lKdd+RQFe+oDQv2G5791mVPNGUI3+VfkpbUmh6iW30ulcKZA\npUGhjZvpdFFhW9rumsN3tvfB5rStQ2Y/Xs6g4zSH2NgI3ZarclXiXdQUtbjrJYJW\ntZ7p9+qgo8/59JZvRNHPoL/JYBQJBwP4uGUwm0FvO21AgOEEDrDcXta64WPTvPXl\ns07xzEW/AgMBAAECgf8NelObHPzGk59a17ucZ/zPmO8hi/h0TTJTji5Xt761cq0N\nuMbmF/iR2IKg4FD8ZoGllZXXRoapch36vNEHzDTwEULWZPTaoNeL23rlrNPzCOkz\n6pt7rFWM2o4cT2bus8cLFAqZNVNumFMTiaFJIwMlmrjn7Z+LQ3eh++qnG2ogzB2z\nSpfBholOp4DMiiyKcdodVUfLPa7DCFaZZgjEIJnf6vIaPMVXX1daNG0dR9euGMel\ngy8L6xOKF/glR9GhARheX/QzkZeCSLwLH97nnHWrBLAUnSS2PLuPCDIlgsdQYYbw\nT0WfiI+HIDj3f2DCd8TVO8SBIEnEHgMGKDpbdhECgYEA8So8gJX9VdzcoTTBHxG+\njeyL6K2smm6+IvF5LXxUR5a28w/lxroKhc8GIeUjCdnxhd4vDtISg7o8IXuVnV9W\nRS9PB4iRzcSIKbkHiluE6nrq5U+CYoNr1Wpq1nijZ+vzsuSdpOQye90FBzY2pPO/\n7W2Krq+BlA5QKY5ZaPY0eb0CgYEA28HubDnzqXeMV31w9QbW4TIFCsJ4LAz9xmex\ntXSpcwMXKs6mGq0+E85iUPW/NatKz9eTor3jSH4znmWacHKqivijccasNsIeufwB\nUYwq2ATH7kSIXP+Z1pHJCmm4s+yLhH0DCQKZJejyjZO1lEXgPtASnLX3emMJz0qE\nG4V8zysCgYEAhFG+PHcPNqslyrVdOKTNvqUI5rNTvrAAVr/S0ugifdztqFMSqYSt\n/VjnbnWAUglogSC1BRax3eCy2VQrdNs4RGF+pQ2Dojiw1OOWhY1NUjH667JCQbcF\n1WS8Fcy/K2fEoGTbMfuaz2cnORu/w6WRqr2tl8bn+8oWpZZa7EIZ7KkCgYEAgFmL\nLFDInHEDWdIdGC8vb4WsZjVgxLGtwqSrqUSC93aVoF3jq+8FM8I1r/1n+SubXTsW\nslVfmuaCtX+4LPb73oELzRbxXGYSViP2jS9lkpdwQhxq3I44xpaNKfTHeOauMepl\nzGxlEDw29jOQORJ6v5T9WeP5r9SKVTS7ZeuYEtMCgYEAykACQChCicRTMhnGrJwh\nrovCH3sOYUGwYkIX6WBUZVAqaIzUb0aFsjrrCmXrXkByrsAdPCSzHgQk1/uSv6sC\nNWIuJXtqdigdBnktCCxYZdPLV5Korgo8ibXh6ELEmHfTIFKtH7toqt29MVsm+Hmf\nLD9ceMzdjs5ZBz8+SyFx9vg=\n-----END PRIVATE KEY-----\n",
    "client_email":
        "firebase-adminsdk-fbsvc@notification-demo-cb536.iam.gserviceaccount.com",
    "client_id": "102387415895500247682",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40notification-demo-cb536.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com",
  };

  List<String> scopes = ["https://www.googleapis.com/auth/firebase.messaging"];

  http.Client client = await auth.clientViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
  );

  auth.AccessCredentials credentials = await auth
      .obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client,
      );
  client.close();
  return credentials.accessToken.data;
}

Future<void> sendNotification({
  // ignore: strict_top_level_inference
  required token,
  required String title,
  required String body,
}) async {
  final String serverToken = await getAccessToken();
  debugPrint("ServerToken $serverToken");

  final Uri url = Uri.parse(
    "http://fcm.googleapis.com/v1/projects/notification-demo-c82e6/messages:send",
  );

  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $serverToken",
  };
  final bodyData = {
    "message": {
      "token": token,
      "notification": {"title": title, "body": body},
    },
  };
  try {
    final responce = await http.post(
      url,
      headers: headers,
      body: jsonEncode(bodyData),
    );

    if (responce.statusCode == 200) {
      debugPrint("----notification sent successfully ! ");
    } else {
      debugPrint("failed to sent notification");
    }
  } catch (e) {
    debugPrint("- error  sending notification:$e");
  }
}


  

class SendNotificationScreen extends StatefulWidget {
  const SendNotificationScreen({super.key});

  @override
  State<SendNotificationScreen> createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final TextEditingController messageController = TextEditingController();
  Future<void> handleSendNotification() async{
    if(selectedUserId != null && messageController.text.trim().isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Please Select a user and enter message")));
      return;
    }
    final doc = await FirebaseFirestore.instance.collection('usersname').doc(selectedUserId).get();
    final token = doc['fcmToken'];
    final name =doc['username'] ?? 'user';
    if(token != null){
     await sendNotification(token: token, title: "$name", body: messageController.text);
    } 
  }
  String?  selectedUserId;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Notification"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              }
            },
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter the Message",
              ),
            ),
            SizedBox(height: 10,),
            //dropdown button
            StreamBuilder(stream: FirebaseFirestore.instance.collection('usersname').snapshots(),
 builder: (context, snapshot) {
  if(!snapshot.hasData) return CircularProgressIndicator();
  final user = snapshot.data!.docs;

  return DropdownButtonFormField(items: user.map((doc){
    return DropdownMenuItem<String> (
      value: doc.id,
      child: Text(doc.data()["username"] ?? "null"),

    );
  }).toList(), onChanged: (value) {
    setState(() {
      selectedUserId = value;
    });


  },
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: "Select a Friend",
  ),
  );
 },
 ),
 SizedBox(height: 20,),
 ElevatedButton(onPressed: handleSendNotification, child: Text("Send Notification"))

            
          ],
        ),
      ),
    );
  }
}
