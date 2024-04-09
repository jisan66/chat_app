import 'dart:convert';

import 'package:chat_app/modal/userInfo_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreDatabase {
  Future addUserInfo(UserInfoModal userInfo, String id) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .set((userInfo.toJson()));
  }

  Future<QuerySnapshot> getUserInfoByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .where('email', isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> searchUser(String userName) async{
    return await FirebaseFirestore.instance.collection("user").where("first_letter", isEqualTo: userName.substring(0,1)).get();
  }
}
