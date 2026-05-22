import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore  =FirebaseFirestore.instance;

Future<void> saveUserToken(String userId) async{
    final token = await FirebaseMessaging.instance.getToken();
    await _firestore.collection('usersname').doc(userId).set({
      "fcmToken": token
    }, SetOptions(merge: true));
  }
  //signup with email password and username
  Future<User?>signUp({
    required String username,
    required String email,
    required String password,
  })async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email:email,
        password:password,
      );
      User? user = result.user;

      if( user != null) {
        //save username in firestore
        await _firestore.collection('usersname').doc(user.uid).set({
          'uid' : user.uid,
          'username':username,
          'email': email,
          'createdAt': DateTime.now(),
        });
      await saveUserToken(user.uid);
      }
      return user;
    } on FirebaseAuthException catch(e){
      throw Exception(e.message);
    }
  }
  Future<User?> signIn({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveUserToken(result.user!.uid);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}

    

  

  
  
