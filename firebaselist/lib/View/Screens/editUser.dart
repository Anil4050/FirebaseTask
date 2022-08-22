import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebaselist/Controller/userController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class editUser extends StatefulWidget {
  const editUser({Key? key}) : super(key: key);

  @override
  State<editUser> createState() => _editUserState();
}

class _editUserState extends State<editUser> {
  userController controller = userController();
  File? image;

  var imagepath;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      image;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();

    boxShadowContainer() {
      return [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 0.5,
          blurRadius: 7,
          offset: const Offset(0, 0), // changes position of shadow
        )
      ];
    }

    Future pickImage(uploadFrom) async {
      try {
        final image = await ImagePicker().pickImage(source: uploadFrom);
        if (image == null) return;
        final imagepath = File(image.path);
        setState(() => this.image = imagepath);
      } on PlatformException catch (e) {
        print('Failed to pick image: $e');
      }
    }

    userImageAdd(context) {
      return Container(
          child: image == null
              ? Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        image = null;
                        pickImage(ImageSource.camera);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            boxShadow: boxShadowContainer(),
                            borderRadius: BorderRadius.circular(10.0)),
                        height: 100,
                        width: 100,
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                        ),
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        image = null;
                        pickImage(ImageSource.gallery);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            boxShadow: boxShadowContainer(),
                            borderRadius: BorderRadius.circular(10.0)),
                        height: 100,
                        width: 100,
                        child: Icon(
                          Icons.folder_copy_outlined,
                          color: Colors.white,
                        ),
                      ),
                    )),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.all(5.0),
                      child: Expanded(
                        child: Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    IconButton(
                        onPressed: () {
                          image = null;
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.cancel_outlined,
                          size: 50,
                          color: Colors.amber,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          boxShadow: boxShadowContainer(),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextButton(
                          onPressed: () {
                            var res = controller.addUserData(
                                base64Encode(image!.readAsBytesSync()),
                                name.value);
                            if (res == 'uploaded') {
                              setState(() {
                                image = null;
                              });
                            }
                          },
                          child: const Text(
                            'Add User',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                  ],
                ));
    }

    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15.0)),
                child: TextField(
                  controller: name,
                  // onChanged: (val) {
                  //   userName = val;
                  // },
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Enter Your Name'),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              userImageAdd(context),
              // image == null
              //     ? Container(
              //         height: 100,
              //         width: 100,
              //         child: Image.file(image!),
              //       )
              //     : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
