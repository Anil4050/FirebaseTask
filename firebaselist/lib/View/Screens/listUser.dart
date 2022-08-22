import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebaselist/Controller/userController.dart';
import 'package:firebaselist/View/Screens/editUser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils.dart';

class listUser extends StatelessWidget {
  listUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userController controller = Get.put(userController());

    editOption(index) {
      TextEditingController name =
          TextEditingController(text: controller.data[index]['name']);
      String response = '';
      var image;
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(child: new Text("Edit User")),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child: Image.memory(
                        base64Decode(controller.data[index]['image']),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          color: Colors.amberAccent,
                          icon: Icon(Icons.camera),
                          onPressed: () {
                            image = pickImage(ImageSource.camera);
                          },
                        ),
                        IconButton(
                          color: Colors.blueGrey,
                          icon: Icon(Icons.folder),
                          onPressed: () {
                            final image = pickImage(ImageSource.gallery);
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: TextField(
                        controller: name,
                        // onChanged: (val) {
                        //   userName = val;
                        // },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Your Name'),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () => {
                        response = controller.updateUser(
                            controller.data[index]['name'],
                            base64Encode(image!.readAsBytesSync()),
                            name.text),
                        response == 'Updated' ? Get.back() : null
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                            boxShadow: boxShadowContainer(),
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                            child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.to(editUser()),
          label: Row(
            children: [Text('AddUser '), Icon(Icons.add)],
          )),
      body: Container(
        padding: EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: controller.data.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.startToEnd) {
                } else {
                  print('Remove item');
                }
              },
              direction: DismissDirection.endToStart,
              background: SizedBox(),
              secondaryBackground: Container(
                color: Colors.red,
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      Text('Remove User',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Confirmation"),
                      content: const Text(
                          "Are you sure you want to delete this item?"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => controller.removeUser(
                                index, controller.data[index]['image']),
                            child: const Text("Delete")),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.symmetric(vertical: 7.0),
                decoration: BoxDecoration(
                    boxShadow: boxShadowContainer(),
                    color: Colors.white,
                    // border: Border.all(),
                    borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(
                            base64Decode(controller.data[index]['image']),
                          ),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: boxShadowContainer(),
                      ),
                    ),
                    Text(controller.data[index]['name'].toString()),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        editOption(index);
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
