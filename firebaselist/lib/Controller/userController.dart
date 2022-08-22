import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/userModel.dart';

class userController extends GetxController {
  List<User> usersList = [];
  late CollectionReference user =
      FirebaseFirestore.instance.collection('users');
  List data = [];
  @override
  void onInit() {
    super.onInit();

    getuserData();
  }

  removeUser(index, image) async {
    data.removeAt(index);
    await user.doc(image).delete();
    await getuserData();
  }

  updateUser(name, image, newName) async {
    try {
      await user.doc(name).update({"image": image, "name": newName});
      await getuserData();
      return 'Updated';
    } catch (e) {
      return e.toString();
    }
  }

  // addDataToSlider(objectData) async {}

  addUserData(image, userName) async {
    try {
      await user.add(
        {"image": image, "name": userName},
      );
      await getuserData();
      ScaffoldMessenger(
        child: Text("User Uploaded"),
      );
      return 'uploaded';
    } catch (e) {
      ScaffoldMessenger(
        child: Text(e.toString()),
      );
      print(e.toString());
    }
  }

  Future getuserData() async {
    List RequestList = [];
    data = [];

    try {
      await user.get().then(
        (QuerySnapshot) {
          QuerySnapshot.docs.forEach((element) {
            RequestList.add(element.data());
          });
          data.addAll(RequestList);
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
