import 'dart:io';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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
    return File(image.path);
  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
  }
}
