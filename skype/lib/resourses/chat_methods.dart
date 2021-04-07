
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype/constants/strings.dart';
import 'package:skype/models/contact.dart';
import 'package:skype/models/message.dart';
import 'package:skype/models/user.dart';
import 'package:skype/provider/Image_uploader.dart';

class ChatMethods {

  static final Firestore _firestore = Firestore.instance;

  final CollectionReference _messageCollection= _firestore.collection(MESSAGES_COLLECTION);
  final CollectionReference _userCollection= _firestore.collection(USERS_COLLECTION);
  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
    var map = message.toMap();

    await _messageCollection
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

addToContacts(senderId:message.senderId,receiverId:message.receiverId);

    return await _messageCollection
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    // create imagemap
    var map = message.toImageMap();

    // var map = Map<String, dynamic>();
    await _firestore
        .collection(MESSAGES_COLLECTION)
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    _firestore
        .collection(MESSAGES_COLLECTION)
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }
DocumentReference getContactDocument({String of,String forContact})=>
  _userCollection.document(of).collection(CONTACTS_COLLECTION).document(forContact);

  void addToContacts({String senderId, String receiverId}) async{
    Timestamp currentTime = Timestamp.now();

    await addToSendersContact(senderId, receiverId, currentTime);
    await addToReceiversContact(senderId, receiverId, currentTime);
    }
    Future<void> addToSendersContact(String senderId,String receiverId,currentTime)async{
DocumentSnapshot senderSnapshot= await getContactDocument(of:senderId,forContact:receiverId).get();
  
  if(!senderSnapshot.exists){
Contact receiverContact = Contact(uid:receiverId,addedOn: currentTime);

var receiverMap =receiverContact.toMap(receiverContact);
await getContactDocument(of:senderId,forContact:receiverId).setData(receiverMap);

  }
  
    }

    Future<void> addToReceiversContact(String senderId,String receiverId,currentTime)async{
DocumentSnapshot receiverSnapshot= await getContactDocument(of:receiverId ,forContact:senderId).get();
  
  if(!receiverSnapshot.exists){
Contact senderContact = Contact(uid:senderId,addedOn: currentTime);

var senderMap =senderContact.toMap(senderContact);
await getContactDocument(of:receiverId,forContact:senderId ).setData(senderMap);

  }
  
    }


Stream <QuerySnapshot> fetchContacts({String userId})
 => _userCollection.document(userId).collection(CONTACTS_COLLECTION).snapshots();

Stream <QuerySnapshot> fetchLastMessagesBetween({
  @required String senderId,
  @required String receiverId})=>
 _messageCollection.document(senderId).collection(receiverId).orderBy("timestamp").snapshots(); 

}