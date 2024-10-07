// ignore_for_file: file_names, unused_field, unused_local_variable, prefer_const_constructors, avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddRecipeImageController extends GetxController {
  final ImagePicker _picker =
      ImagePicker(); // image picker instance(image picker pkg)
  Rx<XFile?> selectedImage = Rx<XFile?>(
      null); // RX creates an observe able XFile(can be null or x file) initial value null

  //RxList<XFile> selectedIamges = <XFile>[].obs;
  final Rx<String?> arrImageUrl = Rx<String?>(null);
  //final RxList<String> arrImagesUrl = <String>[].obs;
  final FirebaseStorage storageRef = FirebaseStorage.instance;

  Future<void> showImagesPickerDialog() async {
    PermissionStatus status; //permisson handler pkg
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin(); //device info pkg
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

    if (androidDeviceInfo.version.sdkInt <= 32) {
      status = await Permission.storage.request();
    } else {
      status = await Permission.mediaLibrary.request();
    }

    //
    if (status == PermissionStatus.granted) {
      Get.defaultDialog(
        title: "Choose Image",
        middleText: "Pick an image from the camera or gallery?",
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              seletctImages("camera");
            },
            child: Text('Camera'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              seletctImages("gallery");
            },
            child: Text('Gallery'),
          ),
        ],
      );
    }
    if (status == PermissionStatus.denied) {
      print("Error please allow permission for further usage");
      openAppSettings();
    }
    if (status == PermissionStatus.permanentlyDenied) {
      print("Error please allow permission for further usage");
      openAppSettings();
    }
  }

  Future<void> seletctImages(String type) async {
    //List<XFile> imgs = [];
    XFile? img;
    if (type == 'gallery') {
      try {
        img = await _picker.pickImage(source: ImageSource.gallery);
        if (img != null) {
          selectedImage.value = img;
          update();
          print('Selected image: ${selectedImage.value!.path}');
        }
      } catch (e) {
        print('Error $e');
      }
    } else {
      final img =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);

      if (img != null) {
        selectedImage.value = img;
        update();
        print('Selected image: ${selectedImage.value!.path}');
      }
    }

    // if (img.isNotEmpty!) {
    //   selectedImage.;
    //   update();
    //   print(selectedIamge.length);
    // }
  }

  void removeImage() {
    selectedImage.value = null;
    update();
  }

  //
  Future<void> uploadFunction(Rx<XFile?> _image) async {
    arrImageUrl.value =
        null; //so url will be free every time and would not add previous uploaded images url
    // String imageUrl = await uplaodFile(_image);
    if (selectedImage.value != null) {
      String imageUrl = await uplaodFile(selectedImage.value!);
      arrImageUrl.value = imageUrl;
    }
    update();
  }

  //
  Future<String> uplaodFile(XFile _image) async {
    TaskSnapshot reference = await storageRef
        .ref()
        .child("image")
        .child(_image.name + DateTime.now().toString())
        .putFile(File(_image.path));

    return await reference.ref.getDownloadURL();
  }
}
