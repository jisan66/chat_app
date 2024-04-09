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

  Future<QuerySnapshot> searchUser(String userName) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .where("first_letter", isEqualTo: userName.substring(0, 1))
        .get();
  }

  createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomInfo) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfo);
    }
  }

  Future<void> addMessage(String chatRoomId, String messageId, Map<String, dynamic> messageInfo) async {
    try {
      await FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(chatRoomId)
          .collection("chats")
          .doc(messageId)
          .set(messageInfo);
    } catch (e) {
      print("Error adding message: $e");
      // Handle the error gracefully, e.g., log the error, show a message to the user, etc.
      throw e; // Rethrow the error to propagate it further if needed
    }
  }

  updateLastMessageSend(String chatRoomId, Map<String, dynamic> lastMessageInfo) {
    return FirebaseFirestore.instance.collection("chatRooms").doc(chatRoomId).update(lastMessageInfo);
  }
}
