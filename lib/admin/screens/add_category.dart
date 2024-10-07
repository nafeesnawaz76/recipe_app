import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:recipe_app/admin/controller/image_handler.dart';
import 'package:recipe_app/models/category_model.dart';
import 'package:recipe_app/services/id_generator.dart';
import 'package:recipe_app/widgets/dropdown.dart';
import 'package:recipe_app/widgets/loading.dart';
import 'package:recipe_app/widgets/textformfield.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddCategory> {
  final AddRecipeImageController _imageuploadController =
      Get.put(AddRecipeImageController());
  final SpinkitLoading loadingController = Get.put(SpinkitLoading());

  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("add Image"),
                  ElevatedButton(
                      onPressed: () {
                        _imageuploadController.showImagesPickerDialog();
                      },
                      child: const Text("select"))
                ],
              ),
              Obx(() {
                // Obx widget listens to changes in the controller's observable
                if (_imageuploadController.selectedImage.value != null) {
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(
                        File(_imageuploadController.selectedImage.value!.path)),
                  );
                } else {
                  return const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person),
                  );
                }
              }),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                  controller: _nameController, hinttxt: "Recipe name"),
              ElevatedButton(
                onPressed: () async {
                  loadingController.toggleLoading();
                  await _imageuploadController
                      .uploadFunction(_imageuploadController.selectedImage);

                  String categoryId = GenerateIds().generateCategoryId();

                  CategoryModel categoryModel = CategoryModel(
                      id: categoryId,
                      name: _nameController.text,
                      image: _imageuploadController.arrImageUrl.toString(),
                      createdOn: DateTime.now());

                  await FirebaseFirestore.instance
                      .collection('categories')
                      .doc(categoryId)
                      .set(categoryModel.toMap());
                  loadingController.toggleLoading();
                  Get.snackbar("Success", "Category added succefully");
                },
                child: Obx(() => loadingController.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Center(
                          child: SpinKitFadingCube(
                            color: Colors.cyan,
                            size: 30,
                          ),
                        ),
                      )
                    : const Text(
                        "Upload",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
