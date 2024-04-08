import 'dart:convert';

import 'package:chat_app/modal/userInfo_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FireStoreDatabase{
  Future addUserInfo(UserInfoModal userInfo, String id) async{
    return await FirebaseFirestore.instance.collection("user").doc(id).set((userInfo.toJson()));
  }
}